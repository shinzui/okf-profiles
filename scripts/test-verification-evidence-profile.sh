#!/usr/bin/env bash

set -euo pipefail

okf_bin="${OKF_BIN:-okf}"
profile="profiles/assurance/verification-evidence.dhall"

"${okf_bin}" validate fixtures/verification-evidence \
  --strict --profile "${profile}" --profile-enforce --log-enforce

# A failure for some unrelated reason must never make a fixture pass.
case_count=0
while IFS='|' read -r fixture expected; do
  case_count=$((case_count + 1))
  if output="$("${okf_bin}" validate "fixtures/verification-evidence-invalid/${fixture}" \
    --profile "${profile}" --profile-enforce 2>&1)"; then
    echo "expected profile enforcement to reject ${fixture}" >&2
    exit 1
  fi
  if ! grep -qF -- "${expected}" <<<"${output}"; then
    echo "${fixture} failed without the expected diagnostic: ${expected}" >&2
    echo "${output}" >&2
    exit 1
  fi
  case "${fixture}" in
    computation-missing-id|computation-wrong-prefix) expected_count=2 ;;
    *) expected_count=1 ;;
  esac
  actual_count="$(grep '^profile: ' <<<"${output}" | grep -vc 'advisory deviation(s)' || true)"
  if [[ "${actual_count}" != "${expected_count}" ]]; then
    echo "${fixture} reported ${actual_count} profile diagnostics, expected ${expected_count}" >&2
    echo "${output}" >&2
    exit 1
  fi
done <<'FIXTURES'
missing-bundle-version|bundle does not declare okf_version
unknown-type|type not in profile vocabulary
missing-title|missing profile-required field: title
missing-description|missing profile-required field: description
missing-generated|missing profile-required field: generated
bad-actor|frontmatter value at generated.by must match format actor
bad-verified-actor|frontmatter value at verified[0].by must match format actor
computation-missing-id|Attested Computation requires a document ID with prefix VC
computation-wrong-prefix|document ID must look like VC-<number>
computation-duplicate-id|duplicate document ID VC-1
computation-outside-computations-tree|Attested Computation must match path pattern: computations/*
computation-missing-runtime|missing profile-required field: runtime
computation-untyped-parameter|missing profile-required field: parameters[0].type
computation-missing-executor|missing profile-required field: executor
computation-dangling-executor|executor.resource references
computation-missing-attester|missing profile-required field: attester
computation-dangling-attester|attester.resource references
computation-invalid-status|frontmatter value at status must be one of
computation-bad-stale-after|frontmatter value at stale_after must match format date
run-outside-runs-tree|Verification Run must match path pattern: runs/*/*/*/*
run-missing-run-id|missing profile-required field: runId
run-invalid-kind|frontmatter value at kind must be one of
run-invalid-outcome|frontmatter value at outcome must be one of
run-bad-started-at|frontmatter value at startedAt must match format rfc3339-utc
run-non-mori-subject|frontmatter value at subject must match format uri-with-scheme(mori)
run-invalid-subject-kind|frontmatter value at subjectKind must be one of
run-missing-component-revision|missing profile-required field: components[0].revision
run-non-mori-component-project|frontmatter value at components[0].project must match format uri-with-scheme(mori)
run-invalid-component-source|frontmatter value at components[0].source must be one of
run-duplicate-component-package|for components.package at element indices
run-duplicate-knob|for knobs.name at element indices
run-duplicate-dimension|for dimensions.name at element indices
run-non-boolean-harness-dirty|frontmatter value at harnessDirty must match format boolean
run-unresolved-computation|references VC-99, which does not exist in this bundle
run-data-missing-digest|missing profile-required field: data[0].digest
run-data-invalid-kind|frontmatter value at data[0].kind must be one of
run-data-relative-uri|frontmatter value at data[0].uri must match format uri
run-data-non-integer-bytes|frontmatter value at data[0].bytes must match format non-negative-integer
run-dangling-previous-run|previousRun references
run-non-mori-produced|frontmatter value at produced must match format uri-with-scheme(mori)
attestation-outside-attestations-tree|Attestation must match path pattern: attestations/*/*/*
attestation-dangling-run|run references
attestation-bad-attester-actor|frontmatter value at attester must match format actor
attestation-invalid-check|frontmatter value at checks[0].name must be one of
attestation-scalar-checks|frontmatter cardinality at checks must be list
attestation-invalid-verdict|frontmatter value at verdict must be one of
attestation-exception-authority-not-human|exception.authority must match format human-actor
attestation-bad-attested-at|frontmatter value at attestedAt must match format rfc3339-utc
attestation-duplicate-check-name|for checks.name at element indices
attestation-invalid-check-result|frontmatter value at checks[0].result must be one of [passed, failed, skipped]
attestation-missing-attestationId|missing profile-required field: attestationId
attestation-missing-attestedAt|missing profile-required field: attestedAt
attestation-missing-attesterRevision|missing profile-required field: attesterRevision
attestation-missing-check-name|missing profile-required field: checks[0].name
attestation-missing-check-result|missing profile-required field: checks[0].result
attestation-missing-checks|missing profile-required field: checks
attestation-missing-dataDigests|missing profile-required field: dataDigests
attestation-missing-exception-reason|missing profile-required field: exception.reason
computation-dangling-supersedes|supersedes references VC-99
computation-invalid-applies-to|frontmatter value at appliesTo must be one of [correctness, concurrency, soak, benchmark]
computation-invalid-input|frontmatter value at inputs must be one of [run-spec, run-result, manifest, cell-manifest, samples, series, verdicts, diagnosis, logs, comparison]
computation-invalid-produces|frontmatter value at produces must be one of [outcome, verdict, diagnosis, comparison, summary]
computation-missing-algorithm|missing profile-required field: algorithm
computation-missing-algorithmVersion|missing profile-required field: algorithmVersion
computation-missing-executor-receipt|missing profile-required field: executor.receipt
computation-missing-executor-resource|missing profile-required field: executor.resource
computation-missing-implementation|missing profile-required field: implementation
computation-missing-inputs|missing profile-required field: inputs
computation-missing-parameters|missing profile-required field: parameters
computation-missing-produces|missing profile-required field: produces
computation-nonboolean-parameter-required|frontmatter value at parameters[0].required must match format boolean
run-data-duplicate-uri|for data.uri at element indices
run-data-missing-media-type|missing profile-required field: data[0].mediaType
run-invalid-environment-cores|frontmatter value at environment.cores must match format non-negative-integer
run-invalid-placement|frontmatter value at placement must be one of [local, cell]
run-invalid-purpose|frontmatter value at purpose must be one of [nightly, release, baseline, investigation]
run-invalid-record-kind|frontmatter value at recordKind must be one of [run, comparison]
run-missing-cohort|missing profile-required field: cohort
run-missing-comparison|missing profile-required field: comparison
run-missing-compatibilityKey|missing profile-required field: compatibilityKey
run-missing-component|missing profile-required field: component
run-missing-component-package|missing profile-required field: components[0].package
run-missing-component-project|missing profile-required field: components[0].project
run-missing-component-source|missing profile-required field: components[0].source
run-missing-component-version|missing profile-required field: components[0].version
run-missing-components|missing profile-required field: components
run-missing-computations|missing profile-required field: computations
run-missing-data|missing profile-required field: data
run-missing-dimension-name|missing profile-required field: dimensions[0].name
run-missing-environment|missing profile-required field: environment
run-missing-environment-arch|missing profile-required field: environment.arch
run-missing-environment-cores|missing profile-required field: environment.cores
run-missing-environment-cpuModel|missing profile-required field: environment.cpuModel
run-missing-environment-ghc|missing profile-required field: environment.ghc
run-missing-environment-memoryBytes|missing profile-required field: environment.memoryBytes
run-missing-environment-os|missing profile-required field: environment.os
run-missing-environment-postgres|missing profile-required field: environment.postgres
run-missing-finishedAt|missing profile-required field: finishedAt
run-missing-harnessRevision|missing profile-required field: harnessRevision
run-missing-knob-value|missing profile-required field: knobs[0].value
run-missing-layer|missing profile-required field: layer
run-missing-placement|missing profile-required field: placement
run-missing-purpose|missing profile-required field: purpose
run-missing-recordKind|missing profile-required field: recordKind
run-missing-scenario|missing profile-required field: scenario
run-missing-seed|missing profile-required field: seed
run-missing-solverPlanHash|missing profile-required field: solverPlanHash
run-missing-tier|missing profile-required field: tier
run-non-integer-seed|frontmatter value at seed must match format non-negative-integer
run-relative-known-defect|frontmatter value at knownDefects must match format uri
attestation-scalar-data-digests|frontmatter cardinality at dataDigests must be list, found scalar: "abc"
comparison-dangling-baseline-run|comparison.baselineRuns[0] references /runs/example/missing.md
comparison-invalid-design|frontmatter value at comparison.design must be one of [abba, baab, sequential]
comparison-invalid-factor|frontmatter value at comparison.factor must be one of [cohort, harness, dimension, knob]
comparison-invalid-verdict|frontmatter value at comparison.verdict must be one of [pass, regression, inconclusive, infrastructure-failure]
comparison-missing-baselineRuns|missing profile-required field: comparison.baselineRuns
comparison-missing-baselineValue|missing profile-required field: comparison.baselineValue
comparison-missing-candidateRuns|missing profile-required field: comparison.candidateRuns
comparison-missing-candidateValue|missing profile-required field: comparison.candidateValue
comparison-missing-design|missing profile-required field: comparison.design
comparison-missing-factor|missing profile-required field: comparison.factor
comparison-missing-verdict|missing profile-required field: comparison.verdict
computation-bad-algorithm-version|frontmatter value at algorithmVersion must match format non-negative-integer
computation-dangling-computation-path|computation references /references/missing.txt
computation-missing-parameter-name|missing profile-required field: parameters[0].name
computation-scalar-executor-receipt|frontmatter cardinality at executor.receipt must be list, found scalar: "run-spec.json"
run-bad-finished-at|frontmatter value at finishedAt must match format rfc3339-utc
run-invalid-environment-memory-bytes|frontmatter value at environment.memoryBytes must match format non-negative-integer
run-unknown-measurement|frontmatter field not declared by profile: p99Millis
FIXTURES

fixture_dirs=(fixtures/verification-evidence-invalid/*/)
if [[ "${#fixture_dirs[@]}" -ne "${case_count}" ]]; then
  echo "rejection fixture directory count does not match asserted cases" >&2
  exit 1
fi

echo "OK: verification-evidence profile acceptance and rejection fixtures"
