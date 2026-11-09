import { readFile } from "node:fs/promises"
import path from "node:path"
import { test, expect } from "@playwright/test"
test("generated profile and type links resolve in two separate bundles", async ({ page }) => {
  for (const [bundle, type] of [
    ["features", "Feature"],
    ["pattern-catalog", "Pattern"],
  ]) {
    await page.goto(`/docs/docs/profiles/${bundle}/profile`)
    await page.locator("article").getByRole("link", { name: type, exact: true }).click()
    await expect(page).toHaveURL(new RegExp(`/docs/docs/profiles/${bundle}/types/`))
    await page.locator("article").locator(`a[href="/docs/docs/profiles/${bundle}/profile"]`).click()
    await expect(page).toHaveURL(new RegExp(`/docs/docs/profiles/${bundle}/profile$`))
  }
})

test("every catalog page is reachable and unpublished paths return 404", async ({
  page,
  request,
}) => {
  test.setTimeout(120000)
  await page.goto("/")
  await expect(
    page.getByRole("heading", { name: "Good documents start with a contract." }),
  ).toBeVisible()
  await expect(page.locator(".profile-card")).toHaveCount(30)
  const paths = new Set(
    await page
      .locator('main a[href^="/docs/"]')
      .evaluateAll((links) => links.map((link) => link.getAttribute("href"))),
  )
  const manifest = JSON.parse(
    await readFile(path.resolve(import.meta.dirname, "../../publication.json"), "utf8"),
  )
  for (const bundle of manifest.bundles) {
    await page
      .locator(`.profile-tree details`)
      .filter({ has: page.locator(`a[href="/docs/${bundle.directory}/profile"]`) })
      .evaluate((details) => details.setAttribute("open", ""))
  }
  const navigation = new Set(
    await page
      .locator('.profile-sidebar a[href^="/docs/"]')
      .evaluateAll((links) => links.map((link) => link.getAttribute("href"))),
  )
  for (const source of manifest.documents) {
    const href = "/docs/" + source.replace(/\.md$/, "")
    expect(navigation.has(href) || paths.has(href), source).toBe(true)
    const response = await request.get(href)
    expect(response.status(), source).toBe(200)
    expect(await response.text(), source).toContain("<article")
  }
  for (const href of [
    "/docs/missing",
    "/docs/README",
    "/docs/docs/adr/index",
    "/published/package.dhall",
  ]) {
    expect((await request.get(href)).status(), href).toBe(404)
  }
  await page.goto("/docs/docs/profiles/okf-v0-2/profile")
  await expect(page.locator("article h1")).toHaveText("okf-v0-2")
})

test("keyboard field search, qualified results, clear and empty state", async ({ page }) => {
  await page.goto("/")
  const search = page.getByRole("searchbox", { name: "Search documents" }).first()
  await search.focus()
  await search.fill("features acceptanceCriteria")
  const result = page.locator(".profile-sidebar .search-results a").first()
  await expect(result).toContainText("Features")
  await page.keyboard.press("Tab")
  await expect(result).toBeFocused()
  await page.keyboard.press("Enter")
  await expect(page).toHaveURL(/features\/types\/feature#acceptancecriteria/)
  const id = new URL(page.url()).hash.slice(1)
  await expect(page.locator(`[id="${id}"]`)).toBeInViewport()
  await search.fill("generated")
  await expect(
    page.locator(".profile-sidebar .result-profile").filter({ hasText: "Features" }).first(),
  ).toBeVisible()
  await expect(
    page.locator(".profile-sidebar .result-profile").filter({ hasText: "Designs" }).first(),
  ).toBeAttached()
  await search.fill("nothing-matches-this-field-xyz")
  await expect(page.getByText("No documents found").first()).toBeVisible()
  await search.fill("")
  await expect(page.locator(".profile-sidebar .profile-tree")).toBeVisible()
})

test("deep sections survive copy, reload, back and forward", async ({ page }) => {
  await page.goto("/docs/docs/profiles/features/types/feature")
  const sections = page.getByRole("navigation", { name: "On this page" })
  await sections.getByRole("link", { name: "Frontmatter rules", exact: true }).click()
  await expect(page).toHaveURL(/#frontmatter-rules$/)
  const field = sections.locator('a[href^="#acceptancecriteria"]')
  await field.click()
  await expect(page).toHaveURL(/#acceptancecriteria/)
  const url = page.url()
  await sections.getByRole("button", { name: /^Copy link to acceptanceCriteria/ }).click()
  expect(await page.evaluate(() => navigator.clipboard.readText())).toBe(url)
  await page.reload()
  await expect(page.locator(`[id="${new URL(url).hash.slice(1)}"]`)).toBeInViewport()
  await page.goBack()
  await expect(page).toHaveURL(/#frontmatter-rules$/)
  await page.goForward()
  await expect(page).toHaveURL(url)
})

test("local fonts, guidance, and responsive themes with visible focus", async ({ page }) => {
  const errors: string[] = []
  page.on("pageerror", (error) => errors.push(error.message))
  const external: string[] = []
  await page.route("**/*", (route) => {
    if (
      new URL(route.request().url()).origin !==
      new URL(process.env.DOCS_TEST_URL ?? "http://127.0.0.1:18714").origin
    ) {
      external.push(route.request().url())
      return route.abort()
    }
    return route.continue()
  })
  for (const width of [1440, 390]) {
    await page.setViewportSize({ width, height: 1000 })
    await page.goto("/docs/docs/profiles/designs/types/design-brief")
    await expect(page.getByRole("heading", { name: "Guidance", exact: true })).toBeVisible()
    await expect(page.getByRole("heading", { name: "Type-specific", exact: true })).toBeVisible()
    for (const theme of ["light", "dark"]) {
      if ((await page.locator("html").getAttribute("data-theme")) !== theme)
        await page.getByRole("button", { name: "Toggle theme" }).click()
      await expect(page.locator("html")).toHaveAttribute("data-theme", theme)
      await page.reload()
      await expect(page.locator("html")).toHaveAttribute("data-theme", theme)
      expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(
        true,
      )
      expect(
        await page.evaluate(async () => {
          const serif = await document.fonts.load('18px "Geist Serif"')
          const mono = await document.fonts.load('14px "Paper Mono"')
          return serif.length > 0 && mono.length > 0
        }),
      ).toBe(true)
      await page.getByRole("button", { name: "Toggle theme" }).focus()
      expect(
        await page
          .getByRole("button", { name: "Toggle theme" })
          .evaluate((button) => getComputedStyle(button).outlineStyle),
      ).toBe("solid")
      if (process.env.DOCS_EVIDENCE_DIR)
        await page.screenshot({
          path: path.join(process.env.DOCS_EVIDENCE_DIR, `design-brief-${width}-${theme}.png`),
        })
    }
  }
  await page.setViewportSize({ width: 1440, height: 1000 })
  await page.goto("/")
  if (process.env.DOCS_EVIDENCE_DIR)
    await page.screenshot({ path: path.join(process.env.DOCS_EVIDENCE_DIR, "catalog-desktop.png") })
  expect(errors).toEqual([])
  expect(external).toEqual([])
})

test("mobile navigation and section disclosure", async ({ page }) => {
  await page.setViewportSize({ width: 390, height: 844 })
  await page.goto("/")
  await page.getByRole("button", { name: "Open navigation" }).click()
  const dialog = page.getByRole("dialog", { name: "Navigation" })
  await expect(dialog).toBeVisible()
  await dialog.getByRole("searchbox").fill("features acceptanceCriteria")
  await dialog.locator(".search-results a").first().click()
  await expect(dialog).not.toBeVisible()
  await expect(page).toHaveURL(/features\/types\/feature#acceptancecriteria/)
  const sections = page.getByRole("navigation", { name: "On this page" })
  await expect(sections.locator("details")).not.toHaveAttribute("open", "")
  await sections.locator("summary").click()
  await expect(sections.getByRole("link", { name: "Frontmatter rules", exact: true })).toBeVisible()
})
