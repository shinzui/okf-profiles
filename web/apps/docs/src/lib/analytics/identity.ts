// Adapted from mori://tan/tan-product-management, project-relative
// web/apps/hub/src/lib/analytics/identity.ts (artifact URI pending).
import {
  analyticsTimeoutMs,
  bounded,
  type AnalyticsFetch,
  type EnabledAnalyticsConfig,
} from "./config"

/** One trusted subject: nonempty, at most 1024 characters, a single line without controls. */
export function validSubject(subject: string | null | undefined): subject is string {
  // oxlint-disable-next-line no-control-regex
  return !!subject?.trim() && subject.length <= 1024 && !/[\x00-\x1f\x7f-\x9f]/.test(subject)
}

/**
 * The signed-in subject from the reader's own identity route, or undefined when there is
 * none or it cannot be read in time. Redirects and other media types count as no subject.
 * The subject is never logged.
 */
export async function fetchAnalyticsIdentity(
  config: EnabledAnalyticsConfig,
  request: AnalyticsFetch = fetch,
  timeoutMs = analyticsTimeoutMs,
): Promise<string | undefined> {
  try {
    return await bounded(async (signal) => {
      const response = await request(config.identity.endpoint, {
        credentials: "same-origin",
        cache: "no-store",
        redirect: "error",
        signal,
      })
      if (
        response.status !== 200 ||
        response.redirected ||
        !/^text\/plain(?:\s*;|$)/i.test(response.headers.get("content-type") ?? "")
      )
        return undefined
      const subject = await response.text()
      return validSubject(subject) ? subject : undefined
    }, timeoutMs)
  } catch {
    return undefined
  }
}
