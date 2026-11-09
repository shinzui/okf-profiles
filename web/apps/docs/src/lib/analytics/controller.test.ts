// Adapted from mori://tan/tan-product-management, project-relative
// web/apps/hub/src/lib/analytics/controller.test.ts (artifact URI pending).
// The controller's ordering and races with an injected SDK; e2e/analytics.spec.ts proves the
// same behavior with the real SDK's serialized batches.
import { expect, test } from "bun:test"

import { parseAnalyticsConfig } from "./config"
import {
  type AnalyticsDependencies,
  type AnalyticsPage,
  createAnalyticsController,
  redactAnalyticsEvent,
} from "./controller"
import type { AnalyticsEvent, AnalyticsSdk, KansokuClient, KansokuOptions } from "./sdk"

const config = parseAnalyticsConfig({
  enabled: true,
  baseUrl: "http://127.0.0.1:4318",
  writeKey: "ksk_w_fixtures",
  sourceService: "okf-profiles",
  identity: { mode: "required", endpoint: "/api/analytics/identity" },
})

const origin = "https://labs.topagentnetwork.net"
const page = (pathname: string, title = pathname): AnalyticsPage => ({
  url: origin + pathname,
  pathname,
  title,
})
const home = page("/", "Home")
const engineering = page("/engineering", "Engineering · Directory")

type Call = { client: number; call: string; args: unknown[] }

function deferred<T>() {
  let resolve!: (value: T) => void
  let reject!: (error: unknown) => void
  const promise = new Promise<T>((done, fail) => {
    resolve = done
    reject = fail
  })
  return { promise, resolve, reject }
}

const settle = () => new Promise((done) => setTimeout(done, 0))

function harness(overrides: Partial<AnalyticsDependencies> = {}) {
  const calls: Call[] = []
  const options: KansokuOptions[] = []
  let subject: string | undefined = "user_alice"
  let sdkLoads = 0
  let identityReads = 0
  const sdk: AnalyticsSdk = {
    createKansoku(opts) {
      options.push(opts)
      const client = options.length - 1
      const record =
        (call: string) =>
        (...args: unknown[]) => {
          calls.push({ client, call, args })
        }
      return {
        identify: record("identify"),
        page: record("page"),
        start: record("start"),
        stop: record("stop"),
        shutdown: async (...args: unknown[]) => record("shutdown")(...args),
      } as unknown as KansokuClient
    },
  }
  const deferrals: (() => void)[] = []
  const controller = createAnalyticsController({
    loadConfig: async () => config,
    loadSdk: async () => {
      sdkLoads++
      return sdk
    },
    identity: async () => {
      identityReads++
      return subject
    },
    defer: (callback) => deferrals.push(callback),
    ...overrides,
  })
  return {
    controller,
    calls,
    options,
    views: () =>
      calls
        .filter((c) => c.call === "page")
        .map((c) =>
          Object.assign(
            { client: c.client },
            c.args[0] as { url: string; path: string; title: string },
          ),
        ),
    of: (call: string) => calls.filter((c) => c.call === call),
    setSubject: (next: string | undefined) => {
      subject = next
    },
    sdkLoads: () => sdkLoads,
    identityReads: () => identityReads,
    runDeferred: () => deferrals.splice(0).forEach((callback) => callback()),
  }
}

test("Home → Engineering → Home records three views on one identified client", async () => {
  const h = harness()
  let release = h.controller.visit(home)
  await settle()
  release()
  release = h.controller.visit(engineering)
  await settle()
  release()
  h.controller.visit(home)
  await settle()
  h.runDeferred()
  expect(h.views()).toEqual([
    { client: 0, url: `${origin}/`, path: "/", title: "Home" },
    {
      client: 0,
      url: `${origin}/engineering`,
      path: "/engineering",
      title: "Engineering · Directory",
    },
    { client: 0, url: `${origin}/`, path: "/", title: "Home" },
  ])
  expect(h.of("identify")).toEqual([
    { client: 0, call: "identify", args: ["user_alice", {}, { schemaVersion: 1 }] },
  ])
  expect(h.options).toHaveLength(1)
  expect(h.sdkLoads()).toBe(1)
})

test("the client uses the reader's fixed privacy and capture options", async () => {
  const h = harness()
  h.controller.visit(home)
  await settle()
  const options = h.options[0]!
  expect(options).toMatchObject({
    baseUrl: "http://127.0.0.1:4318",
    writeKey: "ksk_w_fixtures",
    sourceService: "okf-profiles",
    autoStart: false,
    autocapture: {
      pageViews: false,
      sessions: true,
      pageLeave: true,
      webVitals: true,
      clientErrors: true,
    },
    storage: "memory",
    persistQueue: false,
    storageKeyPrefix: "okf-profiles.okf-profiles",
    respectDoNotTrack: true,
    respectGlobalPrivacyControl: true,
    debug: false,
  })
  expect(typeof options.beforeSend).toBe("function")
  // Batching, retries and queue bounds stay at the SDK's reviewed defaults.
  for (const key of ["flushAt", "flushIntervalMs", "maxQueueSize", "maxRetries"] as const)
    expect(options[key]).toBeUndefined()
})

test("an effect's cleanup and immediate re-setup for the same page records it once", async () => {
  const h = harness()
  const release = h.controller.visit(home)
  await settle()
  release()
  release()
  h.controller.visit(home)
  await settle()
  h.runDeferred()
  expect(h.views()).toHaveLength(1)
  expect(h.of("shutdown")).toHaveLength(0)
})

test("leaving through a page that is not counted retires the client; returning counts again", async () => {
  const h = harness()
  const release = h.controller.visit(home)
  await settle()
  release()
  h.runDeferred()
  expect(h.of("shutdown")).toEqual([{ client: 0, call: "shutdown", args: [] }])
  h.controller.visit(home)
  await settle()
  expect(h.views().map((view) => view.client)).toEqual([0, 1])
})

test("disabled analytics never asks for an identity or loads the SDK", async () => {
  const h = harness({ loadConfig: async () => ({ enabled: false }) })
  h.controller.visit(home)
  await settle()
  expect(h.identityReads()).toBe(0)
  expect(h.sdkLoads()).toBe(0)
  expect(h.calls).toEqual([])
})

function makeClient(calls: Call[]): KansokuClient {
  const record =
    (call: string) =>
    (...args: unknown[]) => {
      calls.push({ client: 0, call, args })
    }
  return {
    identify: record("identify"),
    page: record("page"),
    start: record("start"),
    stop: record("stop"),
    shutdown: async () => record("shutdown")(),
  } as unknown as KansokuClient
}

for (const stage of ["config", "identity", "sdk"] as const) {
  test(`a late ${stage} cannot record a page already left`, async () => {
    const gate = deferred<void>()
    const calls: Call[] = []
    const controller = createAnalyticsController({
      loadConfig: async () => {
        if (stage === "config") await gate.promise
        return config
      },
      identity: async () => {
        if (stage === "identity") await gate.promise
        return "user_alice"
      },
      loadSdk: async () => {
        if (stage === "sdk") await gate.promise
        return { createKansoku: () => makeClient(calls) }
      },
      defer: () => {},
    })
    const release = controller.visit(home)
    await settle()
    release()
    controller.visit(engineering)
    await settle()
    gate.resolve()
    await settle()
    const views = calls.filter((c) => c.call === "page").map((c) => c.args[0])
    expect(views).toEqual([expect.objectContaining({ path: "/engineering" })])
  })
}

test("without a verified subject nothing is collected; a later visit asks again", async () => {
  const h = harness()
  h.setSubject(undefined)
  let release = h.controller.visit(home)
  await settle()
  expect(h.sdkLoads()).toBe(0)
  expect(h.calls).toEqual([])
  release()
  h.setSubject("user_alice")
  release = h.controller.visit(engineering)
  await settle()
  expect(h.views()).toEqual([expect.objectContaining({ path: "/engineering" })])
})

test("a changed identity retires the old client and records the page again for the new one", async () => {
  const h = harness()
  h.controller.visit(home)
  await settle()
  h.setSubject("user_bob")
  h.controller.refreshIdentity()
  await settle()
  expect(h.of("shutdown")).toEqual([{ client: 0, call: "shutdown", args: [] }])
  expect(h.of("identify").map((c) => [c.client, c.args[0]])).toEqual([
    [0, "user_alice"],
    [1, "user_bob"],
  ])
  expect(h.views().map((view) => view.client)).toEqual([0, 1])
  // Nothing reaches Alice's client after it was retired.
  const last = h.calls.findIndex((c) => c.client === 0 && c.call === "shutdown")
  expect(h.calls.slice(last + 1).every((c) => c.client === 1)).toBe(true)

  h.setSubject(undefined)
  h.controller.refreshIdentity()
  await settle()
  expect(h.of("shutdown").map((c) => c.client)).toEqual([0, 1])
  h.controller.visit(engineering)
  await settle()
  expect(h.views()).toHaveLength(2)
  expect(h.options).toHaveLength(2)
})

test("revalidating an unchanged identity records no extra view", async () => {
  const h = harness()
  h.controller.visit(home)
  await settle()
  h.controller.refreshIdentity()
  h.controller.refreshIdentity()
  await settle()
  expect(h.views()).toHaveLength(1)
  // The second refresh supersedes the first before it asks: one read per settled check.
  expect(h.identityReads()).toBe(2)
  // Pausing for the identity check stops listeners; the unchanged client starts again.
  expect(h.of("start").length).toBeGreaterThanOrEqual(2)
})

test("a failed SDK import collects nothing and is retried on the next visit", async () => {
  let attempts = 0
  const calls: Call[] = []
  const controller = createAnalyticsController({
    loadConfig: async () => config,
    identity: async () => "user_alice",
    loadSdk: async () => {
      attempts++
      if (attempts === 1) throw new Error("chunk failed")
      return { createKansoku: () => makeClient(calls) }
    },
    defer: () => {},
  })
  const release = controller.visit(home)
  await settle()
  expect(calls).toEqual([])
  release()
  controller.visit(engineering)
  await settle()
  expect(attempts).toBe(2)
  expect(calls.filter((c) => c.call === "page")).toHaveLength(1)
})

test("a client that cannot be created (blocked storage) leaves the controller usable", async () => {
  const h = harness({
    loadSdk: async () => ({
      createKansoku: () => {
        throw new DOMException("denied", "SecurityError")
      },
    }),
  })
  h.controller.visit(home)
  await settle()
  expect(h.calls).toEqual([])
  expect(() => h.controller.visit(engineering)).not.toThrow()
})

test("disposal retires the client and ignores later visits and releases", async () => {
  const h = harness()
  const release = h.controller.visit(home)
  await settle()
  h.controller.dispose()
  expect(h.of("shutdown")).toHaveLength(1)
  release()
  h.controller.visit(engineering)
  h.controller.refreshIdentity()
  await settle()
  h.runDeferred()
  expect(h.views()).toHaveLength(1)
  expect(h.of("shutdown")).toHaveLength(1)
})

test("redaction keeps only origin and pathname and drops referrer and UTM fields", () => {
  const event = {
    eventName: "page_view",
    url: "https://labs.topagentnetwork.net//admin/users/?sheet=user:secret#token",
    referrer: "https://evil.example/?q=secret",
    utmSource: "mail",
    utmCampaign: "c",
    properties: {
      url: "https://labs.topagentnetwork.net/admin/users?q=secret#frag",
      path: "/admin/users?q=secret",
      title: "Admin · Users",
      referrer: "https://evil.example/",
      utm_medium: "x",
    },
  } as unknown as AnalyticsEvent
  expect(redactAnalyticsEvent(event)).toEqual({
    eventName: "page_view",
    url: "https://labs.topagentnetwork.net/admin/users",
    properties: {
      url: "https://labs.topagentnetwork.net/admin/users",
      path: "/admin/users",
      title: "Admin · Users",
    },
  } as unknown as AnalyticsEvent)
})

test("redaction applies to every event kind and drops unsanitizable URLs", () => {
  const leave = {
    eventName: "page_leave",
    url: "https://labs.topagentnetwork.net/engineering?x=1",
    properties: { path: "/engineering#top", durationMs: 1200 },
  } as unknown as AnalyticsEvent
  expect(redactAnalyticsEvent(leave)).toMatchObject({
    url: "https://labs.topagentnetwork.net/engineering",
    properties: { path: "/engineering", durationMs: 1200 },
  })
  const identify = { eventName: "identify", properties: {} } as unknown as AnalyticsEvent
  expect(redactAnalyticsEvent(identify)).toEqual(identify)
  const bad = { eventName: "page_view", url: "javascript:alert(1)", properties: {} }
  expect(redactAnalyticsEvent(bad as unknown as AnalyticsEvent)).toBeNull()
})
