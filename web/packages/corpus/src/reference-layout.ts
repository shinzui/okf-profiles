// Presentation-only HAST transforms, safe in server and browser bundles. The generated
// Markdown is never rewritten: unrecognized shapes pass through as ordinary Markdown.
import { headingText, type TextNode as Node } from "./headings"

const LEVELS = ["required", "recommended", "optional"] as const
export type PresenceLevel = (typeof LEVELS)[number]

const SETTINGS = new Set([
  "OKF version",
  "Required bundle version",
  "Unknown concept types",
  "Unknown frontmatter keys",
  "Document ID field",
  "Path pattern",
  "Resource URI scheme",
  "Requires a `# Schema` section",
  "Requires a # Schema section",
  "Schema columns",
  "Document ID prefix",
])
const CONSTRAINTS = new Set([
  "Presence constraints",
  "Timestamp order constraints",
  "Membership constraints (text operands)",
  "Unique values constraints (text operands)",
])
const NESTED = new Set(["Object fields", "Element fields"])
const NAME_POLICY: Record<string, string> = {
  "Object field names": "Object fields",
  "Element field names": "Element fields",
}
const SUBFIELD_LABELS =
  /^(allowed values|cardinality|format|reference|path|unique by|object field names|element field names|condition):\s*(.*)$/s

const text = (value: string): Node => ({ type: "text", value })
function element(
  tagName: string,
  className: string | null,
  children: Node[],
  properties: Record<string, unknown> = {},
): Node {
  return {
    type: "element",
    tagName,
    properties: { ...(className ? { className: className.split(" ") } : {}), ...properties },
    children,
  }
}
const isBlank = (node: Node) => node.type === "text" && !node.value?.trim()
const content = (nodes: Node[] = []) => nodes.filter((node) => !isBlank(node))
const isHeading = (node: Node) => /^h[1-6]$/.test(node.tagName ?? "")
const inlineText = (nodes: Node[]) => nodes.map(headingText).join("").trim()
const isUnset = (nodes: Node[]) => ["none", "any"].includes(inlineText(nodes))

/** Splits inline children at a separator found in text nodes; code is never split. */
export function splitInline(children: Node[], separator: string): Node[][] {
  const parts: Node[][] = [[]]
  for (const child of children) {
    if (child.type !== "text") {
      parts.at(-1)!.push(child)
      continue
    }
    ;(child.value ?? "").split(separator).forEach((piece, index) => {
      if (index) parts.push([])
      if (piece) parts.at(-1)!.push(text(piece))
    })
  }
  return parts
}

/** Separates a rendered field heading such as "status — required when kind is model". */
export function fieldHeading(value: string) {
  const match = /^(\S+) — (required|recommended|optional)\b(.*)$/s.exec(value)
  if (!match) return null
  return { name: match[1]!, level: match[2] as PresenceLevel, rule: match[2]! + match[3]! }
}

/** Reads a Keep a Changelog heading such as "[0.25.0] — 2026-10-23". */
export function releaseHeading(value: string) {
  const match = /^\[?([^\]\s]+)\]?(?:\s+—\s+(\d{4}-\d{2}-\d{2}))?$/.exec(value.trim())
  return match ? { version: match[1]!, date: match[2] ?? null } : null
}

function parsePresence(rest: Node[]) {
  const [first, ...tail] = rest
  const match =
    first?.type === "text"
      ? /^\s*(required|recommended|optional)\b\s*(.*)$/s.exec(first.value!)
      : null
  if (!match) return null
  return {
    level: match[1] as PresenceLevel,
    condition: match[2] ? [text(match[2]), ...tail] : tail,
  }
}

function presenceTag(level: PresenceLevel, condition: Node[]) {
  return [
    element("span", "presence", [text(level)], { dataPresence: level }),
    ...(condition.length ? [element("span", "field-when", [text(" "), ...condition])] : []),
  ]
}

function labelled(item: Node) {
  const children = content(item.children)
  const nested = children.find((child) => child.tagName === "ul")
  const inline = children.filter((child) => child.tagName !== "ul")
  const first = inline[0]
  const match = first?.type === "text" ? /^([A-Z][^:]*):\s*(.*)$/s.exec(first.value!) : null
  if (!match) return null
  return {
    label: match[1]!,
    // Trailing space is significant when inline code follows the label's text.
    value: [
      ...(match[2] ? [text(inline.length > 1 ? match[2] : match[2].trimEnd())] : []),
      ...inline.slice(1),
    ],
    nested,
  }
}

function fact(label: string, value: Node[]) {
  const clauses = splitInline(value, "; ").filter((clause) => clause.length)
  return element("div", "fact", [
    element("dt", null, [text(label)]),
    element(
      "dd",
      null,
      clauses.length > 1 ? clauses.map((clause) => element("span", "fact-clause", clause)) : value,
    ),
  ])
}

function subfield(item: Node): Node {
  const nested = content(item.children).filter((child) => child.tagName === "ul")
  const inline = content(item.children).filter((child) => child.tagName !== "ul")
  const [nameParts, ruleParts, ...descriptionParts] = splitInline(inline, " — ")
  const name = nameParts?.length === 1 && nameParts[0]!.tagName === "code" ? nameParts[0]! : null
  const rules = ruleParts ? splitInline(ruleParts, "; ") : []
  const presence = rules[0] ? parsePresence(rules[0]) : null
  if (!name || !presence) return item
  const facts: { label: string; value: Node[] }[] = []
  for (const part of rules.slice(1)) {
    const first = part[0]
    const match = first?.type === "text" ? SUBFIELD_LABELS.exec(first.value!) : null
    if (match) {
      facts.push({
        label: match[1]![0]!.toUpperCase() + match[1]!.slice(1),
        value: [...(match[2] ? [text(match[2])] : []), ...part.slice(1)],
      })
    } else if (facts.length) {
      facts.at(-1)!.value.push(text("; "), ...part)
    }
  }
  const visible = facts.filter((entry) => !isUnset(entry.value))
  const description = descriptionParts.flatMap((part, index) =>
    index ? [text(" — "), ...part] : part,
  )
  return element(
    "li",
    "subfield",
    [
      element("div", "field-head", [name, ...presenceTag(presence.level, presence.condition)]),
      ...(description.length ? [element("p", "subfield-text", description)] : []),
      ...(visible.length
        ? [
            element(
              "dl",
              "facts",
              visible.map((entry) => fact(entry.label, entry.value)),
            ),
          ]
        : []),
      ...nested,
    ],
    { dataPresence: presence.level },
  )
}

function nestedFields(label: string, list: Node, namePolicy: string | undefined) {
  const items: Node[] = []
  const notes: Node[] = []
  for (const item of content(list.children)) {
    const entry = labelled(item)
    if (entry && CONSTRAINTS.has(entry.label)) {
      if (!isUnset(entry.value)) notes.push(fact(entry.label, entry.value))
      continue
    }
    items.push(subfield(item))
  }
  return element(
    "details",
    "subfields",
    [
      element("summary", null, [
        text(label),
        element("span", "subfield-count", [
          text(`${items.length}${namePolicy ? ` · names ${namePolicy}` : ""}`),
        ]),
      ]),
      element("ul", null, items),
      ...(notes.length ? [element("dl", "facts", notes)] : []),
    ],
    items.length <= 4 ? { open: true } : {},
  )
}

function fieldCard(heading: Node, block: Node[]): Node | null {
  const [name, separator, ...tail] = heading.children ?? []
  if (name?.tagName !== "code" || separator?.type !== "text") return null
  if (!separator.value?.startsWith(" — ")) return null
  const presence = parsePresence([text(separator.value.slice(3)), ...tail])
  if (!presence) return null
  const lists = block.filter((node) => node.tagName === "ul")
  const list = lists.at(-1)
  const items = list ? content(list.children) : []
  const parsed = items.map(labelled)
  const entries = parsed.filter((entry) => entry !== null)
  if (!list || !entries.some((entry) => entry.label === "Cardinality")) return null
  // A rule without a label, such as "Checked only under --strict", is stated as a note.
  const notes = items
    .filter((_, index) => !parsed[index])
    .map((item) => element("p", "field-note", content(item.children)))
  const rows: Node[] = []
  const nests: Node[] = []
  const nameEntries = entries.filter((entry) => entry.label in NAME_POLICY)
  const nestedSections = new Set(entries.filter((e) => e.nested).map((e) => e.label))
  for (const entry of entries) {
    const { label, value, nested } = entry
    if (NESTED.has(label)) {
      if (nested) {
        const policy = nameEntries.find((candidate) => NAME_POLICY[candidate.label] === label)
        nests.push(
          nestedFields(
            label,
            nested,
            policy && !isUnset(policy.value) ? inlineText(policy.value) : undefined,
          ),
        )
      }
      continue
    }
    if (isUnset(value)) continue
    if (label in NAME_POLICY && nestedSections.has(NAME_POLICY[label]!)) continue
    if (
      label === "Condition" &&
      inlineText(value) === `applies only ${inlineText(presence.condition)}`
    )
      continue
    rows.push(fact(label, value))
  }
  return element(
    "section",
    "field-card",
    [
      {
        ...heading,
        children: [
          name,
          element("span", "sr-only", [text(" — ")]),
          ...presenceTag(presence.level, presence.condition),
        ],
      },
      ...block.filter((node) => node !== list),
      ...notes,
      ...(rows.length ? [element("dl", "facts", rows)] : []),
      ...nests,
    ],
    { dataPresence: presence.level },
  )
}

function linkList(list: Node): Node {
  return {
    ...list,
    properties: { ...list.properties, className: ["link-list"] },
    children: content(list.children).map((item) => {
      const [link, first, ...rest] = content(item.children)
      if (!first || first.type !== "text") return item
      const description = [text(first.value!.replace(/^\s*[—-]\s*/, "")), ...rest]
      return { ...item, children: [link!, element("span", "link-text", description)] }
    }),
  }
}

function listLayout(list: Node): Node[] {
  const items = content(list.children)
  if (items.length && items.every((item) => content(item.children)[0]?.tagName === "a"))
    return [linkList(list)]
  const entries = items.map(labelled)
  if (!entries.length || entries.some((entry) => !entry)) return [list]
  if (entries.every((entry) => SETTINGS.has(entry!.label)))
    return [
      element(
        "dl",
        "settings",
        entries.map((entry) => fact(entry!.label, entry!.value)),
      ),
    ]
  if (entries.every((entry) => CONSTRAINTS.has(entry!.label))) {
    const stated = entries.filter((entry) => !isUnset(entry!.value))
    return stated.length
      ? [
          element(
            "dl",
            "facts",
            stated.map((entry) => fact(entry!.label, entry!.value)),
          ),
        ]
      : []
  }
  return [list]
}

/** Turns generated field rules into scannable cards without losing a stated constraint. */
export function referenceLayout() {
  return (tree: Node) => {
    const nodes = content(tree.children)
    const output: Node[] = []
    for (let index = 0; index < nodes.length; index++) {
      const node = nodes[index]!
      if (/^h[3-6]$/.test(node.tagName ?? "")) {
        let end = index + 1
        while (end < nodes.length && !isHeading(nodes[end]!) && nodes[end]!.tagName !== "hr") end++
        const card = fieldCard(node, nodes.slice(index + 1, end))
        if (card) {
          output.push(card)
          index = end - 1
          continue
        }
      }
      if (node.tagName === "ul") output.push(...listLayout(node))
      else output.push(node)
    }
    output.forEach((node, index) => {
      const level = headingText(node).toLowerCase()
      if (node.tagName !== "h3" || !(LEVELS as readonly string[]).includes(level)) return
      let count = 0
      for (let next = index + 1; output[next]?.tagName === "section"; next++) count++
      node.properties = {
        ...node.properties,
        className: ["field-group"],
        dataPresence: level,
        dataCount: String(count),
      }
    })
    tree.children = output
  }
}

function releaseCard(heading: Node, body: Node[]): Node {
  const release = releaseHeading(headingText(heading))
  const link = heading.children?.find((child) => child.tagName === "a")
  const title = release
    ? [
        element("span", "release-version", [link ?? text(release.version)]),
        ...(release.date
          ? [element("time", "release-date", [text(release.date)], { dateTime: release.date })]
          : []),
      ]
    : (heading.children ?? [])
  return element(
    "section",
    "release",
    [
      { ...heading, children: title },
      element(
        "div",
        "release-body",
        body.length
          ? body.map((node) =>
              node.tagName === "h3"
                ? {
                    ...node,
                    properties: {
                      ...node.properties,
                      className: ["release-kind"],
                      dataKind: headingText(node).split(" ")[0]!.toLowerCase(),
                    },
                  }
                : node,
            )
          : [element("p", "muted", [text("Nothing recorded yet.")])],
      ),
    ],
    {},
  )
}

/** Wraps each changelog release so the page reads as a timeline. */
export function changelogLayout() {
  return (tree: Node) => {
    const output: Node[] = []
    let current: { heading: Node; body: Node[] } | null = null
    const flush = () => {
      if (current) output.push(releaseCard(current.heading, current.body))
      current = null
    }
    for (const node of content(tree.children)) {
      if (node.tagName === "h2") {
        flush()
        current = { heading: node, body: [] }
      } else if (current) current.body.push(node)
      else output.push(node)
    }
    flush()
    tree.children = output
  }
}
