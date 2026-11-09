import { headingAnchors } from "@okf-profiles-web/corpus/headings"
import { publishedLink } from "@okf-profiles-web/corpus/links"
import { changelogLayout, referenceLayout } from "@okf-profiles-web/corpus/reference-layout"
import ReactMarkdown from "react-markdown"
import remarkGfm from "remark-gfm"
import type { Document } from "@okf-profiles-web/corpus/types"
import { CodeBlock } from "./code-block"
type Layout = "changelog" | "reference" | "plain"
const layouts = {
  changelog: [headingAnchors, changelogLayout],
  reference: [headingAnchors, referenceLayout],
  plain: [headingAnchors],
}
export function Markdown({ document, layout = "plain" }: { document: Document; layout?: Layout }) {
  return (
    <ReactMarkdown
      remarkPlugins={[remarkGfm]}
      rehypePlugins={layouts[layout]}
      skipHtml
      components={{
        pre: CodeBlock,
        a: ({ href, children }) => {
          const target = href
            ? publishedLink(document.path, href, document.links, document.bundleDirectory)
            : null
          return target ? <a href={target}>{children}</a> : <span>{children}</span>
        },
        img: ({ src, alt }) => {
          const target =
            typeof src === "string"
              ? publishedLink(document.path, src, document.links, document.bundleDirectory)
              : null
          return target?.startsWith("/published/") ? (
            <img src={target} alt={alt ?? ""} />
          ) : (
            <span>{alt}</span>
          )
        },
        table: ({ children }) => (
          <div className="table-scroll" tabIndex={0} role="region" aria-label="Reference table">
            <table>{children}</table>
          </div>
        ),
      }}
    >
      {document.body}
    </ReactMarkdown>
  )
}
