import { createFileRoute } from "@tanstack/react-router"
import { getRequestHeader } from "@tanstack/react-start/server"

import {
  analyticsConfig,
  analyticsIdentityResponse,
  forwardedSubject,
  methodNotAllowed,
  trustsForwardedUser,
} from "../../../server/analytics"

// The signed-in subject the browser attributes page reads to, from nagare-access's
// X-Forwarded-User when DOCS_TRUST_FORWARDED_USER=1.
export const Route = createFileRoute("/api/analytics/identity")({
  server: {
    handlers: {
      GET: () =>
        analyticsIdentityResponse(
          analyticsConfig(),
          trustsForwardedUser(),
          forwardedSubject(getRequestHeader("x-forwarded-user")),
        ),
      ANY: () => methodNotAllowed(),
    },
  },
})
