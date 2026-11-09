// Browser-safe publication link resolution; no filesystem access.
export const docHref = (path: string) =>
  "/docs/" + path.replace(/\.md$/i, "").split("/").map(encodeURIComponent).join("/")
export function publishedLink(
  source: string,
  href: string,
  links: Record<string, string>,
  bundleDirectory: string | null = null,
): string | null {
  if (
    href.includes("\\") ||
    Array.from(href).some((char) => char.charCodeAt(0) <= 32) ||
    href.startsWith("//")
  )
    return null
  if (href.startsWith("#")) return href
  if (/^https?:\/\//i.test(href) || /^mailto:/i.test(href)) return href
  if (/^[a-z][a-z0-9+.-]*:/i.test(href)) return null
  try {
    const rooted = href.startsWith("/")
    if (rooted && !bundleDirectory) return null
    const [rawPath] = href.split(/[?#]/)
    const decoded = decodeURIComponent(rawPath!)
    if (decoded.includes("\\") || decoded.includes("\0") || decoded.startsWith("//")) return null
    const parts = rooted ? bundleDirectory!.split("/") : source.split("/").slice(0, -1)
    const floor = rooted ? parts.length : 0
    for (const part of decoded.replace(/^\//, "").split("/")) {
      if (part === "..") {
        if (parts.length <= floor) return null
        parts.pop()
      } else if (part && part !== ".") parts.push(part)
    }
    const target = parts.join("/")
    const hash = href.includes("#") ? href.slice(href.indexOf("#")) : ""
    return Object.hasOwn(links, target) ? links[target] + hash : null
  } catch {
    return null
  }
}
export function resolveLink(
  source: string,
  href: string,
  documents: string[],
  assets: string[],
  bundleDirectory: string | null = null,
): string | null {
  const links = Object.fromEntries([
    ...documents.map((p) => [p, docHref(p)]),
    ...assets.map((p) => [p, "/published/" + p.split("/").map(encodeURIComponent).join("/")]),
  ])
  return publishedLink(source, href, links, bundleDirectory)
}
