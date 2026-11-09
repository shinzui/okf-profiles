import { codeToTokens, isSupportedLanguage } from "@pierre/highlights"
import pierreDark from "@pierre/highlights/themes/pierre-dark"
import pierreLight from "@pierre/highlights/themes/pierre-light"
import { isValidElement, useMemo, useState, type CSSProperties, type ReactNode } from "react"
function style(value: string): CSSProperties {
  return Object.fromEntries(
    value
      .split(";")
      .filter(Boolean)
      .map((p) => {
        const i = p.indexOf(":")
        return [p.slice(0, i).trim(), p.slice(i + 1).trim()]
      }),
  )
}
export function CodeBlock({ children }: { children?: ReactNode }) {
  const child = isValidElement<{ children?: ReactNode; className?: string }>(children)
    ? children.props
    : undefined
  const source = String(child?.children ?? children ?? "")
  const label = /language-([^\s]+)/.exec(child?.className ?? "")?.[1] ?? "plain"
  const aliases: Record<string, string> = {
    sh: "shellscript",
    bash: "shellscript",
    zsh: "shellscript",
  }
  const candidate = aliases[label] ?? label
  const lang = isSupportedLanguage(candidate) ? candidate : "plain"
  const result = useMemo(
    () =>
      codeToTokens(source, {
        lang,
        themes: { light: pierreLight, dark: pierreDark },
        defaultColor: false,
      }),
    [source, lang],
  )
  const [status, setStatus] = useState("Copy")
  return (
    <section className="code-block" aria-label={`${label} example`}>
      <header>
        <span>{label}</span>
        <button
          type="button"
          onClick={() => {
            void navigator.clipboard.writeText(source).then(
              () => setStatus("Copied"),
              () => setStatus("Copy failed"),
            )
          }}
        >
          {status}
        </button>
      </header>
      <pre tabIndex={0} className="syntax" style={style(result.rootStyle ?? "")}>
        <code>
          {result.tokens.map((line, i) => (
            <span key={i}>
              {line.map((token) => (
                <span key={token.offset} style={token.htmlStyle as CSSProperties}>
                  {token.content}
                </span>
              ))}
              {i < result.tokens.length - 1 ? "\n" : ""}
            </span>
          ))}
        </code>
      </pre>
    </section>
  )
}
