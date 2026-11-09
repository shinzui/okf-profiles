import { unified } from "unified"
import remarkParse from "remark-parse"
import remarkGfm from "remark-gfm"
import { headingsFromTree } from "./headings"
import { docHref } from "./links"
export { resolveLink } from "./links"
import { readFile, realpath, stat } from "node:fs/promises"
import path from "node:path"
import matter from "gray-matter"
import type { Bundle, ContentConfig, Corpus, Document } from "./types"

export function relativePath(value: unknown): string {
  if (
    typeof value !== "string" ||
    !value ||
    value.includes("\\") ||
    value.includes("\0") ||
    path.posix.isAbsolute(value) ||
    value.split("/").some((p) => !p || p === "." || p === "..") ||
    /^[a-z]+:/i.test(value)
  )
    throw new Error(`Invalid publication path: ${String(value)}`)
  return value
}
export async function approvedFile(root: string, relative: string): Promise<string> {
  relativePath(relative)
  const base = await realpath(root)
  const file = await realpath(path.join(base, relative))
  if (!file.startsWith(base + path.sep) || !(await stat(file)).isFile())
    throw new Error(`Publication escapes root or is not a file: ${relative}`)
  return file
}
function projectUri(value: unknown): string | null {
  if (value === null || value === undefined) return null
  if (typeof value !== "string" || !/^mori:\/\/[^/\s]+\/[^/\s]+$/.test(value))
    throw new Error("projectUri must be a canonical Mori project URI")
  return value
}
export function parseConfig(input: unknown): ContentConfig {
  if (!input || typeof input !== "object") throw new Error("Content config must be an object")
  const v = input as Record<string, unknown>
  if (
    v.schemaVersion !== 1 ||
    !Array.isArray(v.documents) ||
    !Array.isArray(v.bundles) ||
    !Array.isArray(v.assets)
  )
    throw new Error("Expected content config schemaVersion 1 with documents, bundles, assets")
  const documents = v.documents.map(relativePath),
    assets = v.assets.map(relativePath)
  if (new Set([...documents, ...assets]).size !== documents.length + assets.length)
    throw new Error("Duplicate publication paths")
  if (documents.some((p) => !/\.md$/i.test(p)))
    throw new Error("Documents must be Markdown .md files")
  const bundles: Bundle[] = v.bundles.map((b: unknown) => {
    if (!b || typeof b !== "object") throw new Error("Invalid bundle")
    const r = b as Record<string, unknown>
    if (typeof r.name !== "string" || !/^[a-z][a-z0-9-]*$/.test(r.name))
      throw new Error("Invalid bundle name")
    return {
      name: r.name,
      directory: relativePath(r.directory),
      projectUri: projectUri(r.projectUri),
      ...(typeof r.export === "string" ? { export: r.export } : {}),
    }
  })
  if (new Set(bundles.map((b) => b.name)).size !== bundles.length)
    throw new Error("Duplicate bundle name")
  return { schemaVersion: 1, projectUri: projectUri(v.projectUri), documents, assets, bundles }
}
export async function loadCorpus(
  root: string,
  configPath = "content.config.json",
): Promise<Corpus> {
  const config = parseConfig(
    JSON.parse(await readFile(await approvedFile(root, configPath), "utf8")),
  )
  const documents: Document[] = []
  const identities = new Set<string>()
  for (const source of config.documents) {
    const raw = await readFile(await approvedFile(root, source), "utf8")
    const normalized = raw.replace(/^\uFEFF/, "")
    const delimiter = normalized.split(/\r?\n/, 1)[0]!
    if (delimiter.startsWith("---") && delimiter.trim() !== "---")
      throw new Error(`Only YAML frontmatter is supported: ${source}`)
    const parsed = matter(normalized)
    const bundles = config.bundles.filter((b) => source.startsWith(b.directory + "/"))
    if (bundles.length > 1) throw new Error(`Ambiguous bundle for ${source}`)
    const bundle = bundles[0]
    const project = bundle?.projectUri ?? config.projectUri
    const handle = typeof parsed.data.docId === "string" ? parsed.data.docId : null
    if (handle && !/^[A-Za-z]+-[1-9][0-9]*$/.test(handle))
      throw new Error(`Invalid docId in ${source}`)
    const identity =
      bundle && project && handle ? `${project}/okf/${bundle.name}/concepts/${handle}` : source
    if (identities.has(identity)) throw new Error(`Duplicate identity: ${identity}`)
    identities.add(identity)
    const metadata = Object.fromEntries(
      Object.entries(parsed.data)
        .filter(([, v]) => ["string", "number", "boolean"].includes(typeof v))
        .map(([k, v]) => [k, String(v)]),
    )
    const links: Record<string, string> = Object.fromEntries([
      ...config.documents.map((p) => [p, docHref(p)]),
      ...config.assets.map((p) => [
        p,
        "/published/" + p.split("/").map(encodeURIComponent).join("/"),
      ]),
    ])
    documents.push({
      path: source,
      href: docHref(source),
      identity,
      bundle: bundle?.name ?? null,
      bundleDirectory: bundle?.directory ?? null,
      title:
        metadata.title ?? /^#\s+(.+)$/m.exec(parsed.content)?.[1] ?? path.posix.basename(source),
      description: metadata.description ?? "",
      exportPath: bundle?.export ?? null,
      headings: headingsFromTree(unified().use(remarkParse).use(remarkGfm).parse(parsed.content)),
      metadata,
      body: parsed.content,
      links,
    })
  }
  for (const asset of config.assets) await approvedFile(root, asset)
  let release = { commit: process.env.DOCS_COMMIT ?? "unknown", date: "unknown" }
  try {
    release = JSON.parse(await readFile(path.join(root, "content-inventory.json"), "utf8"))
  } catch {
    /* Local content. */
  }
  return { documents, assets: config.assets, commit: release.commit, date: release.date }
}
