#!/usr/bin/env python3
"""Check that `okf profile sweep` reproduces a recorded legacy sweep.

usage (from the repository root):

    python3 scripts/compare-sweep-results.py LEGACY.json OKF.ndjson

LEGACY.json is the summary `scripts/sweep-profile-rules.py --json` writes;
OKF.ndjson is the stream of `okf profile sweep --kinds legacy --json` over the
same profile, acceptance bundles and cases. Both sides are reduced to the
multiset of `(field, kind, legacyOutcome)`, where `legacyOutcome` is
`fixture <witness>`, `acceptance-fails`, `MUTATION-ILL-TYPED` or `UNPROTECTED`.
Every legacy result must be matched. An okf-only result is allowed only when it
deletes a rule that is the sole element of its list, which the legacy text
surgery cannot do. Exit 0 on parity, 1 otherwise.
"""
import collections
import json
import subprocess
import sys
from pathlib import Path


def sole_element_deletes(events):
    """IDs of okf `delete` relaxations whose rule is the only one in its list."""
    locations = {e["id"].rsplit("#", 1)[0] for e in events}
    per_list = collections.Counter(loc.rsplit("/", 1)[0] for loc in locations)
    return {e["id"] for e in events
            if e["kind"] == "delete" and per_list[e["id"].rsplit("#", 1)[0].rsplit("/", 1)[0]] == 1}


def main():
    if len(sys.argv) != 3:
        sys.exit("usage: compare-sweep-results.py LEGACY.json OKF.ndjson")
    legacy = json.loads(Path(sys.argv[1]).read_text())
    events = [json.loads(line) for line in Path(sys.argv[2]).read_text().splitlines() if line.strip()]
    failed = False

    head = subprocess.run(["git", "rev-parse", "HEAD"], text=True, capture_output=True).stdout.strip()
    if legacy.get("gitCommit") != head:
        print(f"warning: legacy baseline recorded at {legacy.get('gitCommit')}, HEAD is {head}; "
              "compare only if fixtures/ and profiles/ are unchanged since", file=sys.stderr)
    if legacy.get("only"):
        print(f"warning: legacy baseline was filtered with --only {legacy['only']}", file=sys.stderr)
    for event in events:
        if event["event"] == "start" and event.get("kinds") != "legacy":
            print(f"okf stream used --kinds {event.get('kinds')}; parity needs --kinds legacy")
            failed = True
        if event["event"] == "baseline" and not event.get("ok"):
            print(f"okf baseline fault: {event.get('fault')}: {event.get('detail')}")
            failed = True
    if not any(e["event"] == "summary" for e in events):
        print("okf stream has no summary event; was it interrupted?")
        failed = True

    relaxations = [e for e in events if e["event"] == "relaxation"]
    key = lambda r: (r["field"], r["kind"], r["legacyOutcome"])  # noqa: E731
    want = collections.Counter(key(r) for r in legacy["results"])
    have = collections.Counter(key(e) for e in relaxations)
    missing, extra = want - have, have - want

    sole = sole_element_deletes(relaxations)
    explained = collections.Counter(key(e) for e in relaxations if e["id"] in sole)
    unexplained = extra - explained
    for field, kind, outcome in sorted(missing.elements()):
        print(f"legacy only: {field:24} {kind:20} {outcome}")
    for field, kind, outcome in sorted(unexplained.elements()):
        ids = sorted(e["id"] for e in relaxations if key(e) == (field, kind, outcome))
        print(f"okf only:    {field:24} {kind:20} {outcome}  ({', '.join(ids)})")
    allowed = extra - unexplained
    for field, kind, outcome in sorted(allowed.elements()):
        print(f"okf only:    {field:24} {kind:20} {outcome}  (legacy cannot delete a sole list element)")

    total = sum(want.values())
    matched = total - sum(missing.values())
    print(f"parity: {matched}/{total} legacy results matched; {sum(allowed.values())} okf-only results "
          f"(legacy cannot delete a sole list element)"
          + (f"; {sum(unexplained.values())} unexplained okf-only results" if unexplained else ""))
    if failed or missing or unexplained:
        sys.exit(1)


if __name__ == "__main__":
    main()
