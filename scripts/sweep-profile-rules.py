#!/usr/bin/env python3
"""ADR-9 load-bearing sweep: `okf profile sweep`, or the legacy engine.

By default this delegates to `okf profile sweep` (okf >= 0.12.0.0), which decodes
the profile once, relaxes it in memory, classifies every relaxation (protected,
inert, covered, subsumed, exception or failing), reads the suite's
`sweep-exceptions.json`, streams one line per relaxation and exits 0 only when
nothing fails. The okf engine's output and exit code are okf's own; this script
only translates the positional usage. If the okf on `OKF_BIN` (default `okf`)
lacks the command, it exits 2 rather than falling back.

`--engine legacy` runs the original algorithm, described below, which is kept
as the reference the okf engine was proven against.

For every field rule (top-level or nested) in the normalized Dhall, apply one
relaxation at a time — delete the rule, empty its allowedValues, drop its
format, loosen its reference policy, drop its uniqueBy — and check whether the
profile's fixtures notice: the acceptance bundle must still pass strictly, and
some rejection fixture must stop reporting exactly its expected deviation.

usage (from the repository root):

    python3 scripts/sweep-profile-rules.py <profile.dhall> <accept-bundle> \
        <invalid-dir-with-expected.json> [extra-accept-bundle ...] \
        [--engine okf|legacy] [--kinds legacy|default|all] [--json PATH] \
        [--quiet] [--only FIELD]

The profile is normalized with `dhall --file`, so the mutated copy has no
relative imports to keep resolvable. `OKF_BIN` selects the okf executable, as
in `profile_fixture_cases.py`. The baseline (every acceptance bundle strict,
every rejection case meeting its expectation) must hold, or the run stops with
exit status 2 before any relaxation.

Each relaxation prints one line as soon as it is decided, with its position,
okf run count and elapsed time. `OK` means a rejection fixture noticed it (its
witness). `!!` marks every other class: UNPROTECTED (no fixture noticed),
ACCEPTANCE-FAILS (an acceptance bundle fails, for example because deleting a
rule of a closed profile made its field unknown), DESCRIPTOR-INVALID (okf can
no longer load the relaxed descriptor) and MUTATION-ILL-TYPED (`dhall type`
rejects the mutated text). Only a witness shows that a fixture tests the rule.
Expected unprotected classes are unconstrained optional fields (deleting one is
unobservable when unknown fields are allowed), members of spliced shared
families whose own profiles test them member by member, and
`allowSelf`/`allowLocal` on external-only references, which only change
behavior together with `localPrefix` (ADR-9's composite policy unit). Anything
else needs a fixture. `--json PATH` writes a machine-readable summary at the
end. Slow by design: one okf run per fixture per relaxation, stopping at the
first fixture that notices; the legacy engine always exits 0 after a complete
sweep, since it is a report, not a gate.
"""
import argparse
import bisect
import json
import os
import shutil
import subprocess
import sys
import tempfile
import time
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from profile_fixture_cases import deviations  # noqa: E402

OKF_RELEASE = "0.12.0.0"
LOAD_FAILURE = "Failed to load profile"
LEGACY_OUTCOME = {"acceptance-fails": "acceptance-fails", "descriptor-invalid": "acceptance-fails",
                  "mutation-ill-typed": "MUTATION-ILL-TYPED", "unprotected": "UNPROTECTED"}


def skip_string(s, i):
    assert s[i] == '"'
    i += 1
    while s[i] != '"':
        i += 2 if s[i] == "\\" else 1
    return i + 1


def match_forward(s, i, open_, close):
    depth = 0
    while True:
        c = s[i]
        if c == '"':
            i = skip_string(s, i)
            continue
        if c == open_:
            depth += 1
        elif c == close:
            depth -= 1
            if depth == 0:
                return i + 1
        i += 1


def string_spans(s):
    spans, i = [], 0
    while i < len(s):
        if s[i] == '"':
            j = skip_string(s, i)
            spans.append((i, j))
            i = j
        else:
            i += 1
    return spans


class Normalized:
    """The normalized descriptor text and the spans of its string literals."""

    def __init__(self, text):
        self.text = text
        self.spans = string_spans(text)
        self.starts = [a for a, _ in self.spans]

    def in_string(self, pos):
        k = bisect.bisect_right(self.starts, pos) - 1
        return k >= 0 and pos < self.spans[k][1]

    def enclosing_brace(self, pos):
        s, depth, i = self.text, 0, pos
        while i > 0:
            i -= 1
            if self.in_string(i):
                continue
            if s[i] == "}":
                depth += 1
            elif s[i] == "{":
                if depth == 0:
                    return i
                depth -= 1
        raise ValueError


def rules(n):
    norm, out, i = n.text, [], 0
    while True:
        i = norm.find('field = "', i)
        if i < 0:
            return out
        if n.in_string(i):
            i += 1
            continue
        start = n.enclosing_brace(i)
        end = match_forward(norm, start, "{", "}")
        name = norm[i + 9:norm.index('"', i + 9)]
        # Skip FieldCondition records ({ field = ..., hasValue = ... }).
        if "hasValue" not in norm[start:end] or "allowedValues" in norm[start:end]:
            out.append((name, start, end))
        # Resume inside the record: normalized Dhall sorts `objectFields` after
        # `field`, so jumping to `end` would skip the rules nested there.
        i += len('field = "')


def top_level_attr(record, attr):
    """Span of `attr = value` at the record's top level, or None.

    Returns (key start, value start, value end). `dhall` puts a long value on
    the line after `attr =`, so any whitespace may separate `=` from the value.
    """
    depth, i = 0, 0
    key = attr + " ="
    while i < len(record):
        c = record[i]
        if c == '"':
            i = skip_string(record, i)
            continue
        if c in "{[(<":
            depth += 1
        elif c in "}])>":
            depth -= 1
        elif depth == 1 and record.startswith(key, i) and record[i + len(key):i + len(key) + 1] in (" ", "\n") \
                and (record[i - 2:i] in (", ", "{ ") or record[i - 1] in "\n "):
            j = i + len(key)
            while record[j] in " \n":
                j += 1
            value = j
            # value runs until the next top-level ", " or closing brace
            d = 0
            while j < len(record):
                ch = record[j]
                if ch == '"':
                    j = skip_string(record, j)
                    continue
                if ch in "{[(<":
                    d += 1
                elif ch in "}])>":
                    if d == 0:
                        break
                    d -= 1
                elif ch == "," and d == 0:
                    break
                j += 1
            return i, value, j
        i += 1
    return None


def relaxations(norm, start, end):
    record = norm[start:end]
    out = []
    # delete from list
    before = norm[:start].rstrip()
    after = norm[end:].lstrip()
    if before.endswith(","):
        cut = len(before) - 1
        out.append(("delete", norm[:cut] + norm[end:]))
    elif before.endswith("[") and after.startswith(","):
        k = end + (len(norm[end:]) - len(after)) + 1
        out.append(("delete", norm[:start] + norm[k:]))
    span = top_level_attr(record, "allowedValues")
    if span and not record[span[1]:span[2]].startswith("[] :"):
        out.append(("allowedValues", norm[:start] + record[:span[1]] + "[] : List Text" + record[span[2]:] + norm[end:]))
    span = top_level_attr(record, "format")
    if span and record[span[1]:].startswith("Some"):
        value = record[span[1]:span[2]]
        lt = value.index("<")
        gt = match_forward(value, lt, "<", ">")
        out.append(("format", norm[:start] + record[:span[1]] + "None " + value[lt:gt] + record[span[2]:] + norm[end:]))
    span = top_level_attr(record, "uniqueBy")
    if span and record[span[1]:].startswith("Some"):
        out.append(("uniqueBy", norm[:start] + record[:span[1]] + "None Text" + record[span[2]:] + norm[end:]))
    span = top_level_attr(record, "reference")
    if span and record[span[1]:].startswith("Some"):
        ref = record[span[1]:span[2]]
        for label, old, new in (("allowSelf", "allowSelf = False", "allowSelf = True"),
                                ("allowLocal", "allowLocal = False", "allowLocal = True")):
            if old in ref:
                out.append((label, norm[:start] + record[:span[1]] + ref.replace(old, new) + record[span[2]:] + norm[end:]))
        k = ref.find("externalUriPattern = Some ")
        if k >= 0:
            q = ref.index('"', k)
            e = skip_string(ref, q)
            out.append(("externalUriPattern", norm[:start] + record[:span[1]] + ref[:k] + "externalUriPattern = None Text" + ref[e:] + record[span[2]:] + norm[end:]))
    return out


def plan(norm, only=None):
    """Every (field, kind, mutated text) the sweep will try, in sweep order."""
    n = Normalized(norm)
    return [(name, kind, text) for name, start, end in rules(n) if only in (None, name)
            for kind, text in relaxations(norm, start, end)]


def resolve(env, default, how):
    """Absolute path and version line of a tool, or exit 2 saying what was tried."""
    name = os.environ.get(env, default) if env else default
    path = shutil.which(name)
    tried = f"{name!r}" + (f" (from {env})" if env and env in os.environ else "")
    if path is None:
        sys.exit(_fault(f"cannot find {tried}; {how}"))
    r = subprocess.run([path, "--version"], text=True, capture_output=True)
    if r.returncode != 0:
        sys.exit(_fault(f"{path} --version exited {r.returncode}; {how}\n{r.stdout}{r.stderr}"))
    return path, (r.stdout + r.stderr).strip().splitlines()[0]


def _fault(message):
    print(message, file=sys.stderr, flush=True)
    return 2


def output(run):
    text = (run.stdout + run.stderr).rstrip("\n")
    return text + "\n" if text else ""


def duration(seconds):
    if seconds < 60:
        return f"{seconds:.1f} s"
    s = round(seconds)
    if s < 3600:
        return f"{s // 60}m {s % 60:02d}s"
    return f"{s // 3600}h {s % 3600 // 60:02d}m {s % 60:02d}s"


class Sweep:
    def __init__(self, okf, accept, invalid):
        self.okf, self.accept, self.invalid = okf, accept, invalid
        self.cases = json.loads(Path(invalid, "expected.json").read_text())
        self.runs = 0

    def validate(self, *args):
        self.runs += 1
        return subprocess.run([self.okf, "validate", *args], text=True, capture_output=True)

    def accepts(self, bundle, profile):
        return self.validate(bundle, "--strict", "--profile", profile, "--profile-enforce", "--log-enforce")

    def case(self, name, spec, profile):
        """The okf run for one rejection case and whether it met its expectation."""
        field = spec if isinstance(spec, str) else spec["field"]
        count = 1 if isinstance(spec, str) else spec["diagnostics"]
        r = self.validate(str(Path(self.invalid, name)), "--profile", profile)
        found = deviations(r.stdout + r.stderr)
        return r, len(found) == count and any(field in line for line in found)

    def baseline(self, profile):
        """Exit 2 on the first acceptance bundle or case that fails unrelaxed."""
        for bundle in self.accept:
            r = self.accepts(bundle, profile)
            if r.returncode != 0:
                sys.exit(_fault(f"{bundle} must validate strictly:\n{output(r)}"
                                "baseline fault: fix the fixtures before sweeping"))
        for name, spec in self.cases.items():
            r, met = self.case(name, spec, profile)
            if not met:
                sys.exit(_fault(f"{Path(self.invalid, name)} does not report exactly its expected deviation "
                                f"{spec!r}:\n{output(r)}baseline fault: fix the fixtures before sweeping"))

    def noticed(self, profile, field):
        """(class, witness) for one relaxed descriptor."""
        for bundle in self.accept:
            r = self.accepts(bundle, profile)
            if r.returncode != 0:
                return ("descriptor-invalid" if LOAD_FAILURE in r.stdout + r.stderr else "acceptance-fails"), None
        ordered = sorted(self.cases.items(), key=lambda kv: (kv[1] if isinstance(kv[1], str) else kv[1]["field"]) != field)
        for name, spec in ordered:
            if not self.case(name, spec, profile)[1]:
                return "witness", name
        return "unprotected", None


def delegate(args):
    """Replace this process with `okf profile sweep`, which streams and exits on its own."""
    if args.quiet:
        sys.exit(_fault("--quiet applies to --engine legacy only"))
    okf, okf_version = resolve("OKF_BIN", "okf", "set OKF_BIN to an okf executable")
    if subprocess.run([okf, "profile", "sweep", "--help"], capture_output=True).returncode != 0:
        sys.exit(_fault(f"{okf_version} has no 'profile sweep'; install okf >= {OKF_RELEASE} "
                        "or pass --engine legacy"))
    argv = [okf, "profile", "sweep", args.profile, "--cases", args.invalid]
    for bundle in [args.accept, *args.extra]:
        argv += ["--accept", bundle]
    if args.kinds:
        argv += ["--kinds", args.kinds]
    if args.only:
        argv += ["--only", args.only]
    if args.json:
        # okf writes NDJSON to stdout; send it to PATH as the legacy engine does its summary.
        argv.append("--json")
        fd = os.open(args.json, os.O_WRONLY | os.O_CREAT | os.O_TRUNC, 0o644)
        os.dup2(fd, sys.stdout.fileno())
        os.close(fd)
    sys.stdout.flush()
    os.execv(okf, argv)


def main():
    parser = argparse.ArgumentParser(description="ADR-9 load-bearing sweep.")
    parser.add_argument("profile", help="profile descriptor (.dhall)")
    parser.add_argument("accept", help="acceptance bundle that must validate strictly")
    parser.add_argument("invalid", help="rejection cases directory with expected.json")
    parser.add_argument("extra", nargs="*", help="further acceptance bundles")
    parser.add_argument("--engine", choices=("okf", "legacy"), default="okf",
                        help="okf: delegate to `okf profile sweep` (default); legacy: this script's own sweep")
    parser.add_argument("--kinds", choices=("legacy", "default", "all"),
                        help="relaxation kinds for --engine okf; --engine legacy only has the legacy kinds")
    parser.add_argument("--json", metavar="PATH",
                        help="write the machine-readable result to PATH (okf: NDJSON; legacy: a JSON summary)")
    parser.add_argument("--quiet", action="store_true", help="legacy: print only the header and summary lines")
    parser.add_argument("--only", metavar="FIELD", help="sweep only rules with this field name")
    args = parser.parse_args()
    if args.engine == "okf":
        delegate(args)
    if args.kinds not in (None, "legacy"):
        parser.error("--engine legacy only has --kinds legacy")

    began = time.monotonic()
    commit = subprocess.run(["git", "rev-parse", "HEAD"], text=True, capture_output=True).stdout.strip()
    okf, okf_version = resolve("OKF_BIN", "okf", "set OKF_BIN to an okf executable")
    dhall, _ = resolve(None, "dhall", "install dhall >= 1.42 on PATH")
    print(f"okf: {okf_version}", flush=True)

    norm = subprocess.run([dhall, "--file", args.profile], text=True, capture_output=True, check=True).stdout
    todo = plan(norm, args.only)
    sweep = Sweep(okf, [args.accept, *args.extra], args.invalid)

    results = []
    with tempfile.TemporaryDirectory() as d:
        tmp = Path(d, "p.dhall")
        tmp.write_text(norm)
        sweep.baseline(str(tmp))
        bundles = len(sweep.accept)
        print(f"baseline: {bundles} acceptance bundle{'s' if bundles != 1 else ''}, {len(sweep.cases)} rejection "
              f"cases OK ({sweep.runs} okf runs, {duration(time.monotonic() - began)})", flush=True)
        print(f"sweep: {len(todo)} relaxations", flush=True)
        width = len(str(len(todo)))
        for index, (name, kind, text) in enumerate(todo, 1):
            started, runs = time.monotonic(), sweep.runs
            tmp.write_text(text)
            check = subprocess.run([dhall, "type", "--file", str(tmp)], capture_output=True)
            if check.returncode != 0:
                cls, witness = "mutation-ill-typed", None
            else:
                cls, witness = sweep.noticed(str(tmp), name)
            legacy = f"fixture {witness}" if cls == "witness" else LEGACY_OUTCOME[cls]
            result = {"index": index, "field": name, "kind": kind, "legacyOutcome": legacy, "class": cls,
                      "witness": witness, "okfRuns": sweep.runs - runs,
                      "elapsedMs": round((time.monotonic() - started) * 1000)}
            results.append(result)
            if not args.quiet:
                shown = legacy if cls == "witness" else cls.upper()
                print(f"[{index:>{width}}/{len(todo)}] {'OK ' if cls == 'witness' else '!! '}{name:24} {kind:20} "
                      f"{shown}  ({result['okfRuns']} okf runs, {duration(result['elapsedMs'] / 1000)})", flush=True)

    elapsed = time.monotonic() - began
    counts = {cls: sum(1 for r in results if r["class"] == cls)
              for cls in ("witness", "acceptance-fails", "descriptor-invalid", "unprotected", "mutation-ill-typed")}
    ill_typed = f", {counts['mutation-ill-typed']} mutation-ill-typed" if counts["mutation-ill-typed"] else ""
    print(f"sweep: {len(results)} relaxations: {counts['witness']} witnessed, {counts['acceptance-fails']} "
          f"acceptance-fails, {counts['descriptor-invalid']} descriptor-invalid, {counts['unprotected']} "
          f"unprotected{ill_typed}; {sweep.runs} okf runs in {duration(elapsed)}", flush=True)

    if args.json:
        summary = {"engine": "legacy", "okf": okf_version, "profile": args.profile, "accept": sweep.accept,
                   "cases": args.invalid, "only": args.only, "gitCommit": commit or None,
                   "elapsedMs": round(elapsed * 1000), "okfRuns": sweep.runs, "counts": counts, "results": results}
        Path(args.json).write_text(json.dumps(summary, indent=2) + "\n")


if __name__ == "__main__":
    main()
