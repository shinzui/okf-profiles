import path from "node:path"
const child = Bun.spawn(["bun", "run", "--cwd", "apps/docs", "dev", ...process.argv.slice(2)], {
  stdin: "inherit",
  stdout: "inherit",
  stderr: "inherit",
  env: { ...process.env, DOCS_CONTENT_ROOT: path.resolve(process.env.DOCS_CONTENT_ROOT ?? ".") },
})
for (const signal of ["SIGINT", "SIGTERM"] as const) process.on(signal, () => child.kill(signal))
process.exit(await child.exited)
