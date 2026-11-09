import { catalog, searchDocuments } from "../src/catalog"
import { unified } from "unified"
import remarkParse from "remark-parse"
import { headingsFromTree, headingAnchors, type TextNode } from "../src/headings"
import { test, expect } from "bun:test"
import { mkdtemp, mkdir, writeFile, symlink, rm, readFile } from "node:fs/promises"
import os from "node:os"
import path from "node:path"
import {
  loadCorpus,
  parseChangelog,
  parseConfig,
  releasesForExport,
  resolveLink,
  approvedFile,
} from "../src/index"
import { changelogLayout, fieldHeading, referenceLayout } from "../src/reference-layout"
const config = {
  schemaVersion: 1,
  projectUri: "mori://example/docs",
  documents: ["a/one.md", "b/one.md"],
  bundles: [
    { name: "a", directory: "a" },
    { name: "b", directory: "b" },
  ],
  assets: [],
}
test("scoped identities, ordinary Markdown and anchors", async () => {
  const root = await mkdtemp(path.join(os.tmpdir(), "corpus-"))
  try {
    for (const name of ["a", "b"]) {
      await mkdir(path.join(root, name))
      await writeFile(
        path.join(root, name, "one.md"),
        `---\ntitle: ${name}\ndocId: DOC-1\n---\n# Example\n`,
      )
    }
    await writeFile(path.join(root, "content.config.json"), JSON.stringify(config))
    const corpus = await loadCorpus(root)
    expect(corpus.documents.map((d) => d.identity)).toEqual([
      "mori://example/docs/okf/a/concepts/DOC-1",
      "mori://example/docs/okf/b/concepts/DOC-1",
    ])
    expect(resolveLink("a/one.md", "../b/one.md#details", config.documents, [])).toBe(
      "/docs/b/one#details",
    )
    expect(resolveLink("a/one.md", "../secret.md", config.documents, [])).toBeNull()
    expect(resolveLink("a/one.md", "javascript:alert(1)", config.documents, [])).toBeNull()
    await writeFile(path.join(root, "a/two.md"), "---\ndocId: DOC-1\n---\n# Duplicate")
    await writeFile(
      path.join(root, "content.config.json"),
      JSON.stringify({ ...config, documents: [...config.documents, "a/two.md"] }),
    )
    await expect(loadCorpus(root)).rejects.toThrow("Duplicate identity")
    await writeFile(
      path.join(root, "content.config.json"),
      JSON.stringify({ ...config, projectUri: null }),
    )
    expect((await loadCorpus(root)).documents[0]!.identity).toBe("a/one.md")
    await writeFile(
      path.join(root, "a/one.md"),
      "\uFEFF---javascript\n({title: 'No execution'})\n---\n# Example",
    )
    await expect(loadCorpus(root)).rejects.toThrow("Only YAML")
  } finally {
    await rm(root, { recursive: true, force: true })
  }
})
test("publication paths reject traversal, absolute paths, duplicates and escaping symlinks", async () => {
  for (const value of [
    "/etc/passwd",
    "../secret",
    "a/../secret",
    "a\\secret",
    "a//b",
    "https://example.com/x",
  ])
    expect(() => parseConfig({ ...config, documents: [value] })).toThrow()
  expect(() => parseConfig({ ...config, documents: ["a.md", "a.md"] })).toThrow("Duplicate")
  const root = await mkdtemp(path.join(os.tmpdir(), "boundary-"))
  const outside = await mkdtemp(path.join(os.tmpdir(), "outside-"))
  try {
    await writeFile(path.join(outside, "secret.md"), "secret")
    await symlink(path.join(outside, "secret.md"), path.join(root, "escape.md"))
    await expect(approvedFile(root, "escape.md")).rejects.toThrow("escapes")
  } finally {
    await rm(root, { recursive: true, force: true })
    await rm(outside, { recursive: true, force: true })
  }
})
test("generated bundle-root links stay inside their declared bundle", () => {
  const docs = [
    "a/profile.md",
    "b/profile.md",
    "a/types/feature.md",
    "b/types/feature.md",
    "a/index.md",
  ]
  const link = (source: string, href: string, bundle: string | null = "a") =>
    resolveLink(source, href, docs, [], bundle)
  expect(link("a/types/feature.md", "/profile.md#settings")).toBe("/docs/a/profile#settings")
  expect(link("b/types/feature.md", "/profile.md", "b")).toBe("/docs/b/profile")
  expect(link("a/profile.md", "/types/feature.md")).toBe("/docs/a/types/feature")
  expect(link("a/index.md", "profile.md")).toBe("/docs/a/profile")
  expect(link("a/types/feature.md", "../index.md#files")).toBe("/docs/a/index#files")
  expect(link("a/profile.md", "#settings")).toBe("#settings")
  for (const href of [
    "//evil.test/profile.md",
    "/../b/profile.md",
    "/%2e%2e/b/profile.md",
    "/%2fetc/passwd",
    "/types/missing.md",
    "javascript:alert(1)",
    "file:/profile.md",
    "/types\\feature.md",
    "/types%5cfeature.md",
  ])
    expect(link("a/profile.md", href)).toBeNull()
  expect(link("a/types/feature.md", "/profile.md", null)).toBeNull()
})
test("real publication includes all profiles and section search excludes bodies", async () => {
  const root = path.resolve(import.meta.dir, "../../../..")
  const corpus = await loadCorpus(root, "publication.json")
  const profiles = catalog(corpus.documents)
  const inventory = JSON.parse(
    await readFile(path.join(root, "scripts/profile-docs-catalog.json"), "utf8"),
  )
  expect(profiles.map((entry) => entry.profile.exportPath).sort()).toEqual(
    inventory.map((entry: { export: string }) => entry.export).sort(),
  )
  expect(profiles.flatMap((entry) => entry.types)).toHaveLength(
    corpus.documents.filter(
      (doc) => doc.path.includes("/types/") && !doc.path.endsWith("/index.md"),
    ).length,
  )
  expect(profiles.find((entry) => entry.profile.bundle === "okf-v0-2")?.types).toHaveLength(0)
  const results = searchDocuments(corpus.documents, "Feature acceptanceCriteria")
  expect(
    results.some((result) =>
      result.href.startsWith("/docs/docs/profiles/features/types/feature#acceptancecriteria"),
    ),
  ).toBe(true)
  expect(
    new Set(searchDocuments(corpus.documents, "generated").map((result) => result.profile)).size,
  ).toBeGreaterThan(1)
  expect(searchDocuments(corpus.documents, "no-such-field-xyz")).toHaveLength(0)
})
test("heading IDs use inline text at all depths and disambiguate collisions", () => {
  const tree = unified()
    .use(remarkParse)
    .parse("# A\n## A\n### `Code` and **bold**\n#### A\n##### A-1\n###### A\n")
  const headings = headingsFromTree(tree)
  expect(headings.map((h) => h.id)).toEqual(["a", "a-1", "code-and-bold", "a-2", "a-1-1", "a-3"])
  const hast: TextNode = {
    children: headings.map((h) => ({
      tagName: `h${h.depth}`,
      children: [{ type: "text", value: h.text }],
    })),
  }
  headingAnchors()(hast)
  expect(hast.children!.map((node) => node.properties!.id)).toEqual(headings.map((h) => h.id))
})

const element = (tagName: string, children: TextNode[], properties = {}): TextNode => ({
  type: "element",
  tagName,
  children,
  properties,
})
const text = (value: string): TextNode => ({ type: "text", value })
const code = (value: string) => element("code", [text(value)])
const item = (...children: TextNode[]) => element("li", children)
const fieldRules = (extra: TextNode[] = []) =>
  element("ul", [
    item(text("Allowed values: any")),
    item(text("Cardinality: list")),
    item(text("Format: none")),
    item(text("Unique by: "), code("id")),
    item(text("Condition: applies only when "), code("status"), text(" is "), code("live")),
    item(text("Object fields: none")),
    ...extra,
  ])
function find(node: TextNode, className: string): TextNode[] {
  const own = (node.properties?.className as string[] | undefined)?.includes(className)
  return [...(own ? [node] : []), ...(node.children ?? []).flatMap((c) => find(c, className))]
}
const render = (node: TextNode): string => node.value ?? node.children?.map(render).join("") ?? ""

test("field rules become cards that keep stated constraints and drop unset ones", () => {
  const tree = element("root", [
    element(
      "h4",
      [code("items"), text(" — required when "), code("status"), text(" is "), code("live")],
      { id: "items" },
    ),
    element("p", [text("What it holds.")]),
    fieldRules([
      item(
        text("Element fields:"),
        element("ul", [
          item(
            code("id"),
            text(" — required; allowed values: any; cardinality: scalar; format: "),
            code("uri"),
            text(" — The handle — stable."),
          ),
          item(text("Presence constraints: none")),
        ]),
      ),
      item(text("Element field names: open")),
    ]),
  ])
  referenceLayout()(tree)
  const [card] = find(tree, "field-card")
  expect(card!.properties!.dataPresence).toBe("required")
  expect(card!.children![0]!.properties!.id).toBe("items")
  const facts = render(find(card!, "facts")[0]!)
  expect(facts).toContain("Cardinalitylist")
  expect(facts).toContain("Unique byid")
  expect(facts).not.toContain("Allowed values")
  expect(facts).not.toContain("Format")
  // The heading already states this condition.
  expect(facts).not.toContain("Condition")
  const [nested] = find(card!, "subfields")
  expect(render(nested!)).toContain("names open")
  expect(render(find(nested!, "subfield")[0]!)).toContain("The handle — stable.")
  expect(render(find(nested!, "subfield")[0]!)).toContain("Formaturi")
  expect(render(nested!)).not.toContain("Presence constraints")
})

test("a condition the heading does not state stays visible on an optional field", () => {
  const tree = element("root", [element("h3", [code("note"), text(" — optional")]), fieldRules()])
  referenceLayout()(tree)
  expect(render(find(tree, "facts")[0]!)).toContain("Conditionapplies only when status is live")
})

test("an unlabelled rule stays on its card as a note", () => {
  const tree = element("root", [
    element("h3", [code("resource"), text(" — recommended")]),
    fieldRules([item(text("Checked only under "), code("--strict"))]),
  ])
  referenceLayout()(tree)
  expect(find(tree, "field-card").length).toBe(1)
  expect(render(find(tree, "field-note")[0]!)).toBe("Checked only under --strict")
})

test("unrecognized lists and headings pass through unchanged", () => {
  const list = element("ul", [item(text("Required")), item(text("Other: thing"))])
  const heading = element("h3", [text("Guidance")])
  const tree = element("root", [heading, list])
  referenceLayout()(tree)
  expect(tree.children).toEqual([heading, list])
})

test("constraint lists disappear only when every constraint is none", () => {
  const unset = element("root", [element("ul", [item(text("Presence constraints: none"))])])
  referenceLayout()(unset)
  expect(unset.children).toEqual([])
  const stated = element("root", [
    element("ul", [
      item(text("Presence constraints: none")),
      item(text("Timestamp order constraints: "), code("a"), text(" before "), code("b")),
    ]),
  ])
  referenceLayout()(stated)
  expect(render(stated)).toContain("a before b")
  expect(render(stated)).not.toContain("Presence")
})

test("field headings separate name, level and rule", () => {
  expect(fieldHeading("status — required when kind is model")).toEqual({
    name: "status",
    level: "required",
    rule: "required when kind is model",
  })
  expect(fieldHeading("Frontmatter rules")).toBeNull()
})

const history = `# Changelog

Intro.

## [Unreleased]

## [1.2.0] — 2026-10-23

Adds **\`a.one\`** and [more](./x.md).

### Added

- \`a.one\`: the first.
  - nested detail
- Unrelated work on \`a.oneMore\`.

### Not included

\`a.one\` migration tooling waits.

## [1.1.0] — 2026-10-01

### Changed

- Everything moved.

[1.1.0]: https://example.test/1.1.0
`

test("changelog entries attach to a profile only by its exact export", () => {
  const releases = parseChangelog(history)
  expect(releases.map((release) => release.version)).toEqual(["Unreleased", "1.2.0", "1.1.0"])
  expect(releases[0]!.blocks).toEqual([])
  expect(releases[1]!.summary).toBe("Adds `a.one` and more.")
  const [release, ...others] = releasesForExport(releases, "a.one")
  expect(others).toEqual([])
  expect(release!.anchor).toBe("120-2026-10-23")
  expect(release!.entries.map((entry) => entry.section)).toEqual([null, "Added"])
  expect(release!.entries[1]!.markdown).toContain("nested detail")
  expect(release!.entries.join("")).not.toContain("a.oneMore")
  expect(releasesForExport(releases, "a.missing")).toEqual([])
})

test("changelog releases wrap their entries and keep heading anchors", () => {
  const tree = element("root", [
    element("h1", [text("Changelog")]),
    element("h2", [text("[1.2.0] — 2026-10-23")], { id: "120-2026-10-23" }),
    element("h3", [text("Added")], { id: "added" }),
    element("h2", [text("[Unreleased]")], { id: "unreleased" }),
  ])
  changelogLayout()(tree)
  const releases = find(tree, "release")
  expect(releases.length).toBe(2)
  expect(releases[0]!.children![0]!.properties!.id).toBe("120-2026-10-23")
  expect(render(find(releases[0]!, "release-version")[0]!)).toBe("1.2.0")
  expect(render(find(releases[1]!, "muted")[0]!)).toBe("Nothing recorded yet.")
  expect(find(releases[0]!, "release-kind")[0]!.properties!.dataKind).toBe("added")
})

test("search ranks page titles first and omits repeated changelog labels", () => {
  const summary = (path: string, title: string, bundle: string | null, depth = 2) => ({
    path,
    href: `/docs/${path}`,
    title,
    description: "",
    identity: path,
    bundle,
    exportPath: null,
    metadata: {},
    headings: [{ id: "added", text: "Added jobs", depth }],
  })
  const results = searchDocuments(
    [summary("CHANGELOG.md", "Changelog", null, 3), summary("b/jobs.md", "Jobs", "b", 2)],
    "jobs",
  )
  expect(results[0]!.href).toBe("/docs/b/jobs.md")
  expect(results.some((result) => result.profile === "Changelog")).toBe(false)
})
