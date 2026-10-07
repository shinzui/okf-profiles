# Transition authoring reference

The canonical contract originates in
mori://shinzui/mori/masterplans/40-track-platform-transitions-and-explain-predecessor-retirement
and mori://shinzui/mori/plans/294-decode-validate-and-query-declared-platform-transitions.

A Transition has a TR-N handle, coordinator project root, kind (split, absorption, replacement,
consolidation, extraction), declared phase (planned, in-progress, validating,
complete, abandoned), nonempty environments and accountable {role, party}.
Predecessors have project and disposition (retire, retain). Successors have stable
slug keys and exactly one of project or pendingIdentity. Responsibilities have key, title, from,
disposition (move, discontinue, retain), and to only for move. From names a predecessor;
to names a successor. A retire predecessor cannot retain a duty. Canonical references always
use the actual owning project, including context, flow, use-case and capability links.

Each requirement has a stable key, predecessor, kind, statement, owner {role, party}, and
minimumBasis (declared, source-observed, runtime-observed). Kinds are consumer-migration, responsibility-transfer,
routing-cutover, in-flight-drain, data-obligation, event-obligation, rollback,
operational-continuity, ownership and other. Environments default to all transition
environments; requiresAcceptance defaults false. Itemized defaults true for responsibility-
transfer, consumer-migration and event-obligation, false otherwise. Responsibility-transfer
must be itemized and cannot select a single responsibility. maxAge uses fixed whole days,
hours, minutes and seconds (for example P1DT2H); calendar months and years are unsupported.

The profile checks expressible field shapes, vocabularies, unique keys and move destinations.
Mori additionally checks slugs, nested requirement owners, successor identity exclusivity,
conditional exclusions, joins, predecessor scoping, environment subsets, duration grammar,
coordinator ownership and typed registry resolution. The bounded profile engine cannot express
these semantics. Run both validators. Missing requirements never imply ready.

Observations are immutable facts imported through Mori, outside the OKF declaration bundle.
Source inspection cannot demonstrate runtime cutover. Owner acceptance names existing immutable
observation keys and cannot replace runtime evidence. An adoption pass authors intent only.

Use the supplied standalone profile snapshot until a verified catalog release is available.
After release, pin the coordination.transitions export to its release tag and semantic hash;
never leave a moving master import in a reproducible consumer descriptor.
