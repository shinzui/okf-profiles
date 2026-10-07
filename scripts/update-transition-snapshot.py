#!/usr/bin/env python3
"""Regenerate the standalone adoption snapshot with repeated schema types factored."""
import re
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SOURCE = "profiles/coordination/transitions.dhall"
TARGET = ROOT / "blueprints/adopt-transitions/files/transitions-profile.dhall"


def dhall(*args, source=None):
    return subprocess.check_output(["dhall", *args], input=source, text=True, cwd=ROOT)


def type_pattern(expression):
    # Schema types contain no string literals. Match their tokens across layout.
    return re.compile(r"\s*".join(re.escape(token) for token in expression.split()))


body = dhall("--file", SOURCE)
declarations = []
for name in ("Cardinality", "FieldFormat", "PathReferenceRule", "HandleReferenceRule",
             "FieldCondition", "NestedFieldRule", "NestedRules", "FieldRule"):
    expression = dhall(source=f"let schema = ./Profile/okf.dhall in schema.{name}").strip()
    for prior, old in declarations:
        expression = type_pattern(old).sub(prior, expression)
    body = type_pattern(expression).sub(name, body)
    declarations.append((name, expression))

snapshot = "\n\n".join(f"let {name} = {expression}" for name, expression in declarations)
snapshot += "\n\nin " + body
snapshot = dhall("format", source=snapshot)
source_hash = dhall("hash", "--file", SOURCE)
snapshot_hash = dhall("hash", source=snapshot)
if source_hash != snapshot_hash:
    raise SystemExit("Factoring changed the snapshot's semantic hash; no file written")
TARGET.write_text(snapshot)
print(f"Updated {TARGET.relative_to(ROOT)}: {source_hash.strip()}")
