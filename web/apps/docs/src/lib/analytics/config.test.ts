// Adapted from mori://tan/tan-product-management, project-relative
// web/apps/hub/src/lib/analytics/config.test.ts (artifact URI pending).
import { expect, test } from "bun:test"

import {
  fetchAnalyticsConfig,
  parseAnalyticsConfig,
  parseAnalyticsConfigJson,
  type DocsAnalyticsConfig,
} from "./config"

const refused = async (): Promise<Response> => {
  throw new TypeError("network")
}
const stalled = () => new Promise<Response>(() => {})

const enabled = {
  enabled: true,
  baseUrl: "https://kansoku.labs.topagentnetwork.net/",
  writeKey: "ksk_w_public-Key_1",
  sourceService: "okf-profiles",
  identity: { mode: "required", endpoint: "/api/analytics/identity" },
}
const disabled: DocsAnalyticsConfig = { enabled: false }

test("a valid enabled configuration is kept, with the collector's trailing slash removed", () => {
  expect(parseAnalyticsConfig(enabled)).toEqual({
    ...enabled,
    enabled: true,
    baseUrl: "https://kansoku.labs.topagentnetwork.net",
  } as DocsAnalyticsConfig)
})

test("plain HTTP is accepted only for loopback collectors", () => {
  for (const host of ["localhost:4318", "127.0.0.1:4318", "[::1]:4318"])
    expect(parseAnalyticsConfig({ ...enabled, baseUrl: `http://${host}` }).enabled).toBe(true)
  expect(parseAnalyticsConfig({ ...enabled, baseUrl: "http://kansoku.example" })).toEqual(disabled)
})

test("anything else disables analytics", () => {
  const invalid: unknown[] = [
    null,
    [],
    "enabled",
    { enabled: false },
    { enabled: "true" },
    { ...enabled, enabled: 1 },
    { ...enabled, extra: true },
    { ...enabled, serviceToken: "ksk_s_secret" },
    { ...enabled, baseUrl: undefined },
    { ...enabled, baseUrl: "kansoku.example" },
    { ...enabled, baseUrl: "ftp://kansoku.example" },
    { ...enabled, baseUrl: "https://user:pass@kansoku.example" },
    { ...enabled, baseUrl: "https://kansoku.example/?key=1" },
    { ...enabled, baseUrl: "https://kansoku.example/#x" },
    { ...enabled, writeKey: "ksk_s_service_token" },
    { ...enabled, writeKey: "ksk_w_" },
    { ...enabled, writeKey: "ksk_w_has space" },
    { ...enabled, writeKey: 42 },
    { ...enabled, sourceService: "keiro-runtime-docs" },
    { ...enabled, identity: undefined },
    { ...enabled, identity: { mode: "optional", endpoint: "/api/analytics/identity" } },
    { ...enabled, identity: { mode: "required", endpoint: "https://evil.example/id" } },
    { ...enabled, identity: { mode: "required", endpoint: "/api/session" } },
    { ...enabled, identity: { ...enabled.identity, timeoutMs: 100 } },
  ]
  for (const value of invalid) expect(parseAnalyticsConfig(value)).toEqual(disabled)
})

test("the runtime JSON is disabled when unset, empty or malformed", () => {
  expect(parseAnalyticsConfigJson(undefined)).toEqual(disabled)
  expect(parseAnalyticsConfigJson("")).toEqual(disabled)
  expect(parseAnalyticsConfigJson("  ")).toEqual(disabled)
  expect(parseAnalyticsConfigJson("{enabled:true}")).toEqual(disabled)
  expect(parseAnalyticsConfigJson('{"enabled":false}')).toEqual(disabled)
  expect(parseAnalyticsConfigJson(JSON.stringify(enabled)).enabled).toBe(true)
})

const origin = "http://localhost:3000"
const json = (body: unknown, init?: ResponseInit) => async () => Response.json(body, init)

test("the browser validates the configuration it fetches", async () => {
  expect((await fetchAnalyticsConfig(origin, json(enabled))).enabled).toBe(true)
  expect(await fetchAnalyticsConfig(origin, json({ ...enabled, writeKey: "ksk_s_x" }))).toEqual(
    disabled,
  )
})

test("a failed, non-JSON, refused or slow configuration request disables analytics", async () => {
  expect(await fetchAnalyticsConfig(origin, json(enabled, { status: 404 }))).toEqual(disabled)
  const html = async () =>
    new Response(JSON.stringify(enabled), { headers: { "Content-Type": "text/html" } })
  expect(await fetchAnalyticsConfig(origin, html)).toEqual(disabled)
  expect(await fetchAnalyticsConfig(origin, refused)).toEqual(disabled)
  expect(await fetchAnalyticsConfig(origin, stalled, 20)).toEqual(disabled)
})

test("the configuration request is same-origin, uncached and refuses redirects", async () => {
  let seen: { url: string; init?: RequestInit } | undefined
  await fetchAnalyticsConfig(origin, async (url, init) => {
    seen = { url: String(url), init }
    return Response.json(disabled)
  })
  expect(seen?.url).toBe(`${origin}/analytics-config.json`)
  expect(seen?.init).toMatchObject({
    cache: "no-store",
    credentials: "same-origin",
    redirect: "error",
  })
})
