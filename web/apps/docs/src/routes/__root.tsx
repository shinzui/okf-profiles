import { HeadContent, Outlet, Scripts, createRootRoute } from "@tanstack/react-router"
import type { ReactNode } from "react"
import { PageAnalytics } from "../components/page-analytics"
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
      <PageAnalytics summaries={Route.useLoaderData().summaries} />
      <Outlet />
    </Shell>
  ),
  shellComponent: Document,
  notFoundComponent: () => <h1>Document not found</h1>,
})
// Runs before first paint so a saved dark theme never flashes light.
const restoreTheme = `try{document.documentElement.dataset.theme=localStorage.getItem("docs-theme")||"light"}catch(e){}`
function Document({ children }: { children: ReactNode }) {
  return (
    <html lang="en" suppressHydrationWarning>
      <head>
        <script dangerouslySetInnerHTML={{ __html: restoreTheme }} />
        <HeadContent />
      </head>
      <body>
        {children}
        <Scripts />
      </body>
    </html>
  )
}
