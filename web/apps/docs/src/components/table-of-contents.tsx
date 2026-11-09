import { useEffect, useState } from "react"
import type { Heading } from "@okf-profiles-web/corpus/headings"
export function TableOfContents({ headings }: { headings: Heading[] }) {
  const [expanded, setExpanded] = useState(false)
  useEffect(() => {
    setExpanded(window.matchMedia("(min-width: 1151px)").matches)
  }, [])
  const [copied, setCopied] = useState<string | null>(null)
  const items = headings.filter((heading) => heading.depth > 1)
  const links = (
    <ol>
      {items.map((heading) => (
        <li key={heading.id} data-depth={heading.depth}>
          <a href={`#${heading.id}`}>{heading.text}</a>
          <button
            type="button"
            className="copy-section"
            aria-label={`Copy link to ${heading.text}`}
            onClick={() => {
              const url = new URL(window.location.href)
              url.hash = heading.id
              void navigator.clipboard.writeText(url.href).then(() => setCopied(heading.id))
            }}
          >
            {copied === heading.id ? "✓" : "#"}
          </button>
        </li>
      ))}
    </ol>
  )
  return (
    <nav className="section-rail" aria-label="On this page">
      <details open={expanded} onToggle={(event) => setExpanded(event.currentTarget.open)}>
        <summary>On this page</summary>
        {links}
      </details>
      <span className="sr-only" role="status">
        {copied ? "Section link copied" : ""}
      </span>
    </nav>
  )
}
