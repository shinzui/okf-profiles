import { mkdir, copyFile, readFile, writeFile } from "node:fs/promises"
import path from "node:path"
import { createHash } from "node:crypto"
import { approvedFile, loadCorpus, parseConfig } from "../packages/corpus/src/index"
const root = path.resolve(process.env.DOCS_CONTENT_ROOT ?? "..")
const configPath = process.env.DOCS_CONTENT_CONFIG ?? "publication.json"
const corpus = await loadCorpus(root, configPath)
if (process.argv[2] === "snapshot") {
  const out = path.resolve(process.argv[3] ?? "docs-content")
  if (
    out === root ||
    (out.startsWith(root + path.sep) &&
      corpus.documents.some((d) => d.path.startsWith(path.relative(root, out) + "/")))
  )
    throw new Error("Snapshot output overlaps publication inputs")
  const config = parseConfig(
    JSON.parse(await readFile(await approvedFile(root, configPath), "utf8")),
  )
  // Refuse an existing output, which could retain files removed from selection.
  await mkdir(out)
  const files = []
  for (const relative of [...config.documents, ...config.assets].sort()) {
    const file = await approvedFile(root, relative)
    await mkdir(path.dirname(path.join(out, relative)), { recursive: true })
    await copyFile(file, path.join(out, relative))
    files.push({
      path: relative,
      sha256: createHash("sha256")
        .update(await readFile(file))
        .digest("hex"),
    })
  }
  await mkdir(out, { recursive: true })
  await writeFile(path.join(out, "content.config.json"), JSON.stringify(config, null, 2) + "\n")
  await writeFile(
    path.join(out, "content-inventory.json"),
    JSON.stringify(
      {
        schemaVersion: 1,
        commit: process.env.DOCS_COMMIT ?? corpus.commit,
        date: process.env.DOCS_COMMIT_DATE ?? corpus.date,
        files,
      },
      null,
      2,
    ) + "\n",
  )
}
console.log(`Validated ${corpus.documents.length} documents and ${corpus.assets.length} assets`)
