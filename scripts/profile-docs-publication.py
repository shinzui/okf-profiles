#!/usr/bin/env python3
"""Deterministic, explicit publication selection. Uses only Python's standard library."""
import argparse
import json
import os
from pathlib import Path
import re
import sys
import tempfile

PROJECT = "mori://shinzui/okf-profiles"
# The curated release history is the one hand-written page in the selection (ADR-25).
CHANGELOG = "CHANGELOG.md"


def catalog(root):
    rows = json.loads((root / "scripts/profile-docs-catalog.json").read_text())
    if not isinstance(rows, list) or not rows:
        raise ValueError("Profile catalog must be a nonempty list")
    for row in rows:
        if set(row) != {"export", "directory"} or not re.fullmatch(r"[a-zA-Z][a-zA-Z0-9.]*", row["export"]) or not re.fullmatch(r"[a-z][a-z0-9-]*", row["directory"]):
            raise ValueError(f"Invalid profile inventory entry: {row}")
    for key in ("export", "directory"):
        if len({r[key] for r in rows}) != len(rows):
            raise ValueError(f"Duplicate catalog {key}")
    return sorted(rows, key=lambda r: r["export"])


def publication(root, generated=None):
    rows = catalog(root)
    if (root / "docs").is_symlink():
        raise ValueError("docs must be a regular directory")
    tree = generated if generated is not None else root / "docs/profiles"
    if tree.is_symlink() or not tree.is_dir():
        raise ValueError(f"Expected regular generated directory: {tree}")
    expected = {r["directory"] for r in rows}
    if {p.name for p in tree.iterdir()} != expected:
        raise ValueError("Generated profile directories differ from the inventory; run: just docs")
    changelog = root / CHANGELOG
    if changelog.is_symlink() or not changelog.is_file():
        raise ValueError(f"Expected regular file: {CHANGELOG}")
    documents = [CHANGELOG]
    for row in rows:
        directory = tree / row["directory"]
        if directory.is_symlink() or not directory.is_dir():
            raise ValueError(f"Invalid generated bundle: {directory}")
        for p in sorted(directory.rglob("*")):
            if p.is_symlink():
                raise ValueError(f"Symlinks cannot be published: {p}")
            if p.is_dir():
                if p.relative_to(directory).as_posix() != "types":
                    raise ValueError(f"Unexpected generated directory: {p}")
                continue
            relative = p.relative_to(directory)
            # The generator owns these two root pages and a flat type bundle.
            if not p.is_file() or not (str(relative) in ("index.md", "profile.md") or (len(relative.parts) == 2 and relative.parts[0] == "types" and re.fullmatch(r"[a-z0-9-]+\.md", relative.name))):
                raise ValueError(f"Unexpected generated document: {p}")
            if not p.read_text().strip():
                raise ValueError(f"Empty generated document: {p}")
            documents.append(f"docs/profiles/{row['directory']}/{relative.as_posix()}")
        for required in ("index.md", "profile.md"):
            if not (directory / required).is_file():
                raise ValueError(f"Missing generated document: {directory / required}")
    return (json.dumps({"schemaVersion": 1, "projectUri": PROJECT,
                       "documents": sorted(documents),
                       "bundles": [{"name": r["directory"], "directory": "docs/profiles/" + r["directory"], "export": r["export"]} for r in sorted(rows, key=lambda r: r["directory"])],
                       "assets": []}, indent=2) + "\n").encode()


def atomic_write(target, data):
    descriptor, name = tempfile.mkstemp(prefix="." + target.name + "-", dir=target.parent)
    try:
        with os.fdopen(descriptor, "wb") as output:
            output.write(data)
        os.replace(name, target)
    finally:
        Path(name).unlink(missing_ok=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    parser.add_argument("--root", type=Path, default=Path(__file__).resolve().parent.parent)
    args = parser.parse_args()
    data = publication(args.root)
    target = args.root / "publication.json"
    if args.write:
        atomic_write(target, data)
        print("OK: regenerated publication.json")
    elif not target.is_file() or target.read_bytes() != data:
        raise ValueError("publication.json is stale; run: just docs")
    else:
        print("OK: publication selection is current")


if __name__ == "__main__":
    try:
        main()
    except (ValueError, OSError, KeyError, TypeError) as error:
        sys.exit(str(error))
