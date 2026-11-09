import { releaseHeading } from "./reference-layout"
import type { Summary } from "./types"
export const groups = ["Assurance", "Coordination", "Documentation", "Format", "PostgreSQL"]
export function profileLabel(bundle: string) {
  if (bundle === "okf-v0-2") return "OKF v0.2"
  if (bundle === "postgresql") return "PostgreSQL"
  if (bundle === "tan-postgresql") return "Tan PostgreSQL"
  return bundle
    .split("-")
    .map((word) => word[0]!.toUpperCase() + word.slice(1))
    .join(" ")
}
export function profileGroup(exportPath: string) {
  if (exportPath === "okfV02") return "Format"
  if (["postgresql", "tanPostgresql"].includes(exportPath)) return "PostgreSQL"
  const family = exportPath.split(".")[0]!
  return family[0]!.toUpperCase() + family.slice(1)
}
export function catalog(summaries: Summary[]) {
  return summaries
    .filter((d) => d.path.endsWith("/profile.md") && d.bundle)
    .map((profile) => ({
      profile,
      name: profileLabel(profile.bundle!),
      group: profileGroup(profile.exportPath ?? ""),
      pages: summaries.filter((d) => d.bundle === profile.bundle),
      types: summaries.filter(
        (d) => d.bundle === profile.bundle && d.metadata.type === "OKF Profile Type",
      ),
    }))
    .sort((a, b) => a.name.localeCompare(b.name))
}
export function searchDocuments(summaries: Summary[], query: string) {
  const terms = query.toLowerCase().trim().split(/\s+/).filter(Boolean)
  if (!terms.length) return []
  const matches = (value: string) => terms.every((term) => value.toLowerCase().includes(term))
  const ranked = summaries.flatMap((doc) => {
    const profile = doc.bundle ? profileLabel(doc.bundle) : doc.title
    const title = doc.path.endsWith("/index.md")
      ? doc.path.endsWith("/types/index.md")
        ? "Concept types"
        : "Bundle index"
      : doc.path.endsWith("/profile.md")
        ? profile
        : doc.title
    const context = `${profile} ${title} ${doc.description} ${doc.exportPath ?? ""}`.toLowerCase()
    const results = matches(context)
      ? [
          {
            href: doc.href,
            title,
            profile,
            description: doc.description,
            rank: matches(title) ? 0 : 2,
          },
        ]
      : []
    for (const heading of doc.headings) {
      // Repeated changelog labels such as "Added" are not useful destinations.
      if (heading.depth < 2 || (!doc.bundle && heading.depth > 2)) continue
      if (matches(`${context} ${heading.text}`)) {
        const release = doc.bundle ? null : releaseHeading(heading.text)
        const label = release
          ? [release.version, release.date].filter(Boolean).join(" — ")
          : heading.text
        results.push({
          href: `${doc.href}#${heading.id}`,
          title: `${title} · ${label}`,
          profile,
          description: "Section",
          rank: matches(heading.text) ? 1 : 3,
        })
      }
    }
    return results
  })
  // Array.prototype.sort is stable, so equal ranks keep catalog order.
  return ranked.sort((a, b) => a.rank - b.rank).map(({ rank: _rank, ...result }) => result)
}
