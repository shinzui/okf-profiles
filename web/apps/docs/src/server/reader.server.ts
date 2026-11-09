import { approvedFile, loadCorpus } from "@okf-profiles-web/corpus"
import { readFile } from "node:fs/promises"
import path from "node:path"
const root = () => process.env.DOCS_CONTENT_ROOT ?? path.resolve("../..")
const config = () => process.env.DOCS_CONTENT_CONFIG ?? "content.config.json"
export async function collection() {
  const corpus = await loadCorpus(root(), config())
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
  const corpus = await loadCorpus(root(), config())
  return (
    corpus.documents.find(
      (d) => d.href === "/docs/" + data.split("/").map(encodeURIComponent).join("/"),
    ) ?? null
  )
}
export async function getAsset(relative: string) {
  const corpus = await loadCorpus(root(), config())
  return corpus.assets.includes(relative) ? approvedFile(root(), relative) : null
}
