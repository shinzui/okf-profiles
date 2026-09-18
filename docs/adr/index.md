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
- [OKF v0.2's Attested Computation concept type is excluded](0006-attested-computation-is-excluded.md) - No profile in this catalog documents computations, so any convention written now would be invented rather than observed.
- [Blueprint versions track the catalog tag](0007-blueprint-versions-track-the-catalog-tag.md) - A blueprint is versioned to the okf-profiles tag it targets, because that tag is the only version a consumer can read off their own repository.
- [Recommended means a well-run corpus actually carries it](0008-recommended-means-a-well-run-corpus-carries-it.md) - A field whose absence is ordinary belongs in optional; recommended is reserved for fields whose absence is a real deficiency.
- [A rejection fixture must fail for exactly one reason](0009-a-rejection-fixture-must-fail-for-exactly-one-reason.md) - A fixture that fails twice tests nothing, and a passing rejection loop is not evidence that any rule is load-bearing.
- [A review is an artifact, not only an annotation](0010-a-review-is-an-artifact-not-only-an-annotation.md) - Review records get their own assurance family and do not splice the house reviews frontmatter key, because the document is the review.
- [User documentation shares reader-intent types and DOC handles](0011-user-documentation-shares-reader-intent-types-and-doc-handles.md) - One fleet-wide profile classifies user-facing pages by reader intent while preserving identity with bundle-scoped DOC-N handles.
- [Guidance is an evidence-backed exception](0012-guidance-is-an-evidence-backed-exception.md) - Profile and type guidance stays absent by default and is added only as a minimal, narrowly scoped correction for a demonstrated authoring failure.
- [A specification is not a decision, research, or a reference page](0013-a-specification-is-not-a-decision-or-a-reference.md) - Normative specifications get their own profile and SPEC-N handles, distinguished from three documentation siblings by a ratified version and an explicit normative scope.
- [A term defines a word, and its inverse relations are derived](0014-a-term-defines-a-word-and-derives-its-inverse-relations.md) - Project vocabulary gets its own terminology profile with TERM-N handles; narrower is never authored, sameAs is external only, and corpus-wide checks belong to a consumer gate.
