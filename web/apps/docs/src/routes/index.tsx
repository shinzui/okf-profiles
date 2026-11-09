import { createFileRoute, Link } from "@tanstack/react-router"
import { catalog, groups } from "@okf-profiles-web/corpus/catalog"
import { Inline } from "../components/inline"
import { Route as Root } from "./__root"
export const Route = createFileRoute("/")({ component: Home })
function Home() {
  const collection = Root.useLoaderData()
  const profiles = catalog(collection.summaries)
  const latest = collection.latestRelease
  const changelog = collection.summaries.find((doc) => doc.path === "CHANGELOG.md")
  const latestHref: string = `${changelog?.href}#${latest?.anchor}`
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
      {latest && changelog && (
        <aside className="latest-release">
          <div>
            <p className="eyebrow">Latest release</p>
            <Link to={latestHref} className="latest-version">
              {latest.version}
            </Link>
            {latest.date && <time dateTime={latest.date}>{latest.date}</time>}
          </div>
          <p>
            <Inline text={latest.summary} />
          </p>
          <Link to={changelog.href} className="latest-all">
            All releases
          </Link>
        </aside>
      )}
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
                  <div className="card-meta">
                    <code className="export-path">{entry.profile.exportPath}</code>
                    {collection.profileReleases[entry.profile.bundle!] && (
                      <span className="card-release">
                        Changed in {collection.profileReleases[entry.profile.bundle!]}
                      </span>
                    )}
                  </div>
                  <p>
                    <Inline text={entry.profile.description} />
                  </p>
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
