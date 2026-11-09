import { profileLabel } from "@okf-profiles-web/corpus/catalog"
import type { Summary } from "@okf-profiles-web/corpus/types"

export type RouterSnapshot = {
  status: "pending" | "idle"
  isLoading: boolean
  location: { pathname: string }
  resolvedLocation?: { pathname: string }
  matches: ReadonlyArray<{ routeId: string; status: string; globalNotFound?: boolean }>
}
export function normalizePathname(pathname: string) {
  return pathname.replace(/\/{2,}/g, "/").replace(/\/$/, "") || "/"
}
export function pageTitle(pathname: string, summaries: Summary[]): string | null {
  if (pathname === "/") return "Catalog"
  const doc = summaries.find((summary) => summary.href === pathname)
  if (!doc) return null
  const title = doc.path.endsWith("/types/index.md")
    ? "Concept types"
    : doc.path.endsWith("/index.md")
      ? "Bundle index"
      : doc.path.endsWith("/profile.md")
        ? "Overview"
        : doc.title
  return doc.bundle ? `${profileLabel(doc.bundle)} · ${title}` : title
}
// Queries, section fragments, search fields and disclosures never define a visit.
export function settledPage(state: RouterSnapshot, summaries: Summary[]) {
  if (state.status !== "idle" || state.isLoading) return undefined
  const resolved = state.resolvedLocation?.pathname
  if (resolved === undefined || resolved !== state.location.pathname) return undefined
  if (
    !state.matches.length ||
    state.matches.some((match) => match.status !== "success" || match.globalNotFound)
  )
    return null
  const pathname = normalizePathname(resolved)
  const title = pageTitle(pathname, summaries)
  return title ? { pathname, title } : null
}
