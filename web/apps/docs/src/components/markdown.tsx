import { publishedLink } from "@okf-profiles-web/corpus/links"
import ReactMarkdown from "react-markdown"
import remarkGfm from "remark-gfm"
import type { Document } from "@okf-profiles-web/corpus/types"
import { CodeBlock } from "./code-block"
const headingId = (value: unknown) =>
  String(value)
    .toLowerCase()
    .replace(/[^\p{L}\p{N}\s-]/gu, "")
    .trim()
    .replace(/\s+/g, "-")
export function Markdown({ document }: { document: Document }) {
  return (
    <ReactMarkdown
      remarkPlugins={[remarkGfm]}
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
        h1: ({ children }) => <h1 id={headingId(children)}>{children}</h1>,
        h2: ({ children }) => <h2 id={headingId(children)}>{children}</h2>,
        h3: ({ children }) => <h3 id={headingId(children)}>{children}</h3>,
      }}
    >
      {document.body}
    </ReactMarkdown>
  )
}
