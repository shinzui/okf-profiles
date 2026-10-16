#!/usr/bin/env python3
"""ADR-9 load-bearing sweep over a normalized profile.

For every field rule (top-level or nested) in the normalized Dhall, apply one
relaxation at a time — delete the rule, empty its allowedValues, drop its
format, loosen its reference policy, drop its uniqueBy — and check whether the
profile's fixtures notice: the acceptance bundle must still pass strictly, and
some rejection fixture must stop reporting exactly its expected deviation.

usage (from the repository root):

    python3 scripts/sweep-profile-rules.py <profile.dhall> <accept-bundle> \
        <invalid-dir-with-expected.json> [extra-accept-bundle ...]

The profile is normalized with `dhall --file`, so the mutated copy has no
relative imports to keep resolvable. Each relaxation prints one line naming the
fixture that noticed it, or UNPROTECTED. Expected unprotected classes are
unconstrained optional fields (deleting one is unobservable when unknown fields
are allowed), members of spliced shared families whose own profiles test them
member by member, and `allowSelf`/`allowLocal` on external-only references,
which only change behavior together with `localPrefix` (ADR-9's composite
policy unit). Anything else needs a fixture. Slow by design: one okf run per
fixture per relaxation, stopping at the first fixture that notices. Not part of
`just test`.
"""
import json
import subprocess
import sys
import tempfile
from pathlib import Path

sys.path.insert(0, "scripts")
from profile_fixture_cases import deviations  # noqa: E402

profile_src, accept, invalid, *extra = sys.argv[1:]
norm = subprocess.run(["dhall", "--file", profile_src], text=True, capture_output=True, check=True).stdout
cases = json.loads(Path(invalid, "expected.json").read_text())


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


SPANS = string_spans(norm)


def in_string(pos):
    return any(a <= pos < b for a, b in SPANS)


def enclosing_brace(s, pos):
    depth = 0
    i = pos
    while i > 0:
        i -= 1
        if in_string(i):
            continue
        if s[i] == "}":
            depth += 1
        elif s[i] == "{":
            if depth == 0:
                return i
            depth -= 1
    raise ValueError


def rules():
    out, i = [], 0
    while True:
        i = norm.find('field = "', i)
        if i < 0:
            return out
        if in_string(i):
            i += 1
            continue
        start = enclosing_brace(norm, i)
        end = match_forward(norm, start, "{", "}")
        name = norm[i + 9:norm.index('"', i + 9)]
        # Skip FieldCondition records ({ field = ..., hasValue = ... }).
        if "hasValue" not in norm[start:end] or "allowedValues" in norm[start:end]:
            out.append((name, start, end))
        i = end


def top_level_attr(record, attr):
    """Span of `attr = value` at the record's top level, or None."""
    depth, i = 0, 0
    key = attr + " = "
    while i < len(record):
        c = record[i]
        if c == '"':
            i = skip_string(record, i)
            continue
        if c in "{[(<":
            depth += 1
        elif c in "}])>":
            depth -= 1
        elif depth == 1 and record.startswith(key, i) and record[i - 2:i] in (", ", "{ ") \
                or depth == 1 and record.startswith(key, i) and record[i - 1] in "\n ":
            j = i + len(key)
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
            return i, i + len(key), j
        i += 1
    return None


def relaxations(name, start, end):
    record = norm[start:end]
    out = []
    # delete from list
    before = norm[:start].rstrip()
    after = norm[end:].lstrip()
    if before.endswith(",") :
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


def noticed(profile, field):
    acc = subprocess.run(["okf", "validate", accept, "--strict", "--profile", profile,
                          "--profile-enforce", "--log-enforce"], text=True, capture_output=True)
    if acc.returncode != 0:
        return "acceptance-fails"
    for bundle in extra:
        acc = subprocess.run(["okf", "validate", bundle, "--strict", "--profile", profile,
                              "--profile-enforce", "--log-enforce"], text=True, capture_output=True)
        if acc.returncode != 0:
            return "acceptance-fails"
    ordered = sorted(cases.items(), key=lambda kv: (kv[1] if isinstance(kv[1], str) else kv[1]["field"]) != field)
    for name, spec in ordered:
        f = spec if isinstance(spec, str) else spec["field"]
        count = 1 if isinstance(spec, str) else spec["diagnostics"]
        r = subprocess.run(["okf", "validate", str(Path(invalid, name)), "--profile", profile],
                           text=True, capture_output=True)
        found = deviations(r.stdout + r.stderr)
        if len(found) != count or not any(f in l for l in found):
            return f"fixture {name}"
    return None


results = []
with tempfile.TemporaryDirectory() as d:
    tmp = Path(d, "p.dhall")
    tmp.write_text(norm)
    assert noticed(str(tmp), "") is None, "baseline must pass"
    seen = set()
    for name, start, end in rules():
        for kind, text in relaxations(name, start, end):
            tmp.write_text(text)
            check = subprocess.run(["dhall", "type", "--file", str(tmp)], capture_output=True)
            if check.returncode != 0:
                results.append((name, kind, "MUTATION-ILL-TYPED"))
                continue
            by = noticed(str(tmp), name)
            results.append((name, kind, by or "UNPROTECTED"))
for name, kind, by in results:
    print(f"{'OK ' if not by.startswith(('UNPROTECTED', 'MUTATION')) else '!! '}{name:24} {kind:20} {by}")
print(f"{sum(1 for r in results if r[2] == 'UNPROTECTED')} unprotected of {len(results)} relaxations")
