import { createFileRoute, Link } from "@tanstack/react-router"
import { catalog, groups } from "@okf-profiles-web/corpus/catalog"
import { Route as Root } from "./__root"
export const Route = createFileRoute("/")({ component: Home })
function Home() {
  const collection = Root.useLoaderData()
  const profiles = catalog(collection.summaries)
  return (
    <article className="catalog">
      <div className="catalog-intro">
        <p className="eyebrow">Open Knowledge Format / Reference</p>
        <h1>
          Good documents
          <br />
          start with a contract.
        </h1>
        <p className="lede">
          Explore the profiles that give knowledge its shape. Find the types, fields, and
          conventions for the document you’re writing.
        </p>
        <p className="catalog-count">
          {profiles.length} profiles <span aria-hidden="true">·</span>{" "}
          {profiles.reduce((n, entry) => n + entry.types.length, 0)} concept types{" "}
          <span aria-hidden="true">·</span> OKF v0.2
        </p>
      </div>
      <nav className="family-links" aria-label="Profile families">
        {groups.map((group) => (
          <a key={group} href={`#${group.toLowerCase()}`}>
            {group}
          </a>
        ))}
      </nav>
      {groups.map((group) => (
        <section key={group} id={group.toLowerCase()} className="catalog-family">
          <div className="family-heading">
            <h2>{group}</h2>
            <span>{profiles.filter((entry) => entry.group === group).length} profiles</span>
          </div>
          <div className="profile-cards">
            {profiles
              .filter((entry) => entry.group === group)
              .map((entry) => (
                <section className="profile-card" key={entry.profile.path}>
                  <h3>
                    <Link to={entry.profile.href}>{entry.name}</Link>
                  </h3>
                  <code className="export-path">{entry.profile.exportPath}</code>
                  <p>{entry.profile.description}</p>
                  <div className="type-links">
                    {entry.types.map((doc) => (
                      <Link key={doc.path} to={doc.href}>
                        {doc.title}
                        <span aria-hidden="true"> ↗</span>
                      </Link>
                    ))}
                    {!entry.types.length && <span className="muted">Shared format rules</span>}
                  </div>
                </section>
              ))}
          </div>
        </section>
      ))}
    </article>
  )
}
