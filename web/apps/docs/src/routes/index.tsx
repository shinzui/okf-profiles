import { createFileRoute, Link } from "@tanstack/react-router"
import { Route as Root } from "./__root"
export const Route = createFileRoute("/")({ component: Home })
function Home() {
  const collection = Root.useLoaderData()
  return (
    <article className="prose">
      <p className="eyebrow">Documentation</p>
      <h1>{collection.siteName}</h1>
      <p>A collection to read, search, and share.</p>
      <ul>
        {collection.summaries.map((d) => (
          <li key={d.identity}>
            <Link to={d.href}>{d.title}</Link>
            {d.description && <p>{d.description}</p>}
          </li>
        ))}
      </ul>
    </article>
  )
}
