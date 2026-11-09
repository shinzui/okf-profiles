// Adapted from mori://tan/tan-product-management, project-relative
// web/apps/hub/src/lib/analytics/identity.test.ts (artifact URI pending).
import { expect, test } from "bun:test"

import { parseAnalyticsConfig, type EnabledAnalyticsConfig } from "./config"
import { fetchAnalyticsIdentity } from "./identity"

const refused = async (): Promise<Response> => {
  throw new TypeError("network")
}
const stalled = () => new Promise<Response>(() => {})

const config = parseAnalyticsConfig({
  enabled: true,
  baseUrl: "http://127.0.0.1:4318",
  writeKey: "ksk_w_fixtures",
  sourceService: "okf-profiles",
  identity: { mode: "required", endpoint: "/api/analytics/identity" },
}) as EnabledAnalyticsConfig

const text =
  (body: string, init: ResponseInit = {}) =>
  async () =>
    new Response(body, {
      ...init,
      headers: { "Content-Type": "text/plain; charset=utf-8", ...init.headers },
    })

test("a 200 plain-text subject is the identity", async () => {
  expect(await fetchAnalyticsIdentity(config, text("user_alice"))).toBe("user_alice")
})

test("no subject, another media type or an invalid subject is no identity", async () => {
  const cases = [
    async () => new Response(null, { status: 204 }),
    text("", { status: 204 }),
    text("user_alice", { status: 404 }),
    async () => new Response("user_alice", { headers: { "Content-Type": "text/html" } }),
    async () => Response.json("user_alice"),
    text("   "),
    text("user\nalice"),
    text("user\u0085alice"),
    text("u".repeat(1025)),
  ]
  const subjects = await Promise.all(
    cases.map((request) => fetchAnalyticsIdentity(config, request)),
  )
  expect(subjects.every((subject) => subject === undefined)).toBe(true)
  expect(await fetchAnalyticsIdentity(config, text("u".repeat(1024)))).toBe("u".repeat(1024))
})

test("a refused or slow identity request is no identity", async () => {
  expect(await fetchAnalyticsIdentity(config, refused)).toBeUndefined()
  expect(await fetchAnalyticsIdentity(config, stalled, 20)).toBeUndefined()
})

test("the identity request is same-origin, uncached and refuses redirects", async () => {
  let seen: { url: string; init?: RequestInit } | undefined
  await fetchAnalyticsIdentity(config, async (url, init) => {
    seen = { url: String(url), init }
    return new Response(null, { status: 204 })
  })
  expect(seen?.url).toBe("/api/analytics/identity")
  expect(seen?.init).toMatchObject({
    cache: "no-store",
    credentials: "same-origin",
    redirect: "error",
  })
})
