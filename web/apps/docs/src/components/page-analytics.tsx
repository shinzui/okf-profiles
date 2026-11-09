import type { Summary } from "@okf-profiles-web/corpus/types"
import { useRouterState } from "@tanstack/react-router"
import { useEffect, useRef, useState } from "react"

import { fetchAnalyticsConfig } from "../lib/analytics/config"
import { type AnalyticsController, createAnalyticsController } from "../lib/analytics/controller"
import { fetchAnalyticsIdentity } from "../lib/analytics/identity"
import { settledPage } from "../lib/analytics/pages"
import { loadAnalyticsSdk } from "../lib/analytics/sdk"

/**
 * Records a Kansoku page view for each settled, eligible page
 * (mori://tan/tan-product-management/plans/26-record-hub-page-reads-in-kansoku-analytics), adapted from the labs
 * portal's component. Renders nothing; does nothing until its effects run in the browser, and
 * nothing beyond fetching /analytics-config.json while analytics is disabled.
 */
export function PageAnalytics({ summaries }: { summaries: Summary[] }) {
  const observed = useRouterState({ select: (state) => settledPage(state, summaries) })
  // The last settled page: a pending navigation keeps the page being read until the next one
  // settles, so loading a route never ends or restarts a visit. Search changes (peek, filters)
  // leave the pathname, and so the visit, alone.
  const [page, setPage] = useState<{ pathname: string; title: string } | null>(null)
  if (
    observed !== undefined &&
    (observed?.pathname !== page?.pathname || observed?.title !== page?.title)
  ) {
    setPage(observed)
  }

  const controller = useRef<AnalyticsController | null>(null)
  useEffect(() => {
    const owner = createAnalyticsController({
      loadConfig: () => fetchAnalyticsConfig(window.location.origin),
      loadSdk: loadAnalyticsSdk,
      identity: (config) => fetchAnalyticsIdentity(config),
    })
    controller.current = owner
    // Returning to the tab after leaving it re-reads the identity (sign-out, another account).
    let away = document.visibilityState === "hidden"
    const leave = () => {
      away = true
    }
    const back = () => {
      if (document.visibilityState === "hidden") {
        away = true
        return
      }
      if (away) {
        away = false
        owner.refreshIdentity()
      }
    }
    window.addEventListener("blur", leave)
    window.addEventListener("focus", back)
    document.addEventListener("visibilitychange", back)
    return () => {
      window.removeEventListener("blur", leave)
      window.removeEventListener("focus", back)
      document.removeEventListener("visibilitychange", back)
      owner.dispose()
      controller.current = null
    }
  }, [])

  // Declared after the owner's effect, so on mount the controller exists when this runs.
  const pathname = page?.pathname
  const title = page?.title
  useEffect(() => {
    const owner = controller.current
    if (!owner || !pathname || !title) return
    return owner.visit({ url: window.location.origin + pathname, pathname, title })
  }, [pathname, title])

  return null
}
