import { catalog, searchDocuments } from "../src/catalog"
import { unified } from "unified"
import remarkParse from "remark-parse"
import { headingsFromTree, headingAnchors, type TextNode } from "../src/headings"
import { test, expect } from "bun:test"
import { mkdtemp, mkdir, writeFile, symlink, rm, readFile } from "node:fs/promises"
import os from "node:os"
import path from "node:path"
import { loadCorpus, parseConfig, resolveLink, approvedFile } from "../src/index"
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
