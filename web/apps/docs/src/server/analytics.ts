// The hub's two runtime analytics routes (mori://tan/tan-product-management/plans/26-record-hub-page-reads-in-kansoku-analytics),
// as pure functions of the configuration and the caller, adapted from the labs portal
// (mori://tan/tan-ng-labs, project-relative web/apps/portal/src/server/analytics.ts).
//
//   DOCS_ANALYTICS_CONFIG      literal JSON at run time (never a VITE_* build variable); unset,
//                             malformed or invalid is {"enabled":false}
//   DOCS_TRUST_FORWARDED_USER  exactly "1" trusts X-Forwarded-User, which nagare-access sets
//                             behind requireLogin; anything else, and the identity route is off
//   DOCS_DEV_FORWARDED_USER    development and tests only: a synthetic subject when no header
//                             is present; ignored when NODE_ENV=production
import { parseAnalyticsConfigJson, type DocsAnalyticsConfig } from "../lib/analytics/config"
import { validSubject } from "../lib/analytics/identity"

const privateHeaders = {
  "Cache-Control": "private, no-store",
  "X-Content-Type-Options": "nosniff",
}

export function analyticsConfig(): DocsAnalyticsConfig {
  return parseAnalyticsConfigJson(process.env.DOCS_ANALYTICS_CONFIG)
}

export function trustsForwardedUser(): boolean {
  return process.env.DOCS_TRUST_FORWARDED_USER === "1"
}

/** The signed-in subject: the trusted forwarded header, or the development fixture. */
export function forwardedSubject(header: string | null | undefined): string | null {
  if (header) return header
  if (process.env.NODE_ENV === "production") return null
  return process.env.DOCS_DEV_FORWARDED_USER || null
}

/** GET /analytics-config.json: only the validated public shape, never identity. */
export function analyticsConfigResponse(config: DocsAnalyticsConfig): Response {
  return Response.json(config, { headers: privateHeaders })
}

/**
 * GET /api/analytics/identity: 404 while analytics is disabled or the forwarded header is not
 * trusted, 204 without a valid subject, otherwise 200 with exactly that subject as plain text.
 * It logs nothing and sends no CORS headers.
 */
export function analyticsIdentityResponse(
  config: DocsAnalyticsConfig,
  trusted: boolean,
  subject: string | null,
): Response {
  if (!config.enabled || !trusted)
    return new Response(null, { status: 404, headers: privateHeaders })
  if (!validSubject(subject)) return new Response(null, { status: 204, headers: privateHeaders })
  return new Response(subject, {
    headers: { ...privateHeaders, "Content-Type": "text/plain; charset=utf-8" },
  })
}

export function methodNotAllowed(): Response {
  return new Response(null, { status: 405, headers: { ...privateHeaders, Allow: "GET" } })
}
