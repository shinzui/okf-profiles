# Operational runbook contract

The authoritative source is `mori://shinzui/okf-profiles/profiles/runbooks`, export
`documentation.runbooks`. The shipped descriptor is a normalized prerelease snapshot.

Each concept has type `Runbook`, one stable `docId: RB-N`, title, description, owner,
a nonempty list of canonical `projects` URIs, nonempty `environments`, a concise
`trigger`, nonempty `effects`, nonempty tags, explicit `status` and truthful `generated`
provenance. Effects are `read-only`, `repository-change`, `registry-change`,
`service-change` or `data-change`; include possible conditional branches. An effect
classification grants no execution authority. Status is draft/stable/deprecated;
stable describes documentation maturity and does not assert that an exercise passed.

Optional fields carry sources, independent `verified` confirmations, `stale_after`,
canonical supporting `related` URIs and checked RB supersession links. Ownership and
environment vocabularies belong to the repository. Preserve previously allocated
identities and use `okf id next <bundle> --profile <descriptor> RB` for new ones.

## Body contract

Name the prerequisites, exact target-selection checks and required operator authority.
Give ordered steps with expected observations and decision branches. Define success,
when to stop, recovery (or explicitly irreversible effects), and the escalation owner
with evidence to preserve. These prose requirements need review: the current profile
schema does not enforce headings or certify command correctness.

A multi-procedure operations document may split into separate runbooks if each procedure
has a distinct trigger and recovery boundary. A deployment manifest or tuning reference
belongs in reader-facing documentation and can be linked from the procedures.

## Migration and validation

Keep original bodies and navigation unless a needed repair is supported by evidence.
Moving a procedure requires repairing relative links and retaining compatibility routes.
Create index.md using `okf index <bundle> --write --okf-version 0.2` and maintain log.md.
Declare an OKF bundle in mori.dhall with its local descriptor and version 0.2; preserve
existing exposed doc keys. Add this failing check to the repository verification entry:

```bash
okf validate docs/runbooks --strict --profile docs/runbooks/profile.dhall --profile-enforce --log-enforce
```

Schema validation is not operational verification. Adoption runs none of the procedure's
commands and must not manufacture `verified` or exercise evidence.
