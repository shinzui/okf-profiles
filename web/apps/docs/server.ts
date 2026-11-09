// Adapted from mori://TanStack/router (MIT), project-relative
// router/examples/react/start-bun/server.ts; source artifact URI pending.
import { readdir, readFile } from "node:fs/promises"
import path from "node:path"

const root = import.meta.dir
process.env.DOCS_CONTENT_ROOT = path.resolve(
  process.env.DOCS_CONTENT_ROOT ?? path.join(root, "../.."),
)
process.env.DOCS_SITE_NAME = (await readFile(path.join(root, "site-name.txt"), "utf8")).trim()
const { default: handler } = await import(path.join(root, "dist/server/server.js"))
const client = path.join(root, "dist/client")
const routes: Record<string, () => Response> = {}
for (const entry of await readdir(client, { recursive: true, withFileTypes: true })) {
  if (!entry.isFile()) continue
  const file = path.join(entry.parentPath, entry.name)
  const url = "/" + path.relative(client, file).split(path.sep).join("/")
  routes[url] = () =>
    new Response(Bun.file(file), {
      headers: {
        "Cache-Control": url.startsWith("/assets/")
          ? "public, max-age=31536000, immutable"
          : "public, max-age=0, must-revalidate",
      },
    })
}
Bun.serve({
  hostname: "0.0.0.0",
  port: Number(process.env.PORT ?? 8080),
  routes,
  async fetch(request) {
    if (new URL(request.url).pathname === "/healthz") {
      let commit = process.env.DOCS_COMMIT ?? "unknown"
      try {
        commit = JSON.parse(
          await readFile(
            path.join(process.env.DOCS_CONTENT_ROOT!, "content-inventory.json"),
            "utf8",
          ),
        ).commit
      } catch {
        /* Development has no snapshot. */
      }
      return Response.json({ status: "ok", commit }, { headers: { "Cache-Control": "no-store" } })
    }
    return handler.fetch(request)
  },
})
