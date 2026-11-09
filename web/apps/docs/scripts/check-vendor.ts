import { createHash } from "node:crypto"
import { readFile, readdir } from "node:fs/promises"
const root = new URL("../src/vendor/kansoku-js/", import.meta.url)
const snapshot = JSON.parse(await readFile(new URL("snapshot.json", root), "utf8"))
for (const [file, expected] of Object.entries(snapshot.files)) {
  const data = await readFile(new URL(file, root))
  if (createHash("sha256").update(data).digest("hex") !== expected)
    throw new Error(
      `Kansoku SDK snapshot changed: ${file}; regenerate with bun apps/docs/scripts/vendor-kansoku.ts`,
    )
}
async function verifyFiles(relative = "") {
  for (const entry of await readdir(new URL(relative, root), { withFileTypes: true })) {
    const file = relative + entry.name
    if (entry.isDirectory()) await verifyFiles(file + "/")
    else if (!Object.hasOwn(snapshot.files, file) && !["README.md", "snapshot.json"].includes(file))
      throw new Error(`Unrecorded SDK snapshot file: ${file}`)
  }
}
await verifyFiles()
console.log(`Verified kansoku-js ${snapshot.version}: ${Object.keys(snapshot.files).length} files`)
