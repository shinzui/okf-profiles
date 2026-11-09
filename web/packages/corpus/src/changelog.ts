import remarkGfm from "remark-gfm"
import remarkParse from "remark-parse"
import { unified } from "unified"
import { headingsFromTree, headingText, type TextNode } from "./headings"
import { releaseHeading } from "./reference-layout"
import type { ChangeBlock, ProfileRelease, Release } from "./types"

export const CHANGELOG_PATH = "CHANGELOG.md"
const NOT_A_CHANGE = "Not included"

type Positioned = TextNode & {
  position?: { start: { offset?: number }; end: { offset?: number } }
}

function plainSummary(markdown: string) {
  return markdown
    .replace(/\*\*/g, "")
    .replace(/\[([^\]]+)\]\([^)]*\)/g, "$1")
    .replace(/\s+/g, " ")
    .trim()
}

/** Reads the curated changelog into releases of independently attributable blocks. */
export function parseChangelog(body: string): Release[] {
  const tree = unified().use(remarkParse).use(remarkGfm).parse(body) as Positioned
  const headings = headingsFromTree(tree)
  const source = (node: Positioned) =>
    body.slice(node.position!.start.offset!, node.position!.end.offset!)
  const releases: Release[] = []
  let section: string | null = null
  let headingIndex = -1
  for (const node of (tree.children ?? []) as Positioned[]) {
    if (node.type === "heading") {
      headingIndex++
      if (node.depth === 2) {
        const release = releaseHeading(headingText(node))
        if (release)
          releases.push({
            ...release,
            anchor: headings[headingIndex]!.id,
            summary: "",
            blocks: [],
          })
        section = null
      } else if (node.depth === 3) section = headingText(node)
      continue
    }
    const release = releases.at(-1)
    if (!release || node.type === "definition") continue
    const parts = node.type === "list" ? ((node.children ?? []) as Positioned[]) : [node]
    release.blocks.push(...parts.map((part) => ({ section, markdown: source(part) })))
    if (!section && !release.summary && node.type === "paragraph")
      release.summary = plainSummary(source(node))
  }
  return releases
}

const names = (block: ChangeBlock, exportPath: string) =>
  block.section !== NOT_A_CHANGE && block.markdown.includes(`\`${exportPath}\``)

/** Selects only entries that name this exact profile export. */
export function releasesForExport(releases: Release[], exportPath: string): ProfileRelease[] {
  return releases.flatMap(({ version, date, anchor, blocks }) => {
    const entries = blocks.filter((block) => names(block, exportPath))
    return entries.length ? [{ version, date, anchor, entries }] : []
  })
}
