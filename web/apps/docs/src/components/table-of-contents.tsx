import { useEffect, useState } from "react"
import type { Heading } from "@okf-profiles-web/corpus/headings"
import { fieldHeading } from "@okf-profiles-web/corpus/reference-layout"
export function TableOfContents({ headings }: { headings: Heading[] }) {
  const [expanded, setExpanded] = useState(false)
  useEffect(() => {
    setExpanded(window.matchMedia("(min-width: 1151px)").matches)
  }, [])
  const [copied, setCopied] = useState<string | null>(null)
  const items = headings.filter((heading) => heading.depth > 1)
  const links = (
    <ol>
      {items.map((heading) => {
        const field = fieldHeading(heading.text)
        return (
          <li key={heading.id} data-depth={heading.depth}>
            {field && <span className="toc-dot" data-presence={field.level} title={field.rule} />}
            <a href={`#${heading.id}`} className={field ? "toc-field" : undefined}>
              {field ? field.name : heading.text}
              {field && <span className="sr-only"> — {field.rule}</span>}
            </a>
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
        )
      })}
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
