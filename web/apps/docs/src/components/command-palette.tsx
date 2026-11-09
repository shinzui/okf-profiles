import { Link as RouterLink } from "@tanstack/react-router"
import { catalog, searchDocuments } from "@okf-profiles-web/corpus/catalog"
import type { Summary } from "@okf-profiles-web/corpus/types"
import { CommandDialog } from "@okf-profiles-web/ui/components"
import { useEffect, useId, useMemo, useRef, useState, type KeyboardEvent } from "react"

interface Item {
  id: string
  group: string
  title: string
  context?: string
  href?: string
  run?: () => void
}
const isApple = () => /Mac|iPhone|iPad/.test(navigator.platform)
const RESULT_LIMIT = 50

export function CommandPalette({
  summaries,
  theme,
  onToggleTheme,
}: {
  summaries: Summary[]
  theme: string | null
  onToggleTheme: () => void
}) {
  const [isOpen, setOpen] = useState(false)
  const [query, setQuery] = useState("")
  const [active, setActive] = useState(0)
  const [shortcut, setShortcut] = useState("⌘K")
  const list = useRef<HTMLUListElement>(null)
  const listId = useId()

  useEffect(() => {
    if (!isApple()) setShortcut("Ctrl K")
    const onKeyDown = (event: globalThis.KeyboardEvent) => {
      // Ctrl-K stays the kill-to-end-of-line text shortcut on Apple platforms.
      const modifier = isApple() ? event.metaKey : event.ctrlKey
      if (!modifier || event.shiftKey || event.altKey || event.key.toLowerCase() !== "k") return
      event.preventDefault()
      setOpen((open) => !open)
    }
    window.addEventListener("keydown", onKeyDown)
    return () => window.removeEventListener("keydown", onKeyDown)
  }, [])

  useEffect(() => {
    if (!isOpen) return
    setQuery("")
    setActive(0)
  }, [isOpen])

  const items = useMemo<Item[]>(() => {
    const changelog = summaries.find((doc) => doc.path === "CHANGELOG.md")
    const commands: Item[] = [
      { id: "catalog", group: "Go to", title: "Profile catalog", href: "/" },
      ...(changelog
        ? [{ id: "changelog", group: "Go to", title: "Changelog", href: changelog.href }]
        : []),
      {
        id: "theme",
        group: "Actions",
        title: `Switch to ${theme === "dark" ? "light" : "dark"} theme`,
        run: onToggleTheme,
      },
    ]
    const terms = query.toLowerCase().trim().split(/\s+/).filter(Boolean)
    if (!terms.length)
      return [
        ...commands,
        ...catalog(summaries).map((entry) => ({
          id: entry.profile.href,
          group: "Profiles",
          title: entry.name,
          context: entry.group,
          href: entry.profile.href,
        })),
      ]
    return [
      ...commands.filter((item) => terms.every((term) => item.title.toLowerCase().includes(term))),
      ...searchDocuments(summaries, query)
        .slice(0, RESULT_LIMIT)
        .map((result) => ({
          id: result.href,
          group: "Results",
          title: result.title,
          context: result.profile,
          href: result.href,
        })),
    ]
  }, [summaries, query, theme, onToggleTheme])

  useEffect(() => {
    list.current?.querySelector('[aria-selected="true"]')?.scrollIntoView({ block: "nearest" })
  }, [active, items])

  const optionId = (index: number) => `${listId}-${index}`
  const choose = (index: number) => {
    const item = items[index]
    if (!item) return
    if (item.href) {
      // Navigate through the real link so the router handles paths and fragments alike.
      list.current?.querySelector<HTMLAnchorElement>(`[id="${optionId(index)}"] a`)?.click()
      return
    }
    item.run?.()
    setOpen(false)
  }
  const onKeyDown = (event: KeyboardEvent<HTMLInputElement>) => {
    if (event.nativeEvent.isComposing) return
    const move = { ArrowDown: 1, ArrowUp: -1 }[event.key]
    if (move && items.length) {
      event.preventDefault()
      setActive((current) => (current + move + items.length) % items.length)
    } else if (event.key === "Enter") {
      event.preventDefault()
      choose(active)
    }
  }

  return (
    <>
      <button
        type="button"
        className="button palette-trigger"
        aria-label="Open command palette"
        aria-keyshortcuts="Meta+K Control+K"
        onClick={() => setOpen(true)}
      >
        <span>Search</span>
        <kbd>{shortcut}</kbd>
      </button>
      <CommandDialog isOpen={isOpen} onOpenChange={setOpen}>
        <div className="palette-search">
          <input
            autoFocus
            role="combobox"
            aria-label="Search the reference"
            aria-expanded="true"
            aria-controls={listId}
            aria-autocomplete="list"
            aria-activedescendant={items.length ? optionId(active) : undefined}
            placeholder="Search profiles, types, fields, releases…"
            autoComplete="off"
            spellCheck={false}
            value={query}
            onChange={(event) => {
              setQuery(event.target.value)
              setActive(0)
            }}
            onKeyDown={onKeyDown}
          />
        </div>
        <ul id={listId} ref={list} role="listbox" aria-label="Results" className="palette-list">
          {items.flatMap((item, index) => [
            ...(item.group !== items[index - 1]?.group
              ? [
                  <li key={`group-${item.group}`} role="presentation" className="palette-group">
                    {item.group}
                  </li>,
                ]
              : []),
            <li
              key={item.id}
              id={optionId(index)}
              role="option"
              aria-selected={index === active}
              className="palette-option"
              onMouseMove={() => setActive(index)}
            >
              {item.href ? (
                <RouterLink to={item.href} tabIndex={-1} onClick={() => setOpen(false)}>
                  <span className="palette-title">{item.title}</span>
                  {item.context && <span className="palette-context">{item.context}</span>}
                </RouterLink>
              ) : (
                <button type="button" tabIndex={-1} onClick={() => choose(index)}>
                  <span className="palette-title">{item.title}</span>
                </button>
              )}
            </li>,
          ])}
        </ul>
        {!items.length && <p className="palette-empty">No matches for “{query.trim()}”</p>}
        <span className="sr-only" role="status">
          {items.length} results
        </span>
        <footer className="palette-footer" aria-hidden="true">
          <span>
            <kbd>↑</kbd>
            <kbd>↓</kbd> move
          </span>
          <span>
            <kbd>↵</kbd> open
          </span>
          <span>
            <kbd>esc</kbd> close
          </span>
        </footer>
      </CommandDialog>
    </>
  )
}
