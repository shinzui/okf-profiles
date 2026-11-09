import { readFileSync } from "node:fs"
import { createHash } from "node:crypto"
import tailwindcss from "@tailwindcss/vite"
import { tanstackStart } from "@tanstack/react-start/plugin/vite"
import react from "@vitejs/plugin-react"
import { defineConfig, type Plugin } from "vite"

function vendoredFonts(): Plugin {
  const directory = new URL("./public/fonts/", import.meta.url)
  const manifest = JSON.parse(readFileSync(new URL("font-sources.json", directory), "utf8")) as {
    file: string
    sha256: string
  }[]
  const fonts = manifest.map((record) => {
    const bytes = Buffer.from(
      readFileSync(new URL(record.file + ".base64", directory), "utf8"),
      "base64",
    )
    if (createHash("sha256").update(bytes).digest("hex") !== record.sha256)
      throw new Error(`Font checksum mismatch: ${record.file}`)
    return { file: record.file, bytes }
  })
  return {
    name: "vendored-fonts",
    applyToEnvironment: (environment) => environment.name === "client",
    configureServer(server) {
      server.middlewares.use((req, res, next) => {
        const font = fonts.find((f) => req.url === "/fonts/" + f.file)
        if (!font) return next()
        res.setHeader("Content-Type", "font/woff2")
        res.end(font.bytes)
      })
    },
    generateBundle() {
      for (const font of fonts)
        this.emitFile({ type: "asset", fileName: "fonts/" + font.file, source: font.bytes })
    },
  }
}
export default defineConfig(({ command }) => ({
  ssr: command === "build" ? { noExternal: true } : {},
  plugins: [vendoredFonts(), tailwindcss(), tanstackStart(), react()],
}))
