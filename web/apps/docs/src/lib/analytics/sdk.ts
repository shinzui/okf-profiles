// Adapted from mori://tan/tan-product-management, project-relative
// web/apps/hub/src/lib/analytics/sdk.ts (artifact URI pending).
// The only module that touches the vendored Kansoku SDK snapshot (src/vendor/kansoku-js).
// The import is dynamic, so the SDK is a separate chunk fetched only once analytics is
// enabled and a subject is verified.
export type {
  AnalyticsEvent,
  KansokuClient,
  KansokuOptions,
} from "../../vendor/kansoku-js/index.js"

export type AnalyticsSdk = Pick<typeof import("../../vendor/kansoku-js/index.js"), "createKansoku">

export function loadAnalyticsSdk(): Promise<AnalyticsSdk> {
  return import("../../vendor/kansoku-js/index.js")
}
