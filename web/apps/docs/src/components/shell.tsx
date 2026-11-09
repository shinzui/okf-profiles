import { Link as RouterLink, useRouterState } from "@tanstack/react-router"
import { Button, SearchField, NavigationDialog } from "@okf-profiles-web/ui/components"
import { catalog, profileLabel, searchDocuments } from "@okf-profiles-web/corpus/catalog"
import { useEffect, useState, type ReactNode } from "react"
import type { getCollection } from "../server/content"
export function Shell({
  collection,
  children,
}: {
  collection: Awaited<ReturnType<typeof getCollection>>
  children: ReactNode
}) {
  const [query, setQuery] = useState("")
  const [theme, setTheme] = useState<string | null>(null)
  const location = useRouterState({ select: (state) => state.location.pathname })
  useEffect(() => {
    setTheme(localStorage.getItem("docs-theme") ?? "light")
  }, [])
  useEffect(() => {
    if (!theme) return
    document.documentElement.dataset.theme = theme
    localStorage.setItem("docs-theme", theme)
  }, [theme])
  const profiles = catalog(collection.summaries)
  const allResults = searchDocuments(collection.summaries, query)
  const results = allResults.slice(0, 100)
  const current = collection.summaries.find((doc) => doc.href === location)
  const active = profiles.find((entry) => entry.profile.bundle === current?.bundle)
  const navigation = (
    <nav aria-label="Profiles">
      <SearchField value={query} onChange={setQuery} />
      {query.trim() ? (
        <>
          <p className="search-count" role="status">
            {allResults.length
              ? `${allResults.length} results${allResults.length > 100 ? " · showing first 100" : ""}`
              : "No documents found"}
          </p>
          <ul className="search-results">
            {results.map((result) => (
              <li key={result.href}>
                <RouterLink to={result.href}>
                  <span className="result-profile">{result.profile}</span>
                  {result.title}
                </RouterLink>
              </li>
            ))}
          </ul>
        </>
      ) : (
        <ul className="profile-tree">
          {profiles.map((entry) => (
            <li key={entry.profile.path}>
              <details open={entry.profile.bundle === current?.bundle || undefined}>
                <summary>{entry.name}</summary>
                <ul>
                  <li>
                    <RouterLink
                      to={entry.profile.href}
                      aria-current={location === entry.profile.href ? "page" : undefined}
                    >
                      Overview
                    </RouterLink>
                  </li>
                  {entry.types.map((doc) => (
                    <li key={doc.path}>
                      <RouterLink
                        to={doc.href}
                        aria-current={location === doc.href ? "page" : undefined}
                      >
                        {doc.title}
                      </RouterLink>
                    </li>
                  ))}
                  {entry.pages
                    .filter((doc) => doc.path.endsWith("/index.md"))
                    .map((doc) => (
                      <li key={doc.path}>
                        <RouterLink
                          to={doc.href}
                          aria-current={location === doc.href ? "page" : undefined}
                        >
                          {doc.path.includes("/types/") ? "Concept types index" : "Bundle index"}
                        </RouterLink>
                      </li>
                    ))}
                </ul>
              </details>
            </li>
          ))}
        </ul>
      )}
    </nav>
  )
  return (
    <>
      <a className="skip" href="#main">
        Skip to content
      </a>
      <header className="masthead">
        <RouterLink to="/" className="brand">
          <span aria-hidden="true" className="brand-mark">
            O
          </span>
          {collection.siteName}
        </RouterLink>
        <span className="masthead-note">The profile reference</span>
        <div className="mobile">
          <NavigationDialog>{navigation}</NavigationDialog>
        </div>
        <Button
          onPress={() => setTheme(theme === "dark" ? "light" : "dark")}
          aria-label="Toggle theme"
        >
          {theme === "dark" ? "Light" : "Dark"}
        </Button>
      </header>
      <div className="layout">
        <aside className="profile-sidebar">{navigation}</aside>
        <main id="main">
          {current && (
            <nav className="breadcrumbs" aria-label="Breadcrumbs">
              <RouterLink to="/">Catalog</RouterLink>
              <span aria-hidden="true"> / </span>
              {active && (
                <RouterLink to={active.profile.href}>{profileLabel(current.bundle!)}</RouterLink>
              )}
              {!current.path.endsWith("/profile.md") && (
                <>
                  <span aria-hidden="true"> / </span>
                  <span>{current.path.endsWith("/index.md") ? "Index" : current.title}</span>
                </>
              )}
            </nav>
          )}
          {children}
          <footer>
            Generated from Dhall ·{" "}
            <span>
              Revision <span data-testid="revision">{collection.commit}</span>
            </span>
          </footer>
        </main>
      </div>
    </>
  )
}
