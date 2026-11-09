import { expect, test } from "bun:test"
import type { Summary } from "@okf-profiles-web/corpus/types"
import { settledPage, type RouterSnapshot } from "./pages"
const summaries: Summary[] = [
  {
    path: "docs/profiles/features/profile.md",
    href: "/docs/docs/profiles/features/profile",
    title: "features",
    description: "",
    identity: "",
    bundle: "features",
    exportPath: null,
    headings: [],
    metadata: {},
  },
]
const state: RouterSnapshot = {
  status: "idle",
  isLoading: false,
  location: { pathname: "/" },
  resolvedLocation: { pathname: "/" },
  matches: [{ routeId: "__root__", status: "success" }],
}
test("only settled published routes define views", () => {
  expect(settledPage(state, summaries)).toEqual({ pathname: "/", title: "Catalog" })
  const pathname = summaries[0]!.href
  expect(
    settledPage({ ...state, location: { pathname }, resolvedLocation: { pathname } }, summaries),
  ).toEqual({ pathname, title: "Features · Overview" })
  for (const pathname of ["/docs/missing", "/healthz", "/api/analytics/identity"])
    expect(
      settledPage({ ...state, location: { pathname }, resolvedLocation: { pathname } }, summaries),
    ).toBeNull()
  expect(settledPage({ ...state, status: "pending" }, summaries)).toBeUndefined()
  expect(settledPage({ ...state, isLoading: true }, summaries)).toBeUndefined()
  expect(settledPage({ ...state, location: { pathname: "/other" } }, summaries)).toBeUndefined()
  for (const status of ["error", "notFound"])
    expect(settledPage({ ...state, matches: [{ routeId: "x", status }] }, summaries)).toBeNull()
  expect(
    settledPage(
      { ...state, matches: [{ routeId: "x", status: "success", globalNotFound: true }] },
      summaries,
    ),
  ).toBeNull()
})
