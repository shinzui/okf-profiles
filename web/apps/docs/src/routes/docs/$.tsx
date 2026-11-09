import { createFileRoute, notFound } from "@tanstack/react-router"
import { getDocument } from "../../server/content"
import { Markdown } from "../../components/markdown"
export const Route = createFileRoute("/docs/$")({
  loader: async ({ params }) => {
    const doc = await getDocument({ data: params._splat ?? "" })
    if (!doc) throw notFound()
    return doc
  },
  component: () => {
    const doc = Route.useLoaderData()
    return (
      <article className="prose">
        <p className="eyebrow">{doc.bundle ?? "Document"}</p>
        <Markdown document={doc} />
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
      </article>
    )
  },
})
