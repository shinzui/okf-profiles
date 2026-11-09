import { Fragment } from "react"
/** Renders a catalog description's backticked identifiers without a Markdown pipeline. */
export function Inline({ text }: { text: string }) {
  return text
    .replace(/\*\*/g, "")
    .split("`")
    .map((part, index) =>
      index % 2 ? <code key={index}>{part}</code> : <Fragment key={index}>{part}</Fragment>,
    )
}
