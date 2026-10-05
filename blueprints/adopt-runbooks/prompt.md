# Adopt operational runbooks

Read `migration-reference.md` and the shipped `runbooks-profile.dhall` before editing.
Read repository instructions, inventory candidate paths and existing profiles, and
preserve unrelated changes. Use Mori to locate dependency sources and documentation.

Adopt only executable operating procedures. Inspect `docs/runbooks`, `docs/operations`
and any operator-selected paths; a directory name does not establish document type.
Keep deployment configuration and architecture references outside the runbook bundle.
Split a composite runbook only when its independently usable procedures can be preserved
with clear identities, navigation, ownership and recovery boundaries. Retain compatibility
pages for moved paths and preserve exposed Mori doc keys.

Install the exact shipped snapshot as the local profile descriptor; never import a
nonexistent release. Allocate new handles with `okf id next`, preserve valid existing
handles and stop for conflicting identities. Populate required metadata from repository
evidence. Record yourself truthfully as the migration producer; retain meaningful source
history. Ask for unresolved owner/environment facts rather than inventing them. Do not
claim `verified` from type-checks or metadata validation.

Use the body contract in the migration reference to review procedure usability. Keep
commands, branching decisions and checks in Markdown. If operational details cannot be
established, retain them as explicit gaps and mark the document draft; do not invent a
rollback or run any procedure to satisfy adoption.

Generate OKF 0.2 indexes, record migration changes in log.md, add Mori bundle registration
when a manifest exists, and integrate strict profile/log enforcement into the existing
checks. Validate the shipped profile and blueprint using their native tools. Re-run the
migration without renumbering handles or restamping unchanged pages.

Do not commit, push, execute service/data commands or change a shared registry unless
explicitly authorized. Report adopted procedures, unresolved gaps and validation evidence.
