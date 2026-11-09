// Sort only a newly allocated entries array; support this workspace’s ES2022 target.
/* oxlint-disable unicorn/no-array-sort */
// Refresh the offline SDK from an integrity-pinned published npm artifact.
import { createHash } from "node:crypto"
import { cp, mkdir, mkdtemp, readFile, readdir, rename, rm, writeFile } from "node:fs/promises"
import { tmpdir } from "node:os"
import { join, resolve } from "node:path"

const version = "0.1.1"
const integrity =
  "sha512-DYZo1eCRkkxMCzSR880qJG03jxOhldDj49aIhcXscinFGtEaTyXi+4s1yovW+Kiu/HcoX4ZrFpBSIYV6CUv/5A=="
const gitHead = "a1ad5586f129589b916604947266656ffc63bbfa"
const destination = resolve("apps/docs/src/vendor/kansoku-js")
const temporary = await mkdtemp(join(tmpdir(), "kansoku-npm-"))
const tarball = `https://registry.npmjs.org/kansoku-js/-/kansoku-js-${version}.tgz`
try {
  const response = await fetch(tarball)
  if (!response.ok) throw new Error(`SDK download failed: ${response.status}`)
  const bytes = new Uint8Array(await response.arrayBuffer())
  if (`sha512-${createHash("sha512").update(bytes).digest("base64")}` !== integrity)
    throw new Error("SDK tarball integrity mismatch")
  await writeFile(join(temporary, "sdk.tgz"), bytes)
  const child = Bun.spawn(
    ["tar", "-xzf", join(temporary, "sdk.tgz"), "-C", temporary, "package/dist", "package/LICENSE"],
    { stdout: "inherit", stderr: "inherit" },
  )
  if ((await child.exited) !== 0) throw new Error("SDK extraction failed")
  const staging = join(temporary, "snapshot")
  await mkdir(staging)
  const files: Record<string, string> = {}
  async function copy(relative = "") {
    await Promise.all(
      (
        await readdir(join(temporary, "package/dist", relative), {
          withFileTypes: true,
        })
      ).map(async (entry) => {
        const name = join(relative, entry.name)
        if (entry.isDirectory()) await copy(name)
        else if (name.endsWith(".js") || name.endsWith(".d.ts")) {
          let data = await readFile(join(temporary, "package/dist", name), "utf8")
          if (name.endsWith(".js")) data = data.replace(/^\/\/# sourceMappingURL=.*\n?/gm, "")
          await mkdir(join(staging, relative), { recursive: true })
          await writeFile(join(staging, name), data)
          files[name] = createHash("sha256").update(data).digest("hex")
        }
      }),
    )
  }
  await copy()
  await cp(join(temporary, "package/LICENSE"), join(staging, "LICENSE"))
  files.LICENSE = createHash("sha256")
    .update(await readFile(join(staging, "LICENSE")))
    .digest("hex")
  const sdk = await import(join(staging, "index.js"))
  if (typeof sdk.createKansoku !== "function" || sdk.version !== version)
    throw new Error("SDK exports do not match the pinned release")
  await writeFile(
    join(staging, "snapshot.json"),
    JSON.stringify(
      {
        version,
        tarball,
        integrity,
        gitHead,
        files: Object.fromEntries(Object.entries(files).sort(([a], [b]) => a.localeCompare(b))),
      },
      null,
      2,
    ) + "\n",
  )
  await writeFile(
    join(staging, "README.md"),
    `# Kansoku browser SDK snapshot\n\nSource: mori://shinzui/kansoku-ts/packages/kansoku-js\n\nPublished npm release: kansoku-js ${version}; upstream release tag kansoku-js@${version} at ${gitHead}.\n\nTarball: ${tarball}\n\nIntegrity: ${integrity}\n\nBundle SHA-256: ${files["index.js"]}\n\nThe MIT license, every JavaScript chunk (including lazy Web Vitals), and declarations are retained. Only source-map trailers are removed; source maps are omitted. Per-file SHA-256 values are in snapshot.json. Normal builds need no SDK checkout or network fetch. The app loads the SDK only after enabled configuration and verified identity.\n\nRegenerate with Bun from web/: bun apps/docs/scripts/vendor-kansoku.ts.\n`,
  )
  const next = `${destination}.next`
  const previous = `${destination}.previous`
  await rm(next, { recursive: true, force: true })
  await cp(staging, next, { recursive: true })
  let replaced = false
  try {
    await rename(destination, previous)
    replaced = true
  } catch (error) {
    if ((error as NodeJS.ErrnoException).code !== "ENOENT") throw error
  }
  try {
    await rename(next, destination)
  } catch (error) {
    if (replaced) await rename(previous, destination)
    throw error
  }
  if (replaced) await rm(previous, { recursive: true })
  console.log(`Vendored npm kansoku-js ${version}; ${Object.keys(files).length} verified files`)
} finally {
  await rm(temporary, { recursive: true, force: true })
}
