# Adopt structured improvement-request contracts

Inspect this repository's existing improvement requests and, where the repository already states
the necessary facts, promote source dependencies and acceptance conditions from prose into the
`dependencies` and `acceptanceCriteria` frontmatter defined by
`coordination.improvementRequests` in okf-profiles v0.12.0.

This is optional enrichment. Existing requests are valid without either field. Preserve unrelated
changes in the working tree, preserve every stable handle, and leave uncertain material in prose
for a human to resolve. Read `contract-reference.md` before editing anything; it is the exact
contract for this run.

## Discover the applicable bundles

Use repository evidence rather than assuming the bundle is at a conventional path.

1. Inspect the repository's Mori declaration with `mori show --full` when available. Look for an
   OKF bundle governed by `coordination.improvementRequests`.
2. Search local Dhall descriptors for the `coordination.improvementRequests` export and search
   check scripts, build targets, or CI for `okf validate --profile` invocations.
3. Confirm each candidate by reading its descriptor and a representative concept. Do not treat an
   arbitrary Markdown directory or a different profile family as an improvement-request bundle.

If no applicable bundle exists, change nothing and report that the playbook is not applicable.
That is a successful outcome.

## Establish the baseline

For every applicable bundle, identify its existing validation command and run it before editing.
Keep the output so inherited failures are not mistaken for changes made by this playbook.

Read the local profile descriptor. If it is a plain or customized import of
`coordination.improvementRequests` older than v0.12.0, change only the imported tag to v0.12.0,
remove only the old import hash, and run `dhall freeze` on that descriptor. Preserve every local
overlay. Do not replace a locally authored profile with the shared profile; report it separately
because it may not declare the new fields. Do not weaken `--strict` or `--profile-enforce` to make
a bundle pass.

Confirm that the repository uses `okf` 0.8.0.0 or later before authoring either new field. An older
decoder cannot understand the nested reference policy or record-list uniqueness rule. If the
required released profile tag or decoder is unavailable, stop without editing documents and
report the prerequisite.

## Promote dependencies conservatively

Create a `dependencies` entry only when repository evidence establishes all three members:

- `ref` is a full canonical Mori URI targeting an improvement request in the exact form documented
  in `contract-reference.md`. Never turn a bare `IR-N` into a cross-repository reference by
  guessing its namespace or project.
- `kind` is explicitly stated as `hard`, `soft`, or `integration`, or is unambiguously grouped
  beneath a prose heading with one of those meanings. Do not infer the kind from urgency,
  chronology, or status.
- `reason` is already stated by the request, its linked plan, or another repository artifact. Keep
  it concise without changing the source relationship's meaning.

Deduplicate by `ref` plus `kind`. Preserve an already-valid structured dependency verbatim unless
repository evidence proves it wrong. These dependencies describe source fulfillment
relationships; they are not incident alerts, schedule blockers, or a computed readiness graph.

## Promote acceptance criteria conservatively

Create an `acceptanceCriteria` entry only when the repository states both an observable condition
and how that condition will be verified. A numbered acceptance list may supply stable ordering,
but a task list, implementation step, or completed-evidence claim is not automatically an
acceptance contract.

Preserve existing valid `AC-N` identifiers. For explicit prose criteria that have no identifiers,
allocate `AC-1`, `AC-2`, and so on in their existing order, starting after the largest identifier
already present in that request. IDs are request-local: another request may also have `AC-1`.
Never renumber an existing identifier merely to close a gap.

Write the observable condition as `statement` and the already-stated command, inspection, or
evidence procedure as `verification`. Do not claim that evidence exists merely because the
procedure is known. If either half is missing or ambiguous, leave the prose unchanged and report
the unresolved criterion rather than inventing text that makes validation pass.

## Preserve the source and validate

Do not delete or rewrite the prose sections from which structured data was promoted. They remain
the explanatory source and allow a reviewer to compare the new frontmatter with the author's
meaning. Do not change request status, `IR-N` handles, unrelated frontmatter, or body prose.

After editing, run Dhall type checking for every changed descriptor and the repository's own OKF
validation command. If no wrapper exists, use the strict command in `contract-reference.md`. When
the bundle maintains `log.md`, add one truthful migration entry using its existing convention and
regenerate indexes only if that repository's checks require it.

Finish with a report that names:

- every bundle inspected and whether it was applicable;
- every descriptor repinned, including its old and new tag;
- every request changed and the dependency or criterion IDs added;
- every ambiguous item deliberately left in prose;
- the exact validation commands and their outcomes; and
- any inherited failure that remains.

Re-running this playbook must be safe: valid structured records are preserved, no duplicate record
is added, and a conforming document is not rewritten for formatting alone.
