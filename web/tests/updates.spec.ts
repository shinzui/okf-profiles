import { test, expect } from "@playwright/test"
import { mkdtemp, cp, readFile, writeFile, rm } from "node:fs/promises"
import { spawn, execFileSync, type ChildProcess } from "node:child_process"
import os from "node:os"
import path from "node:path"
const workspace = path.resolve(import.meta.dirname, "..")
const repository = path.resolve(workspace, "..")
let root: string
const servers: ChildProcess[] = []
const source = 'const message = "<literal-markup>"\nconsole.log(message)\n'
const fixture = "docs/profiles/features/types/reader-fixture.md"
const fixtureUrl = "/docs/docs/profiles/features/types/reader-fixture"
const production = "http://127.0.0.1:18715"
const development = "http://127.0.0.1:18716"
function selection() {
  execFileSync("python3", [
    path.join(repository, "scripts/profile-docs-publication.py"),
    "--write",
    "--root",
    root,
  ])
}
async function waitFor(url: string) {
  for (let i = 0; i < 100; i++) {
    try {
      if ((await fetch(url)).ok) return
    } catch {
      /* Startup. */
    }
    await new Promise((resolve) => setTimeout(resolve, 100))
  }
  throw new Error(`Server did not start: ${url}`)
}
test.describe("isolated regeneration and renderer fixtures", () => {
  test.skip(
    !!process.env.DOCS_TEST_URL,
    "External immutable runtime uses the catalog browser suite",
  )
  test.beforeAll(async () => {
    root = await mkdtemp(path.join(os.tmpdir(), "profile-reader-"))
    for (const relative of [
      "Profile",
      "profiles",
      "package.dhall",
      "CHANGELOG.md",
      "docs/profiles",
      "scripts/profile-docs-catalog.json",
      "publication.json",
    ])
      await cp(path.join(repository, relative), path.join(root, relative), { recursive: true })
    await writeFile(
      path.join(root, fixture),
      `---\ntype: OKF Profile Type\ntitle: Reader Fixture\ndescription: Isolated renderer acceptance\n---\n# Reader Fixture\n\n## Table\n\n| Field | Meaning |\n| --- | --- |\n| a | preserved |\n\n- Required\n  - Nested condition\n\n## Code\n\n\`\`\`typescript\n${source}\`\`\`\n\n[Reference profile][profile]\n\n[profile]: /profile.md\n`,
    )
    selection()
    for (const [command, url, port] of [
      ["start", production, "18715"],
      ["dev", development, "18716"],
    ]) {
      const server = spawn(
        "bun",
        ["run", command!, ...(command === "dev" ? ["--port", port!] : [])],
        {
          cwd: workspace,
          stdio: "ignore",
          detached: true,
          env: {
            ...process.env,
            PORT: port!,
            DOCS_CONTENT_ROOT: root,
            DOCS_CONTENT_CONFIG: "publication.json",
          },
        },
      )
      servers.push(server)
      await waitFor(url!)
    }
  })
  test.afterAll(async () => {
    for (const server of servers)
      if (server.pid) {
        try {
          process.kill(-server.pid, "SIGTERM")
        } catch {
          /* Already exited. */
        }
      }
    if (root) await rm(root, { recursive: true, force: true })
  })
  test("tables, nested conditions, reference links and exact fenced source", async ({ page }) => {
    await page.goto(production + fixtureUrl)
    await expect(page.getByRole("table")).toContainText("preserved")
    await expect(page.locator("article ul ul")).toContainText("Nested condition")
    await expect(page.getByRole("link", { name: "Reference profile" })).toHaveAttribute(
      "href",
      "/docs/docs/profiles/features/profile",
    )
    const example = page.getByRole("region", { name: "typescript example" })
    expect(await example.locator("code").textContent()).toBe(source)
    await example.getByRole("button", { name: "Copy", exact: true }).click()
    await expect(example.getByRole("button", { name: "Copied", exact: true })).toBeVisible()
    expect(await page.evaluate(() => navigator.clipboard.readText())).toBe(source)
    expect(await page.locator("article literal-markup").count()).toBe(0)
    const token = example.locator("code span span").first()
    const light = await token.evaluate((element) => getComputedStyle(element).color)
    await page.getByRole("button", { name: "Toggle theme" }).click()
    expect(await token.evaluate((element) => getComputedStyle(element).color)).not.toBe(light)
    await page.setViewportSize({ width: 390, height: 844 })
    expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  })
  test("removed type disappears from routes, navigation and search on the next generation", async ({
    page,
    request,
  }) => {
    await page.goto(production + "/")
    const search = page.getByRole("searchbox").first()
    await search.fill("Reader Fixture")
    await expect(page.locator(".profile-sidebar .search-results")).toContainText("Reader Fixture")
    await rm(path.join(root, fixture))
    selection()
    await page.reload()
    await page.getByRole("searchbox").first().fill("Reader Fixture")
    await expect(page.getByText("No documents found").first()).toBeVisible()
    await page.getByRole("searchbox").first().fill("")
    await expect(page.locator(`.profile-sidebar a[href="${fixtureUrl}"]`)).toHaveCount(0)
    expect((await request.get(production + fixtureUrl)).status()).toBe(404)
  })
  test("a real source description drifts, regenerates and refreshes development; snapshots stay fixed", async ({
    page,
  }) => {
    test.setTimeout(600000)
    const file = path.join(root, "profiles/coordination/features.dhall")
    const original = await readFile(file, "utf8")
    const marker = "Acceptance update from the isolated source profile. "
    await writeFile(
      file,
      original.replace(
        "Independently addressable product features",
        marker + "Independently addressable product features",
      ),
    )
    const generator = path.join(repository, "scripts/profile-docs-generate.py")
    let drift = ""
    try {
      execFileSync("python3", [generator, "check", "--root", root], {
        encoding: "utf8",
        stdio: "pipe",
      })
    } catch (error) {
      drift = String((error as { stderr: string }).stderr)
    }
    expect(drift).toContain("stale")
    execFileSync("python3", [generator, "regenerate", "--root", root])
    await page.goto(development + "/docs/docs/profiles/features/profile")
    await expect(page.locator("article")).toContainText(marker.trim())
    const snapshot = path.join(root, "snapshot")
    execFileSync("bun", ["scripts/content.ts", "snapshot", snapshot], {
      cwd: workspace,
      env: {
        ...process.env,
        DOCS_CONTENT_ROOT: root,
        DOCS_CONTENT_CONFIG: "publication.json",
        DOCS_COMMIT: "fixture-release",
      },
    })
    await writeFile(file, original)
    execFileSync("python3", [generator, "regenerate", "--root", root])
    const restored = await readFile(path.join(root, "docs/profiles/features/profile.md"), "utf8")
    const manifest = await readFile(path.join(root, "publication.json"), "utf8")
    execFileSync("python3", [generator, "regenerate", "--root", root])
    expect(await readFile(path.join(root, "docs/profiles/features/profile.md"), "utf8")).toBe(
      restored,
    )
    expect(await readFile(path.join(root, "publication.json"), "utf8")).toBe(manifest)
    await page.reload()
    await expect(page.locator("article")).not.toContainText(marker.trim())
    expect(
      await readFile(path.join(snapshot, "docs/profiles/features/profile.md"), "utf8"),
    ).toContain(marker)
    const snapshotServer = spawn("bun", ["run", "start"], {
      cwd: workspace,
      detached: true,
      stdio: "ignore",
      env: { ...process.env, PORT: "18717", DOCS_CONTENT_ROOT: snapshot },
    })
    servers.push(snapshotServer)
    await waitFor("http://127.0.0.1:18717/healthz")
    await page.goto("http://127.0.0.1:18717/docs/docs/profiles/features/profile")
    await expect(page.locator("article")).toContainText(marker.trim())
  })
})
