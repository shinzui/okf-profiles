import { Link as RouterLink } from "@tanstack/react-router"
import { Button, SearchField, NavigationDialog } from "@okf-profiles-web/ui/components"
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
  const [theme, setTheme] = useState("light")
  useEffect(() => {
    setTheme(localStorage.getItem("docs-theme") ?? "light")
  }, [])
  useEffect(() => {
    document.documentElement.dataset.theme = theme
    localStorage.setItem("docs-theme", theme)
  }, [theme])
  const results = collection.summaries.filter((d) =>
    `${d.title} ${d.description} ${d.identity}`.toLowerCase().includes(query.toLowerCase()),
  )
  const navigation = (
    <nav aria-label="Documents">
      <SearchField value={query} onChange={setQuery} />
      <ul>
        {results.map((d) => (
          <li key={d.identity}>
            <RouterLink to={d.href}>{d.title}</RouterLink>
          </li>
        ))}
      </ul>
      {results.length === 0 && <p>No documents found</p>}
    </nav>
  )
  return (
    <>
      <a className="skip" href="#main">
        Skip to content
      </a>
      <header className="masthead">
        <RouterLink to="/">{collection.siteName}</RouterLink>
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
        <aside>{navigation}</aside>
        <main id="main">
          {children}
          <footer>
            Revision <span data-testid="revision">{collection.commit}</span> · {collection.date}
          </footer>
        </main>
      </div>
    </>
  )
}
