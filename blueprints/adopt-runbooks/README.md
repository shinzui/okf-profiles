# adopt-runbooks

Adopt operational procedures under `docs/runbooks`, `docs/operations`, or explicitly
selected paths. Read the [migration contract](files/migration-reference.md).

```bash
seihou agent run adopt-runbooks
seihou validate-blueprint blueprints/adopt-runbooks --lint
```

This blueprint is unreleased. Its shipped descriptor is a self-contained normalized
snapshot of `documentation.runbooks`, not a claim that an existing release exports it.
After publication, consumers may replace the snapshot with a hash-pinned remote import.
Use the installed OKF 0.9 schema/tool generation; no newer dependency is required.

The blueprint preserves valid identities, authored bodies and unrelated edits. It
creates bundle indexes/logs and a native strict enforcement gate. It does not execute
operational commands, invent verification evidence, commit, publish or mutate a shared
registry. Mixed deployment references remain references; independently usable procedures
receive their own identity. Missing ownership is reported for resolution.
