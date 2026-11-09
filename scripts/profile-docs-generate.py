#!/usr/bin/env python3
"""Stage all OKF output and its selection before replacing the owned tree."""
import argparse
import importlib.util
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

spec = importlib.util.spec_from_file_location("publication", Path(__file__).with_name("profile-docs-publication.py"))
pub = importlib.util.module_from_spec(spec)
spec.loader.exec_module(pub)


def same_tree(left, right):
    if left.is_symlink() or not left.is_dir():
        return False
    def entries(root):
        return {p.relative_to(root).as_posix(): p for p in root.rglob("*")}
    a, b = entries(left), entries(right)
    return a.keys() == b.keys() and all(
        not a[k].is_symlink() and
        ((a[k].is_dir() and b[k].is_dir()) or
         (a[k].is_file() and b[k].is_file() and a[k].read_bytes() == b[k].read_bytes()))
        for k in a
    )


def generate(root, regenerate=False, okf="okf"):
    rows = pub.catalog(root)
    def run(*args):
        return subprocess.run([okf, *args], cwd=root, check=True, capture_output=True, text=True).stdout
    result = json.loads(run("profile", "list", "--no-local", "--registry", "./package.dhall", "--json"))
    exports = {r["export"] for r in result["profiles"]}
    selected = {r["export"] for r in rows}
    if exports != selected:
        raise ValueError(f"Update scripts/profile-docs-catalog.json: missing exports {sorted(exports-selected)}, unknown exports {sorted(selected-exports)}; then run: just docs")
    owned = root / "docs/profiles"
    if owned.is_symlink():
        raise ValueError("docs/profiles must be a regular directory")
    with tempfile.TemporaryDirectory(prefix=".profile-docs-", dir=root / "docs") as tmp:
        stage = Path(tmp) / "profiles"
        stage.mkdir()
        for row in rows:
            run("profile", "document", "--no-local", "--registry", "./package.dhall", row["export"], "--out", str(stage / row["directory"]), "--write", "--okf-version", "0.2")
            run("validate", str(stage / row["directory"]), "--strict")
        selection = pub.publication(root, stage)
        manifest = root / "publication.json"
        if not regenerate:
            if not same_tree(owned, stage):
                raise ValueError("Generated profile documentation is stale; run: just docs")
            if not manifest.is_file() or manifest.read_bytes() != selection:
                raise ValueError("publication.json is stale; run: just docs")
            print("OK: profile documentation is current and validates")
            print("OK: publication selection is current")
            return
        # Recovery stays outside TemporaryDirectory, even on an interrupted commit.
        backup = root / "docs/.profiles-last-good"
        if backup.exists():
            raise ValueError("Recovery tree docs/.profiles-last-good exists; inspect it and restore/remove it before retrying just docs")
        if owned.exists():
            os.replace(owned, backup)
        try:
            os.replace(stage, owned)
            pub.atomic_write(manifest, selection)
        except BaseException:
            if owned.exists():
                shutil.rmtree(owned)
            if backup.exists():
                os.replace(backup, owned)
            raise
        if backup.exists():
            shutil.rmtree(backup)
        print(f"OK: regenerated {len(rows)} profile documentation bundles in docs/profiles")
        print("OK: regenerated publication.json")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("mode", choices=["check", "regenerate"])
    parser.add_argument("--root", type=Path, default=Path(__file__).resolve().parent.parent)
    args = parser.parse_args()
    generate(args.root.resolve(), args.mode == "regenerate", os.environ.get("OKF_BIN", "okf"))


if __name__ == "__main__":
    try:
        main()
    except subprocess.CalledProcessError as error:
        sys.exit(error.stderr or str(error))
    except (ValueError, OSError, KeyError, TypeError) as error:
        sys.exit(str(error))
