import { createFileRoute } from "@tanstack/react-router"

import { analyticsConfig, analyticsConfigResponse, methodNotAllowed } from "../server/analytics"

// The browser's public analytics configuration; `{"enabled":false}` unless DOCS_ANALYTICS_CONFIG
// holds a valid enabled configuration.
export const Route = createFileRoute("/analytics-config.json")({
  server: {
    handlers: {
      GET: () => analyticsConfigResponse(analyticsConfig()),
      ANY: () => methodNotAllowed(),
    },
  },
})
