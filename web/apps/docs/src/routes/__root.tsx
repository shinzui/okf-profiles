import { HeadContent, Outlet, Scripts, createRootRoute } from "@tanstack/react-router"
import type { ReactNode } from "react"
import { Shell } from "../components/shell"
import { getCollection } from "../server/content"
import css from "@okf-profiles-web/ui/styles/globals.css?url"
export const Route = createRootRoute({
  loader: () => getCollection(),
  head: ({ loaderData }) => ({
    meta: [
      { charSet: "utf-8" },
      { name: "viewport", content: "width=device-width, initial-scale=1" },
      { title: loaderData?.siteName ?? "Documentation" },
    ],
    links: [{ rel: "stylesheet", href: css }],
  }),
  component: () => (
    <Shell collection={Route.useLoaderData()}>
      <Outlet />
    </Shell>
  ),
  shellComponent: Document,
  notFoundComponent: () => <h1>Document not found</h1>,
})
function Document({ children }: { children: ReactNode }) {
  return (
    <html lang="en">
      <head>
        <HeadContent />
      </head>
      <body>
        {children}
        <Scripts />
      </body>
    </html>
  )
}
