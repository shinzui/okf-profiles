#!/usr/bin/env bash
# ADR-9 load-bearing sweep over every profile whose test uses the shared
# `profile_fixture_cases.run` harness. The (profile, acceptance bundle, cases)
# triples are read from those tests, so a new profile test joins the sweep
# without editing this script. Extra arguments (`--kinds all`, `--json`) are
# passed to `okf profile sweep`; `OKF_BIN` selects the okf executable.
#
# One line per profile, then the total time. Continues past a failing profile
# so every result is reported, and exits non-zero if any sweep did.
set -uo pipefail

okf_bin="${OKF_BIN:-okf}"
log_dir="$(mktemp -d)"
trap 'rm -rf "$log_dir"' EXIT

triples="$(python3 - <<'EOF'
import ast
from pathlib import Path

for test in sorted(Path("scripts").glob("test-*-profile.py")):
    for node in ast.walk(ast.parse(test.read_text())):
        if isinstance(node, ast.Call) and getattr(node.func, "id", None) == "run" \
                and len(node.args) == 4 and all(isinstance(a, ast.Constant) for a in node.args):
            print("\t".join(a.value for a in node.args))
EOF
)" || exit 2

started=$SECONDS
failed=0
while IFS=$'\t' read -r label profile accept cases; do
  begun=$SECONDS
  log="$log_dir/${label// /-}.out"
  if "$okf_bin" profile sweep "$profile" --accept "$accept" --cases "$cases" "$@" >"$log" 2>&1; then
    status=ok
  else
    status="FAIL (exit $?)"
    failed=1
  fi
  summary="$(grep -E '^sweep: [0-9]+ relaxations:|"event":"summary"' "$log" | tail -n 1)"
  printf '%-18s %-14s %3ss  %s\n' "$label" "$status" "$((SECONDS - begun))" "${summary:-$(tail -n 1 "$log")}"
  if [[ $status != ok ]]; then
    grep -E '^\[ *[0-9]+/[0-9]+\] !!' "$log" | sed 's/^/    /'
  fi
done <<<"$triples"

echo "sweep-all: $(wc -l <<<"$triples" | tr -d ' ') profiles in $((SECONDS - started))s"
exit "$failed"
