"""Temporary-tree checks for inventory, selection and generation transactions."""
import importlib.util
import json
import os
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

HERE = Path(__file__).resolve().parent


def module(name, file):
    spec = importlib.util.spec_from_file_location(name, HERE / file)
    result = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(result)
    return result


pub = module("publication", "profile-docs-publication.py")
gen = module("generation", "profile-docs-generate.py")


class PublicationTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name)
        (self.root / "scripts").mkdir()
        (self.root / "docs").mkdir()
        self.rows = [{"export": "coordination.features", "directory": "features"}]
        self.save_catalog()
        self.fixture = {"exports": ["coordination.features"], "types": ["feature", "old-type"], "description": "original"}
        self.save_fixture()
        self.okf = self.root / "fake-okf"
        self.okf.write_text('''#!/usr/bin/env python3
import json,sys
from pathlib import Path
args=sys.argv[1:]
f=json.loads(Path("fixture.json").read_text())
if args[:2]==["profile","list"]:
 print(json.dumps({"profiles":[{"export":e} for e in f["exports"]]}))
elif args[:2]==["profile","document"]:
 if f.get("fail"): sys.exit("synthetic generator failure")
 out=Path(args[args.index("--out")+1]);out.mkdir(parents=True)
 (out/"index.md").write_text("# Index\\n")
 (out/"profile.md").write_text("# Profile\\n"+f["description"])
 (out/"types").mkdir()
 for t in f["types"]: (out/"types"/(t+".md")).write_text("# "+t)
 if f.get("invalid"): (out/"unexpected.txt").write_text("not generated Markdown")
elif args[0]=="validate": pass
else: sys.exit("unexpected command")
''')
        self.okf.chmod(0o755)
        self.generate()

    def save_catalog(self):
        (self.root / "scripts/profile-docs-catalog.json").write_text(json.dumps(self.rows))

    def save_fixture(self):
        (self.root / "fixture.json").write_text(json.dumps(self.fixture))

    def generate(self, write=True):
        gen.generate(self.root, write, str(self.okf))

    def state(self):
        return {p.relative_to(self.root).as_posix(): p.read_bytes() for p in (self.root / "docs/profiles").rglob("*.md")} | {"publication.json": (self.root / "publication.json").read_bytes()}

    def test_determinism_and_source_drift(self):
        before = self.state()
        self.generate()
        self.assertEqual(before, self.state())
        self.fixture["description"] = "changed"
        self.save_fixture()
        with self.assertRaisesRegex(ValueError, "stale"):
            self.generate(False)
        self.assertEqual(before, self.state())
        self.generate()
        self.assertIn("changed", (self.root / "docs/profiles/features/profile.md").read_text())
        self.generate(False)

    def test_add_remove_types_and_profiles(self):
        self.fixture["types"] = ["feature", "new-type"]
        self.fixture["exports"].append("documentation.newProfile")
        self.rows.append({"export": "documentation.newProfile", "directory": "new-profile"})
        self.save_catalog()
        self.save_fixture()
        self.generate()
        self.assertFalse((self.root / "docs/profiles/features/types/old-type.md").exists())
        data = json.loads(pub.publication(self.root))
        self.assertIn("docs/profiles/features/types/new-type.md", data["documents"])
        self.assertEqual(len(data["bundles"]), 2)
        self.rows.pop()
        self.fixture["exports"].pop()
        self.save_catalog()
        self.save_fixture()
        self.generate()
        self.assertFalse((self.root / "docs/profiles/new-profile").exists())
        self.assertNotIn("new-profile", (self.root / "publication.json").read_text())

    def test_missing_inventory_export_is_actionable(self):
        before = self.state()
        self.fixture["exports"].append("documentation.unlisted")
        self.save_fixture()
        with self.assertRaisesRegex(ValueError, "missing exports.*documentation.unlisted"):
            self.generate()
        self.assertEqual(before, self.state())

    def test_failed_generation_and_selection_keep_last_good(self):
        before = self.state()
        for key in ("fail", "invalid"):
            self.fixture[key] = True
            self.save_fixture()
            with self.assertRaises(Exception):
                self.generate()
            self.assertEqual(before, self.state())
            self.fixture.pop(key)
        self.save_fixture()
        with patch.object(gen.pub, "atomic_write", side_effect=OSError("failed manifest write")):
            with self.assertRaisesRegex(OSError, "failed manifest"):
                self.generate()
        self.assertEqual(before, self.state())

    def test_boundaries_symlinks_and_selection_drift(self):
        tree = self.root / "docs/profiles/features"
        (tree / "types/secret.md").symlink_to(self.root / "fixture.json")
        with self.assertRaisesRegex(ValueError, "Symlinks"):
            pub.publication(self.root)
        (tree / "types/secret.md").unlink()
        (tree / "types/added.md").write_text("# Added")
        self.assertNotEqual((self.root / "publication.json").read_bytes(), pub.publication(self.root))
        (self.root / "docs/profiles/unapproved").mkdir()
        with self.assertRaisesRegex(ValueError, "directories differ"):
            pub.publication(self.root)
        self.rows[0]["directory"] = "../escape"
        self.save_catalog()
        with self.assertRaisesRegex(ValueError, "Invalid profile"):
            pub.catalog(self.root)


if __name__ == "__main__":
    unittest.main()
