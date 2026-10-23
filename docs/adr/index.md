---
okf_version: "0.2"
---

# Files

- [profile.dhall](profile.dhall)

# Architecture Decision Record

- [The house status key diverges from OKF v0.2](0001-house-status-diverges-from-okf-v0-2.md) - Five profiles keep their own status vocabulary; only the two PostgreSQL profiles adopt OKF's.
- [A profile flips to OKF v0.2 atomically](0002-a-profile-flips-to-okf-v0-2-atomically.md) - okf compile-checks okfVersion against the rules a profile declares, in both directions, so partial adoption is impossible.
- [The superseded timestamp key is demoted to optional, not deleted](0003-timestamp-is-demoted-not-deleted.md) - Keeping the rule in the optional list stops reporting its absence without stopping its format from being checked.
- [The house reviews family and OKF verified coexist](0004-reviews-and-verified-coexist.md) - Neither is a superset of the other, so both are declared and an approving review is mirrored into verified.
- [The OKF v0.2 field families are defined once in Profile/V02.dhall](0005-v0-2-field-families-are-defined-once.md) - One shared module owns the six v0.2 families; a consuming profile may reword a rule but never redefine its constraint.
- [OKF v0.2's Attested Computation concept type is excluded](0006-attested-computation-is-excluded.md) - The type was excluded until a consumer wrote it; assurance.verificationEvidence is its first observed admission.
- [Blueprint versions track the catalog tag](0007-blueprint-versions-track-the-catalog-tag.md) - A blueprint is versioned to the okf-profiles tag it targets, because that tag is the only version a consumer can read off their own repository.
- [Recommended means a well-run corpus actually carries it](0008-recommended-means-a-well-run-corpus-carries-it.md) - A field whose absence is ordinary belongs in optional; recommended is reserved for fields whose absence is a real deficiency.
- [A rejection fixture must fail for exactly one reason](0009-a-rejection-fixture-must-fail-for-exactly-one-reason.md) - A fixture that fails twice tests nothing, and a passing rejection loop is not evidence that any rule is load-bearing.
- [A review is an artifact, not only an annotation](0010-a-review-is-an-artifact-not-only-an-annotation.md) - Review records get their own assurance family and do not splice the house reviews frontmatter key, because the document is the review.
- [User documentation shares reader-intent types and DOC handles](0011-user-documentation-shares-reader-intent-types-and-doc-handles.md) - One fleet-wide profile classifies user-facing pages by reader intent while preserving identity with bundle-scoped DOC-N handles.
- [Guidance is an evidence-backed exception](0012-guidance-is-an-evidence-backed-exception.md) - Profile and type guidance stays absent by default and is added only as a minimal, narrowly scoped correction for a demonstrated authoring failure.
- [A specification is not a decision, research, or a reference page](0013-a-specification-is-not-a-decision-or-a-reference.md) - Normative specifications get their own profile and SPEC-N handles, distinguished from three documentation siblings by a ratified version and an explicit normative scope.
- [A term defines a word, and its inverse relations are derived](0014-a-term-defines-a-word-and-derives-its-inverse-relations.md) - Project vocabulary gets its own terminology profile with TERM-N handles; narrower is never authored, sameAs is external only, and corpus-wide checks belong to a consumer gate.
- [A verification run is an immutable event that links to its data](0015-a-verification-run-is-an-immutable-event-that-links-to-its-data.md) - Verification runs and attestations are path-addressed events, while VC-N definitions describe computations and data stays outside the OKF bundle.
- [Runbooks declare operational scope without certifying execution](0016-runbooks-declare-operational-scope-without-certifying-execution.md) - Dedicated runbook metadata makes procedures discoverable while execution correctness remains grounded in review and exercise evidence.
- [Product discovery separates jobs, research, features, and scenarios](0017-product-discovery-separates-jobs-research-features-and-scenarios.md) - Customer jobs, product research, and features get their own profiles with stable handles linked by external-only references, existing profiles keep their schemas, and cross-bundle checks live in an interim opt-in gate whose rules are owned by okf or Mori.
- [Guidance carries what rules and descriptions cannot, and stays rare](0018-guidance-carries-what-rules-and-descriptions-cannot.md) - Profile and type guidance is allowed for lifecycle meaning, checks the descriptor cannot express, and where prose belongs, and for nothing else; absence stays the default and every sentence must change what an author does.
- [Design work is three documents per surface, and implementation stays on features](0019-design-work-is-three-documents-per-surface.md) - A surface's design is a brief, a breadboard and a detailed design sharing one handle field and one decision space; jobs and features are referenced, implementation is tracked on features, and a house closes the viewer-axis names through a builder.
- [A friction entry records cost before it is a defect or a request](0020-a-friction-entry-records-cost-before-it-is-a-defect-or-a-request.md) - The cost of doing work gets its own coordination profile with FRIC-N handles, an impact graded by what happened to the work, a mori origin and an any-URI affects, optional rather than recommended review provenance, and a triage status that names the bug report or request that took over.
- [Campaigns are coordinated work, claim checks are assurance, readouts are research](0021-campaigns-are-coordinated-work-claim-checks-are-assurance-readouts-are-research.md) - Campaigns and audiences join coordination, checked wording joins assurance, and experiment results reuse product research with an opt-in interim gate.

