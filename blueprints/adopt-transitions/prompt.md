# Adopt declared platform transitions

Inspect the repository instructions, mori.dhall, architecture decisions, platform plans,
and existing transition documents. Identify explicit owner-backed intent to move responsibilities
between projects. Use Mori to discover canonical owning project identities and typed links.
If no such intent exists, report that finding and make no changes. Do not manufacture a transition
from a project lifecycle, a DDD context status, a capability, or an observation alone.

Read the supplied migration-reference.md and transitions-profile.dhall. Preserve existing TR-N
handles and text, including requirements whose meaning is unsettled. Reuse existing concepts;
allocate the next unused numeric TR handle only for an independently supported transition.
Use type: Transition and transitionId: TR-N in one root Markdown concept per transition.
Record coordinator, kind, declared phase, environments, accountable role and party, predecessors,
successors and responsibilities. For an unresolved successor use pendingIdentity instead of a
made-up project URI. Never invent an accountable party, requirement owner, disposition, runtime
finding or acceptance. Report missing intent or ownership as an unresolved authoring issue.

Requirements are scoped to a listed predecessor. Preserve stable requirement and duty keys.
An empty requirements list means unknown readiness. Respect the defaults and restrictions in
the reference. Keep evidence envelopes outside the declaration bundle. Declared phase and prose
never prove runtime cutover or retirement readiness. Leave project lifecycle, DDD context state,
and capability catalogs under their owning projects.

Create or reuse docs/transitions/index.md with okf_version: "0.2" and descriptive navigation.
Use generated provenance and truthful review records. Add a reproducible local profile descriptor
from the supplied snapshot, register the bundle using Schema.OkfBundle completion in mori.dhall,
and add a local validation recipe following repository conventions. Preserve existing bundles.
Run strict OKF/profile/log validation and mori transitions validate --path . when available.
If the installed Mori CLI lacks transitions validation, report that semantic validation remains
pending; do not assert success. Re-running on an adopted repository must reuse handles and yield
no content changes unless new explicit intent or a contract defect requires them.

Show the resulting concepts, unresolved authoring issues and validation results. Follow the
user's current authorization and repository policy for registration, commits and publication.
