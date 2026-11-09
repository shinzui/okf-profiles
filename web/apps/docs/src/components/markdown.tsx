import { headingAnchors } from "@okf-profiles-web/corpus/headings"
import { publishedLink } from "@okf-profiles-web/corpus/links"
import ReactMarkdown from "react-markdown"
import remarkGfm from "remark-gfm"
import type { Document } from "@okf-profiles-web/corpus/types"
import { CodeBlock } from "./code-block"
export function Markdown({ document }: { document: Document }) {
  return (
    <ReactMarkdown
      remarkPlugins={[remarkGfm]}
      rehypePlugins={[headingAnchors]}
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
