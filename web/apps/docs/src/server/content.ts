import { createServerFn } from "@tanstack/react-start"
export const getCollection = createServerFn({ method: "GET" }).handler(async () => {
  const { collection } = await import("./reader.server")
  return collection()
})
export const getDocument = createServerFn({ method: "GET" })
  .validator((value: string) => {
    if (typeof value !== "string") throw new Error("Document path must be a string")
    return value
  })
  .handler(async ({ data }) => {
    const { document } = await import("./reader.server")
    return document(data)
  })
