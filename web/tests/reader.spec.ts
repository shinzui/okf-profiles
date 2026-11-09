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
