import { Link as RouterLink, useRouterState } from "@tanstack/react-router"
import { Button, SearchField, NavigationDialog } from "@okf-profiles-web/ui/components"
import { catalog, groups, profileLabel, searchDocuments } from "@okf-profiles-web/corpus/catalog"
import { useCallback, useEffect, useState, type ReactNode } from "react"
import { CommandPalette } from "./command-palette"
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
  const toggleTheme = useCallback(
    () => setTheme((value) => (value === "dark" ? "light" : "dark")),
    [],
  )
  const profiles = catalog(collection.summaries)
  const changelog = collection.summaries.find((doc) => doc.path === "CHANGELOG.md")
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
          {changelog && (
            <li className="tree-link">
              <RouterLink
                to={changelog.href}
                aria-current={location === changelog.href ? "page" : undefined}
              >
                Changelog
              </RouterLink>
            </li>
          )}
          {groups.flatMap((group) => [
            <li key={group} className="tree-group">
              {group}
            </li>,
            ...profiles
              .filter((entry) => entry.group === group)
              .map((entry) => (
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
                              {doc.path.includes("/types/")
                                ? "Concept types index"
                                : "Bundle index"}
                            </RouterLink>
                          </li>
                        ))}
                    </ul>
                  </details>
                </li>
              )),
          ])}
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
        <CommandPalette
          summaries={collection.summaries}
          theme={theme}
          onToggleTheme={toggleTheme}
        />
        <Button onPress={toggleTheme} aria-label="Toggle theme">
          <svg aria-hidden="true" viewBox="0 0 24 24" width="16" height="16" className="theme-icon">
            {theme === "dark" ? (
              <>
                <circle cx="12" cy="12" r="4" />
                <path d="M12 2v2M12 20v2M4.9 4.9l1.4 1.4M17.7 17.7l1.4 1.4M2 12h2M20 12h2M4.9 19.1l1.4-1.4M17.7 6.3l1.4-1.4" />
              </>
            ) : (
              <path d="M20 14.5A8 8 0 0 1 9.5 4a8 8 0 1 0 10.5 10.5Z" />
            )}
          </svg>
        </Button>
      </header>
      <div className="layout">
        <aside className="profile-sidebar">{navigation}</aside>
        <main id="main">
          {current && (
            <nav className="breadcrumbs" aria-label="Breadcrumbs">
              <RouterLink to="/">Catalog</RouterLink>
              {active && (
                <>
                  <span aria-hidden="true"> / </span>
                  <RouterLink to={active.profile.href}>{profileLabel(current.bundle!)}</RouterLink>
                </>
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
