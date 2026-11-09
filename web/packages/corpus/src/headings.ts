// Shared Markdown/HAST text and ID policy, safe in server and browser bundles.
export interface TextNode {
  type?: string
  value?: string
  alt?: string | null
  tagName?: string
  depth?: number
  children?: TextNode[]
  properties?: Record<string, unknown>
}
export interface Heading {
  id: string
  text: string
  depth: number
}
export function headingText(node: TextNode): string {
  if (node.type === "html") return ""
  return node.value ?? node.alt ?? node.children?.map(headingText).join("") ?? ""
}
export function headingIds() {
  const used = new Set<string>()
  return (text: string) => {
    const base =
      text
        .toLowerCase()
        .replace(/[^\p{L}\p{N}\s-]/gu, "")
        .trim()
        .replace(/\s+/g, "-") || "section"
    let id = base
    for (let suffix = 1; used.has(id); suffix++) id = `${base}-${suffix}`
    used.add(id)
    return id
  }
}
export function headingsFromTree(tree: TextNode): Heading[] {
  const id = headingIds()
  const headings: Heading[] = []
  function visit(node: TextNode) {
    if (node.type === "heading") {
      const text = headingText(node)
      headings.push({ id: id(text), text, depth: node.depth! })
    }
    node.children?.forEach(visit)
  }
  visit(tree)
  return headings
}
export function headingAnchors() {
  return (tree: TextNode) => {
    const id = headingIds()
    function visit(node: TextNode) {
      if (/^h[1-6]$/.test(node.tagName ?? ""))
        node.properties = { ...node.properties, id: id(headingText(node)) }
      node.children?.forEach(visit)
    }
    visit(tree)
  }
}
