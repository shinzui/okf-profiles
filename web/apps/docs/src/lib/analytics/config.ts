// Adapted from mori://tan/tan-product-management, project-relative
// web/apps/hub/src/lib/analytics/config.ts (artifact URI pending).
// The public analytics configuration (mori://tan/tan-product-management/plans/26-record-hub-page-reads-in-kansoku-analytics),
// adapted from the labs portal (mori://tan/tan-ng-labs, project-relative
// web/apps/portal/src/lib/analytics/config.ts). The server validates `DOCS_ANALYTICS_CONFIG` with this and serves only the result at
// /analytics-config.json; the browser validates what it fetches again before using it.

export type EnabledAnalyticsConfig = {
  enabled: true
  /** Kansoku's public ingest origin, without a trailing slash. */
  baseUrl: string
  /** The reader's public write key (`ksk_w_...`); never a metrics service token. */
  writeKey: string
  sourceService: "okf-profiles"
  identity: { mode: "required"; endpoint: "/api/analytics/identity" }
}

export type DocsAnalyticsConfig = { enabled: false } | EnabledAnalyticsConfig

export const disabledAnalytics: DocsAnalyticsConfig = { enabled: false }

/** How long the browser waits for the configuration and for its identity. */
export const analyticsTimeoutMs = 2000

export const analyticsIdentityEndpoint = "/api/analytics/identity"

const loopbackHosts = new Set(["localhost", "127.0.0.1", "[::1]"])

function isObject(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null && !Array.isArray(value)
}

function onlyKeys(value: Record<string, unknown>, allowed: string[]): boolean {
  return Object.keys(value).every((key) => allowed.includes(key))
}

function collectorBase(value: unknown): string | null {
  if (typeof value !== "string") return null
  let url: URL
  try {
    url = new URL(value)
  } catch {
    return null
  }
  if (url.protocol !== "https:" && url.protocol !== "http:") return null
  if (url.protocol === "http:" && !loopbackHosts.has(url.hostname)) return null
  if (url.username || url.password || url.search || url.hash || value.includes("#")) return null
  return url.href.replace(/\/+$/, "")
}

/**
 * The validated public configuration, or disabled for anything else: unknown fields, a
 * non-HTTPS or credential-bearing collector, a key that is not a public write key, or a
 * source service or identity policy other than the reader's.
 */
export function parseAnalyticsConfig(value: unknown): DocsAnalyticsConfig {
  if (!isObject(value) || value.enabled !== true) return disabledAnalytics
  if (!onlyKeys(value, ["enabled", "baseUrl", "writeKey", "sourceService", "identity"]))
    return disabledAnalytics
  const baseUrl = collectorBase(value.baseUrl)
  if (!baseUrl) return disabledAnalytics
  const { writeKey, sourceService, identity } = value
  if (typeof writeKey !== "string" || !/^ksk_w_[A-Za-z0-9_-]+$/.test(writeKey))
    return disabledAnalytics
  if (sourceService !== "okf-profiles") return disabledAnalytics
  if (
    !isObject(identity) ||
    !onlyKeys(identity, ["mode", "endpoint"]) ||
    identity.mode !== "required" ||
    identity.endpoint !== analyticsIdentityEndpoint
  )
    return disabledAnalytics
  return {
    enabled: true,
    baseUrl,
    writeKey,
    sourceService,
    identity: { mode: "required", endpoint: analyticsIdentityEndpoint },
  }
}

/** Parses the literal JSON of `DOCS_ANALYTICS_CONFIG`; unset, empty or malformed is disabled. */
export function parseAnalyticsConfigJson(raw: string | undefined): DocsAnalyticsConfig {
  if (!raw?.trim()) return disabledAnalytics
  try {
    return parseAnalyticsConfig(JSON.parse(raw))
  } catch {
    return disabledAnalytics
  }
}

export type AnalyticsFetch = (
  input: string | URL | Request,
  init?: RequestInit,
) => Promise<Response>

/** Runs `operation` with an abort signal, rejecting once `timeoutMs` passes (stalled bodies too). */
export async function bounded<T>(
  operation: (signal: AbortSignal) => Promise<T>,
  timeoutMs: number,
): Promise<T> {
  const abort = new AbortController()
  let timer: ReturnType<typeof setTimeout> | undefined
  try {
    return await Promise.race([
      operation(abort.signal),
      new Promise<never>((_, reject) => {
        timer = setTimeout(() => {
          abort.abort()
          reject(new Error("timeout"))
        }, timeoutMs)
      }),
    ])
  } finally {
    clearTimeout(timer)
  }
}

/** The browser's view of the configuration: disabled on any failure, timeout or non-JSON answer. */
export async function fetchAnalyticsConfig(
  origin: string,
  request: AnalyticsFetch = fetch,
  timeoutMs = analyticsTimeoutMs,
): Promise<DocsAnalyticsConfig> {
  try {
    return await bounded(async (signal) => {
      const response = await request(new URL("/analytics-config.json", origin), {
        cache: "no-store",
        credentials: "same-origin",
        redirect: "error",
        signal,
      })
      if (!response.ok || !/^application\/json\b/i.test(response.headers.get("content-type") ?? ""))
        return disabledAnalytics
      return parseAnalyticsConfig(await response.json())
    }, timeoutMs)
  } catch {
    return disabledAnalytics
  }
}
