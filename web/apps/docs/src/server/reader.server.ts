import {
  approvedFile,
  CHANGELOG_PATH,
  loadCorpus,
  releasesForExport,
} from "@okf-profiles-web/corpus"
import { readFile, stat } from "node:fs/promises"
import path from "node:path"
const root = () => process.env.DOCS_CONTENT_ROOT ?? path.resolve("../..")
const config = () => process.env.DOCS_CONTENT_CONFIG ?? "publication.json"
let cached: { key: string; corpus: Awaited<ReturnType<typeof loadCorpus>> } | null = null
async function currentCorpus() {
  const file = await stat(path.join(root(), config()))
  // The changelog is curated, so editing it does not replace the generated manifest.
  const changelog = await stat(path.join(root(), CHANGELOG_PATH)).catch(() => null)
  const key = `${root()}:${config()}:${file.ino}:${file.mtimeMs}:${file.size}:${changelog?.mtimeMs}`
  if (!cached || cached.key !== key) cached = { key, corpus: await loadCorpus(root(), config()) }
  return cached.corpus
}
export async function collection() {
  const corpus = await currentCorpus()
  const latest = corpus.changelog.find((release) => release.blocks.length)
  return {
    siteName: process.env.DOCS_SITE_NAME ?? (await readFile("site-name.txt", "utf8")).trim(),
    commit: corpus.commit,
    date: corpus.date,
    latestRelease: latest
      ? {
          version: latest.version,
          date: latest.date,
          anchor: latest.anchor,
          summary: latest.summary,
        }
      : null,
    profileReleases: Object.fromEntries(
      corpus.documents.flatMap((doc) => {
        if (!doc.exportPath || !doc.path.endsWith("/profile.md")) return []
        const release = releasesForExport(corpus.changelog, doc.exportPath)[0]
        return release ? [[doc.bundle!, release.version]] : []
      }),
    ),
    summaries: corpus.documents.map(
      ({ body: _body, links: _links, bundleDirectory: _bundleDirectory, ...summary }) => summary,
    ),
  }
}
export async function document(data: string) {
  const corpus = await currentCorpus()
  const found = corpus.documents.find(
    (d) => d.href === "/docs/" + data.split("/").map(encodeURIComponent).join("/"),
  )
  if (!found) return null
  return {
    ...found,
    changes:
      found.exportPath && found.path.endsWith("/profile.md")
        ? releasesForExport(corpus.changelog, found.exportPath)
        : [],
  }
}
export async function getAsset(relative: string) {
  const corpus = await currentCorpus()
  return corpus.assets.includes(relative) ? approvedFile(root(), relative) : null
}
