import path from "node:path"
const child = Bun.spawn(["bun", "run", "--cwd", "apps/docs", "dev", ...process.argv.slice(2)], {
  stdin: "inherit",
  stdout: "inherit",
  stderr: "inherit",
  env: {
    ...process.env,
    DOCS_CONTENT_ROOT: path.resolve(process.env.DOCS_CONTENT_ROOT ?? ".."),
    DOCS_CONTENT_CONFIG: process.env.DOCS_CONTENT_CONFIG ?? "publication.json",
  },
})
for (const signal of ["SIGINT", "SIGTERM"] as const) process.on(signal, () => child.kill(signal))
process.exit(await child.exited)
