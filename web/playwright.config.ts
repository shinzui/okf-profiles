import { defineConfig } from "@playwright/test"
import path from "node:path"
export default defineConfig({
  testDir: "./tests",
  workers: 1,
  use: {
    baseURL: process.env.DOCS_TEST_URL ?? "http://127.0.0.1:18714",
    permissions: ["clipboard-read", "clipboard-write"],
  },
  webServer: process.env.DOCS_TEST_URL
    ? undefined
    : {
        command: "bun run build && bun run start",
        url: "http://127.0.0.1:18714/healthz",
        env: {
          ...process.env,
          PORT: "18714",
          DOCS_CONTENT_ROOT: path.resolve(process.env.DOCS_CONTENT_ROOT ?? ".."),
          DOCS_CONTENT_CONFIG: process.env.DOCS_CONTENT_CONFIG ?? "publication.json",
        },
        reuseExistingServer: false,
      },
})
