import { createFileRoute } from "@tanstack/react-router"
import { getAsset } from "../../server/reader.server"
export const Route = createFileRoute("/published/$")({
  server: {
    handlers: {
      GET: async ({ params }) => {
        const file = await getAsset(params._splat ?? "")
        return file
          ? new Response(Bun.file(file), { headers: { "X-Content-Type-Options": "nosniff" } })
          : new Response("Not found", { status: 404 })
      },
    },
  },
})
