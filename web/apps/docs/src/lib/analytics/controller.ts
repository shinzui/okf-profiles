// Adapted from mori://tan/tan-product-management, project-relative
// web/apps/hub/src/lib/analytics/controller.ts (artifact URI pending).
// The browser's analytics lifetime, copied from the labs portal (mori://tan/tan-ng-labs,
// project-relative web/apps/portal/src/lib/analytics/controller.ts), itself adapted from
// mori://shinzui/keiro-runtime-docs src/lib/analytics/controller.ts (artifact URIs pending). Constructing it does nothing; the
// first visit loads the configuration, then the identity, then the SDK. Every await is
// followed by a check that the visit it serves is still current, so a late answer for a page
// the reader already left can never record it.
import type { EnabledAnalyticsConfig, DocsAnalyticsConfig } from "./config"
import type { AnalyticsEvent, AnalyticsSdk, KansokuClient } from "./sdk"

/** A rendered documentation page: `url` is origin plus pathname, `title` its handle-only title. */
export type AnalyticsPage = { url: string; pathname: string; title: string }

export type AnalyticsDependencies = {
  loadConfig: () => Promise<DocsAnalyticsConfig>
  loadSdk: () => Promise<AnalyticsSdk>
  identity: (config: EnabledAnalyticsConfig) => Promise<string | undefined>
  now?: () => number
  /** When a released visit retires its client unless another visit replaced it; tests inject it. */
  defer?: (callback: () => void) => void
}

export type AnalyticsController = {
  /** Registers the page being read; the returned function releases it (idempotent). */
  visit(page: AnalyticsPage): () => void
  /** Re-reads the identity for the current visit, e.g. on return to the tab. */
  refreshIdentity(): void
  dispose(): void
}

function withoutAttribution<T extends Record<string, unknown>>(fields: T): T {
  const result = { ...fields }
  for (const key of Object.keys(result)) {
    if (key.toLowerCase() === "referrer" || /^utm/i.test(key)) delete result[key]
  }
  return result
}

/** Origin plus pathname with repeated and trailing slashes collapsed, or null if not http(s). */
export function sanitizeUrl(raw: string): { url: string; pathname: string } | null {
  try {
    const url = new URL(raw)
    if (url.protocol !== "http:" && url.protocol !== "https:") return null
    const pathname = url.pathname.replace(/\/{2,}/g, "/").replace(/\/$/, "") || "/"
    return { url: url.origin + pathname, pathname }
  } catch {
    return null
  }
}

/**
 * The SDK's `beforeSend`: every event kind (identify, session, page view, page leave) keeps
 * only origin and pathname in both the envelope and its properties, and loses referrer and
 * UTM fields. An event whose URL cannot be sanitized is dropped.
 */
export function redactAnalyticsEvent(event: AnalyticsEvent): AnalyticsEvent | null {
  const result = withoutAttribution(event)
  result.properties = withoutAttribution(event.properties ?? {})
  for (const raw of [result.url, result.properties.url]) {
    if (raw !== undefined && (typeof raw !== "string" || !sanitizeUrl(raw))) return null
  }
  if (typeof result.url === "string") result.url = sanitizeUrl(result.url)!.url
  if (typeof result.properties.url === "string") {
    const clean = sanitizeUrl(result.properties.url)!
    result.properties.url = clean.url
    result.properties.path = clean.pathname
  } else if (typeof result.properties.path === "string") {
    result.properties.path = result.properties.path.split(/[?#]/)[0] || "/"
  }
  return result
}

const safely = (action: () => void) => {
  try {
    action()
  } catch {
    // Observations never break the reader.
  }
}

export function createAnalyticsController(
  dependencies: AnalyticsDependencies,
): AnalyticsController {
  let disposed = false
  let generation = 0
  let current: { token: symbol; page: AnalyticsPage } | undefined
  let configPromise: Promise<DocsAnalyticsConfig> | undefined
  let sdkPromise: Promise<AnalyticsSdk | undefined> | undefined
  let active: { client: KansokuClient; subject: string } | undefined
  /** The visit (page and subject) the active client already recorded. */
  let captured: string | undefined
  const defer = dependencies.defer ?? queueMicrotask

  function pause() {
    if (active) safely(() => active!.client.stop())
  }

  // Queued events keep the subject they were built with; shutdown flushes them best effort.
  function retire() {
    const previous = active
    active = undefined
    captured = undefined
    if (previous) {
      safely(() => previous.client.stop())
      safely(() => void previous.client.shutdown().catch(() => {}))
    }
  }

  function create(sdk: AnalyticsSdk, config: EnabledAnalyticsConfig, subject: string) {
    const client = sdk.createKansoku({
      baseUrl: config.baseUrl,
      writeKey: config.writeKey,
      sourceService: config.sourceService,
      autoStart: false,
      // The reader records a view only for a settled, eligible page (src/components/page-analytics.tsx).
      autocapture: {
        pageViews: false,
        sessions: true,
        pageLeave: true,
        webVitals: true,
        clientErrors: true,
      },
      storage: "memory",
      persistQueue: false,
      storageKeyPrefix: `okf-profiles.${config.sourceService}`,
      respectDoNotTrack: true,
      respectGlobalPrivacyControl: true,
      beforeSend: redactAnalyticsEvent,
      now: dependencies.now,
      // SDK diagnostics can contain event details; keep them out of browser logs.
      debug: false,
    })
    // Identity only (schema version 1): no name, email or other traits.
    client.identify(subject, {}, { schemaVersion: 1 })
    return { client, subject }
  }

  async function reconcile() {
    const attempt = ++generation
    const registration = current
    const valid = () =>
      !disposed && !!registration && current === registration && attempt === generation
    try {
      configPromise ??= dependencies.loadConfig()
      const config = await configPromise
      if (!valid() || !config.enabled) return
      const subject = await dependencies.identity(config).catch(() => undefined)
      if (!valid()) return
      if (active && active.subject !== subject) retire()
      // No verified subject, no collection; a later visit or return to the tab asks again.
      if (!subject) return
      if (!active) {
        sdkPromise ??= dependencies.loadSdk().catch(() => {
          sdkPromise = undefined
          return undefined
        })
        const sdk = await sdkPromise
        if (!valid() || !sdk) return
        active = create(sdk, config, subject)
      }
      active.client.start()
      const page = registration!.page
      const visit = JSON.stringify([page.url, subject])
      if (captured !== visit) {
        active.client.page({ url: page.url, path: page.pathname, title: page.title })
        captured = visit
      }
    } catch {
      if (valid()) retire()
    }
  }

  return {
    visit(page) {
      if (disposed) return () => {}
      const registration = { token: Symbol("visit"), page }
      current = registration
      pause()
      void reconcile()
      let released = false
      return () => {
        if (released) return
        released = true
        if (disposed || current?.token !== registration.token) return
        current = undefined
        generation++
        pause()
        // React runs an effect's cleanup and its next setup back to back: keep the client
        // when a new visit arrives at once, retire it on a genuine departure.
        const departure = generation
        defer(() => {
          if (!disposed && !current && generation === departure) retire()
        })
      }
    },
    refreshIdentity() {
      if (disposed || !current) return
      pause()
      void reconcile()
    },
    dispose() {
      if (disposed) return
      disposed = true
      current = undefined
      generation++
      retire()
    },
  }
}
