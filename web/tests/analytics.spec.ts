import { test, expect } from "@playwright/test"
import { spawn, type ChildProcess } from "node:child_process"
import { createServer, type Server } from "node:http"
import path from "node:path"
const workspace = path.resolve(import.meta.dirname, "..")
const origin = "http://127.0.0.1:18721"
const collector = "http://127.0.0.1:18722"
const events: Record<string, unknown>[] = []
let app: ChildProcess
let server: Server
async function ready() {
  for (let i = 0; i < 100; i++) {
    try {
      if ((await fetch(origin + "/healthz")).ok) return
    } catch {
      /* startup */
    }
    await new Promise((resolve) => setTimeout(resolve, 100))
  }
  throw new Error("Analytics fixture did not start")
}
test.describe("production Kansoku integration", () => {
  test.skip(!!process.env.DOCS_TEST_URL, "Separate controlled production fixture")
  test.beforeAll(async () => {
    server = createServer(async (request, response) => {
      response.setHeader("Access-Control-Allow-Origin", "*")
      response.setHeader("Access-Control-Allow-Headers", "content-type,x-api-key")
      response.setHeader("Access-Control-Allow-Methods", "POST,OPTIONS")
      if (request.method === "OPTIONS") {
        response.writeHead(204).end()
        return
      }
      const chunks: Buffer[] = []
      for await (const chunk of request) chunks.push(Buffer.from(chunk))
      const batch = JSON.parse(Buffer.concat(chunks).toString())
      events.push(...batch)
      response
        .writeHead(202, { "Content-Type": "application/json" })
        .end(JSON.stringify({ accepted: batch.length, rejected: [] }))
    })
    await new Promise<void>((resolve) => server.listen(18722, "127.0.0.1", resolve))
    app = spawn("bun", ["run", "start"], {
      cwd: workspace,
      stdio: "ignore",
      detached: true,
      env: {
        ...process.env,
        PORT: "18721",
        DOCS_CONTENT_ROOT: path.resolve(workspace, ".."),
        DOCS_CONTENT_CONFIG: "publication.json",
        DOCS_TRUST_FORWARDED_USER: "1",
        DOCS_ANALYTICS_CONFIG: JSON.stringify({
          enabled: true,
          baseUrl: collector,
          writeKey: "ksk_w_browser_fixture",
          sourceService: "okf-profiles",
          identity: { mode: "required", endpoint: "/api/analytics/identity" },
        }),
      },
    })
    await ready()
  })
  test.afterAll(async () => {
    if (app?.pid)
      try {
        process.kill(-app.pid, "SIGTERM")
      } catch {
        /* exited */
      }
    if (server) await new Promise<void>((resolve) => server.close(() => resolve()))
  })
  test.beforeEach(() => {
    events.length = 0
  })
  test("verified visits reach the real SDK without search or fragment data", async ({ page }) => {
    await page.route(origin + "/**", (route) =>
      route.continue({
        headers: { ...route.request().headers(), "X-Forwarded-User": "user_browser_fixture" },
      }),
    )
    await page.goto(origin + "/?private=never-record#secret")
    await expect
      .poll(() => events.filter((e) => e.eventName === "page_view").length, { timeout: 12000 })
      .toBe(1)
    await page.getByRole("searchbox").first().fill("features acceptanceCriteria")
    await page.locator(".profile-sidebar .search-results a").first().click()
    await expect(page).toHaveURL(/features\/types\/feature#acceptancecriteria/)
    await page
      .getByRole("navigation", { name: "On this page" })
      .getByRole("link", { name: "Frontmatter rules", exact: true })
      .click()
    await expect
      .poll(() => events.filter((e) => e.eventName === "page_view").length, { timeout: 12000 })
      .toBe(2)
    await page.waitForTimeout(5200)
    expect(events.filter((e) => e.eventName === "page_view")).toHaveLength(2)
    const views = events.filter((e) => e.eventName === "page_view")
    expect(views.map((e) => e.url)).toEqual([
      origin + "/",
      origin + "/docs/docs/profiles/features/types/feature",
    ])
    expect(
      views.every((e) => e.userId === "user_browser_fixture" && e.sourceService === "okf-profiles"),
    ).toBe(true)
    expect(JSON.stringify(events)).not.toMatch(
      /private=|never-record|#secret|#acceptancecriteria|#frontmatter|utm_/,
    )
    const stored = await page.evaluate(() => [
      ...Object.keys(localStorage),
      ...Object.keys(sessionStorage),
    ])
    expect(stored.filter((key) => /kansoku|okf-profiles\./.test(key))).toEqual([])
  })
  test("no identity or privacy opt-out sends no events and reader works", async ({ page }) => {
    await page.goto(origin + "/")
    await page.waitForTimeout(5500)
    expect(events).toEqual([])
    await page.route(origin + "/**", (route) =>
      route.continue({
        headers: { ...route.request().headers(), "X-Forwarded-User": "user_browser_fixture" },
      }),
    )
    await page.addInitScript(() => {
      Object.defineProperty(navigator, "globalPrivacyControl", { value: true })
    })
    await page.reload()
    await expect(
      page.getByRole("heading", { name: "Good documents start with a contract." }),
    ).toBeVisible()
    await page.waitForTimeout(5500)
    expect(events).toEqual([])
  })
  test("unavailable identity preserves reading and disabled config loads no SDK", async ({
    page,
  }) => {
    await page.route("**/api/analytics/identity", (route) => route.abort())
    await page.goto(origin + "/docs/docs/profiles/features/profile")
    await expect(page.locator("article h1")).toBeVisible()
    await page.waitForTimeout(2500)
    expect(events).toEqual([])
    const requests: string[] = []
    page.on("request", (request) => requests.push(request.url()))
    await page.goto("http://127.0.0.1:18714/")
    await expect(
      page.getByRole("heading", { name: "Good documents start with a contract." }),
    ).toBeVisible()
    await page.waitForTimeout(500)
    expect(
      requests.some((url) => url.includes("/api/analytics/identity") || url.startsWith(collector)),
    ).toBe(false)
    expect(events).toEqual([])
  })
})
