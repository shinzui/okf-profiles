import { afterEach, describe, expect, it } from "bun:test"

import { parseAnalyticsConfig } from "../lib/analytics/config"
import {
  analyticsConfig,
  analyticsIdentityResponse,
  forwardedSubject,
  trustsForwardedUser,
} from "./analytics"

const enabled = parseAnalyticsConfig({
  enabled: true,
  baseUrl: "https://kansoku.example.test",
  writeKey: "ksk_w_test",
  sourceService: "okf-profiles",
  identity: { mode: "required", endpoint: "/api/analytics/identity" },
})

const environment = { ...process.env }
afterEach(() => {
  process.env = { ...environment }
})

describe("the analytics configuration", () => {
  it("is disabled when unset, malformed or for another service", () => {
    delete process.env.DOCS_ANALYTICS_CONFIG
    expect(analyticsConfig()).toEqual({ enabled: false })
    process.env.DOCS_ANALYTICS_CONFIG = "{not json"
    expect(analyticsConfig()).toEqual({ enabled: false })
    process.env.DOCS_ANALYTICS_CONFIG = JSON.stringify({ ...enabled, sourceService: "portal" })
    expect(analyticsConfig()).toEqual({ enabled: false })
  })

  it("trusts the forwarded header only for exactly 1", () => {
    for (const value of ["true", "yes", "0", ""]) {
      process.env.DOCS_TRUST_FORWARDED_USER = value
      expect(trustsForwardedUser()).toBe(false)
    }
    process.env.DOCS_TRUST_FORWARDED_USER = "1"
    expect(trustsForwardedUser()).toBe(true)
  })
})

describe("the identity route", () => {
  it("is off while disabled or untrusted, empty without a subject, plain text otherwise", async () => {
    expect(analyticsIdentityResponse({ enabled: false }, true, "user_a").status).toBe(404)
    expect(analyticsIdentityResponse(enabled, false, "user_a").status).toBe(404)
    expect(analyticsIdentityResponse(enabled, true, null).status).toBe(204)
    const response = analyticsIdentityResponse(enabled, true, "user_a")
    expect(response.status).toBe(200)
    expect(await response.text()).toBe("user_a")
    expect(response.headers.get("cache-control")).toBe("private, no-store")
    expect(response.headers.get("access-control-allow-origin")).toBeNull()
  })

  it("never uses the development subject in production", () => {
    process.env.DOCS_DEV_FORWARDED_USER = "user_fixture"
    process.env.NODE_ENV = "production"
    expect(forwardedSubject(null)).toBeNull()
    process.env.NODE_ENV = "development"
    expect(forwardedSubject(null)).toBe("user_fixture")
    expect(forwardedSubject("user_real")).toBe("user_real")
  })
})
