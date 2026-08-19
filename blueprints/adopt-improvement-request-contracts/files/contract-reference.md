# Improvement-request contract reference for okf-profiles v0.12.0

The v0.12.0 `coordination.improvementRequests` profile adds two optional frontmatter fields.
Existing requests remain valid without them. When either field is present, every record member
shown below is required and validated.

```yaml
dependencies:
  - ref: mori://namespace/project/okf/improvement-requests/concepts/IR-1
    kind: hard
    reason: The target request supplies a contract this request consumes.
acceptanceCriteria:
  - id: AC-1
    statement: The observable condition that must hold.
    verification: The command, inspection, or evidence that will prove it.
```

## Dependency contract

`ref` is external-only. It must be a canonical URI in this exact shape:

```text
mori://<namespace>/<project>/okf/improvement-requests/concepts/IR-<positive-unpadded-integer>
```

A bare `IR-N`, a non-`mori` scheme, the wrong bundle or artifact-kind path, `IR-0`, a padded number
such as `IR-01`, a query, and a fragment are invalid.

`kind` has exactly three meanings:

- `hard`: the target must be fulfilled before the source request can be fulfilled.
- `soft`: the target informs or de-risks the source but never blocks fulfillment by itself.
- `integration`: implementations may proceed independently, but named joint verification is
  required before fulfillment.

`reason` is a non-empty explanation of why the source relationship exists. These records do not
represent live incident blockers, schedules, graph reachability, or transitive readiness.

## Acceptance-criterion contract

`id` is a request-local stable `AC-N` handle. It is unique within one request's
`acceptanceCriteria` list; every request may independently start with `AC-1`.

`statement` is an observable completion condition. `verification` is the expected evidence or
procedure, stated without claiming that the evidence already exists. A criterion is not an
implementation task, a dependency, or the evidence itself.

## Safe promotion rule

Promote prose only when every required member is grounded in repository evidence. Preserve source
prose after promotion. Never guess a Mori URI, dependency kind, dependency reason, acceptance
statement, or verification procedure. Leave ambiguous material unchanged and report it.

## Shared descriptor

A repository using the shared profile may install or repin this descriptor after v0.12.0 is
released:

```dhall
--| Shared cross-repository improvement-request profile.
let Profiles =
      https://raw.githubusercontent.com/shinzui/okf-profiles/v0.12.0/package.dhall

in  Profiles.coordination.improvementRequests
```

Freeze the import using the real tag; never hand-write its semantic hash:

```bash
dhall freeze <bundle>/profile.dhall
```

Preserve any project-specific record overlay around the import. A locally authored profile should
not be replaced automatically.

The profile requires `okf` 0.8.0.0 or later. Validate with the repository's own check, or use:

```bash
dhall type --file <bundle>/profile.dhall
okf validate <bundle> --strict --profile <bundle>/profile.dhall \
  --profile-enforce --log-enforce
```
