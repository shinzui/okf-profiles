import { approvedFile, loadCorpus } from "@okf-profiles-web/corpus"
import { readFile, stat } from "node:fs/promises"
import path from "node:path"
const root = () => process.env.DOCS_CONTENT_ROOT ?? path.resolve("../..")
const config = () => process.env.DOCS_CONTENT_CONFIG ?? "publication.json"
let cached: { key: string; corpus: Awaited<ReturnType<typeof loadCorpus>> } | null = null
async function currentCorpus() {
  const file = await stat(path.join(root(), config()))
  const key = `${root()}:${config()}:${file.ino}:${file.mtimeMs}:${file.size}`
  if (!cached || cached.key !== key) cached = { key, corpus: await loadCorpus(root(), config()) }
  return cached.corpus
}
export async function collection() {
  const corpus = await currentCorpus()
  return {
    siteName: process.env.DOCS_SITE_NAME ?? (await readFile("site-name.txt", "utf8")).trim(),
    commit: corpus.commit,
    date: corpus.date,
    summaries: corpus.documents.map(
      ({ body: _body, links: _links, bundleDirectory: _bundleDirectory, ...summary }) => summary,
    ),
  }
}
export async function document(data: string) {
  const corpus = await currentCorpus()
  return (
    corpus.documents.find(
      (d) => d.href === "/docs/" + data.split("/").map(encodeURIComponent).join("/"),
    ) ?? null
  )
}
export async function getAsset(relative: string) {
  const corpus = await currentCorpus()
  return corpus.assets.includes(relative) ? approvedFile(root(), relative) : null
}
