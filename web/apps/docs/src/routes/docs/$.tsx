import { createFileRoute, Link, notFound } from "@tanstack/react-router"
import { getDocument } from "../../server/content"
import { TableOfContents } from "../../components/table-of-contents"
import { profileLabel } from "@okf-profiles-web/corpus/catalog"
import { fieldHeading, releaseHeading } from "@okf-profiles-web/corpus/reference-layout"
import type { Document, ProfileRelease } from "@okf-profiles-web/corpus/types"
import { Markdown } from "../../components/markdown"

const CHANGELOG = "CHANGELOG.md"
const CHANGELOG_HREF: string = "/docs/CHANGELOG"
const releaseLink = (anchor: string): string => `${CHANGELOG_HREF}#${anchor}`

function fieldCounts(doc: Document) {
  const counts = { required: 0, recommended: 0, optional: 0 }
  for (const heading of doc.headings) {
    const field = fieldHeading(heading.text)
    if (field) counts[field.level]++
  }
  return Object.entries(counts).filter(([, count]) => count)
}

function ProfileChangelog({ doc, changes }: { doc: Document; changes: ProfileRelease[] }) {
  return (
    <section className="profile-changelog">
      <h2 id="profile-changelog">Changelog</h2>
      <p className="muted">
        Release notes that name <code>{doc.exportPath}</code>. Catalog-wide changes are in the{" "}
        <Link to={CHANGELOG_HREF}>full changelog</Link>.
      </p>
      <ol>
        {changes.map((release) => (
          <li key={release.version}>
            <div className="change-head">
              <Link to={releaseLink(release.anchor)}>{release.version}</Link>
              {release.date && <time dateTime={release.date}>{release.date}</time>}
            </div>
            {release.entries.map((entry) => (
              <div className="change-entry" key={entry.markdown}>
                {entry.section && (
                  <span
                    className="release-kind"
                    data-kind={entry.section.split(" ")[0]!.toLowerCase()}
                  >
                    {entry.section}
                  </span>
                )}
                <Markdown
                  document={{
                    ...doc,
                    path: CHANGELOG,
                    bundleDirectory: null,
                    body: entry.markdown,
                  }}
                />
              </div>
            ))}
          </li>
        ))}
      </ol>
    </section>
  )
}

export const Route = createFileRoute("/docs/$")({
  loader: async ({ params }) => {
    const doc = await getDocument({ data: params._splat ?? "" })
    if (!doc) throw notFound()
    return doc
  },
  component: () => {
    const doc = Route.useLoaderData()
    const isChangelog = doc.path === CHANGELOG
    const releases = doc.headings.filter((heading) => heading.depth === 2)
    const headings = isChangelog
      ? releases.map((heading) => ({
          ...heading,
          text: releaseHeading(heading.text)?.version ?? heading.text,
        }))
      : doc.changes.length
        ? [...doc.headings, { id: "profile-changelog", text: "Changelog", depth: 2 }]
        : doc.headings
    const counts = fieldCounts(doc)
    return (
      <div className="document-layout">
        <article className={isChangelog ? "prose changelog" : "prose"}>
          <div className="doc-meta">
            <p className="eyebrow">
              {isChangelog
                ? `Release history · ${releases.filter((heading) => releaseHeading(heading.text)?.date).length} releases`
                : `${doc.bundle ? profileLabel(doc.bundle) : "Document"} · ${doc.metadata.type ?? "Index"}`}
            </p>
            {counts.length > 0 && (
              <p className="field-counts">
                {counts.map(([level, count]) => (
                  <span key={level} data-presence={level}>
                    {count} {level}
                  </span>
                ))}
              </p>
            )}
          </div>
          <Markdown
            document={doc}
            layout={isChangelog ? "changelog" : doc.bundle ? "reference" : "plain"}
          />
          {doc.changes.length > 0 && <ProfileChangelog doc={doc} changes={doc.changes} />}
          {!isChangelog && (
            <details>
              <summary>Document details</summary>
              <dl>
                {Object.entries(doc.metadata).map(([k, v]) => (
                  <div key={k}>
                    <dt>{k}</dt>
                    <dd>{v}</dd>
                  </div>
                ))}
                <dt>Identity</dt>
                <dd>{doc.identity}</dd>
              </dl>
            </details>
          )}
        </article>
        <TableOfContents headings={headings} />
      </div>
    )
  },
})
