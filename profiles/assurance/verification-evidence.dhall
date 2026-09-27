--| Shared profile for verification evidence.
--
-- ## Evidence and identity
--
-- One Verification Run is an immutable event: one execution of one scenario at
-- exact revisions, or one comparison of recorded runs. It links to digest-pinned
-- data in durable storage and never contains measurements. An Attested Computation
-- defines how a result is produced and independently checked; an Attestation
-- records the verifier's conclusion. All three live in one bundle so runs can
-- resolve local VC-N computation handles. Definitions use stable handles; runs
-- and attestations use paths because concurrent writers cannot safely allocate
-- sequential handles with `okf id next`. A runId identifies the event even in
-- `okf concepts --json`, whose rows omit paths; a timestamp is not identity.
--
-- ## Scope and limits
--
-- `verified` is an append-only confirmation on a run; the Attestation is the
-- separate evidence of what was checked. A tool never writes a `human:` actor.
-- Event records take neither status nor stale_after because they are not
-- redrafted and do not decay. Definition records take OKF's v0.2 pair.
-- Runtime-specific layer and cost-tier vocabularies are open here; a consumer
-- can narrow them with a profile-scope overlay. The descriptor cannot check
-- digest or revision hex lengths, UUIDv7 identity, data reachability, or Git
-- immutability; consumers check those locally. Markdown under references/ is a
-- concept and would need another declared type, so runnable reference files
-- are non-Markdown. No legacyTimestamp field exists in OKF v0.2.
let Profile = ../../Profile/Type.dhall

let TypeRule = ../../Profile/TypeRule.dhall

let FrontmatterRules = ../../Profile/FrontmatterRules.dhall

let okf = ../../Profile/okf.dhall

let FieldRule = okf.defaults.FieldRule

let NestedRules = okf.defaults.NestedRules

let NestedFieldRule = okf.defaults.NestedFieldRule

let HandleReferenceRule = okf.defaults.HandleReferenceRule

let PathReferenceRule = okf.defaults.PathReferenceRule

let Cardinality = okf.Cardinality

let FieldFormat = okf.FieldFormat

let v02 = ../../Profile/V02.dhall

let kinds = [ "correctness", "concurrency", "soak", "benchmark" ]

let placements = [ "local", "cell" ]

let outcomes =
      [ "passed"
      , "failed"
      , "errored"
      , "inconclusive"
      , "infrastructure-failure"
      ]

let comparisonVerdicts =
      [ "pass", "regression", "inconclusive", "infrastructure-failure" ]

let purposes = [ "nightly", "release", "baseline", "investigation" ]

let dataKinds =
      [ "run-spec"
      , "run-result"
      , "manifest"
      , "cell-manifest"
      , "samples"
      , "series"
      , "verdicts"
      , "diagnosis"
      , "logs"
      , "comparison"
      ]

let checkNames =
      [ "digests-match"
      , "revisions-resolve"
      , "cohort-matches-plan"
      , "verdict-recomputed"
      , "environment-captured"
      , "clean-worktree"
      ]

let scalar =
      \(name : Text) ->
      \(description : Text) ->
        FieldRule::{
        , field = name
        , description = Some description
        , cardinality = Cardinality.Scalar
        }

let enum =
      \(name : Text) ->
      \(description : Text) ->
      \(allowedValues : List Text) ->
        scalar name description // { allowedValues }

let formatted =
      \(name : Text) ->
      \(description : Text) ->
      \(format : FieldFormat) ->
        scalar name description // { format = Some format }

let list =
      \(name : Text) ->
      \(description : Text) ->
        FieldRule::{
        , field = name
        , description = Some description
        , cardinality = Cardinality.List
        }

let nScalar =
      \(name : Text) ->
      \(description : Text) ->
        NestedFieldRule::{
        , field = name
        , description = Some description
        , cardinality = Cardinality.Scalar
        }

let nEnum =
      \(name : Text) ->
      \(description : Text) ->
      \(allowedValues : List Text) ->
        nScalar name description // { allowedValues }

let nFormatted =
      \(name : Text) ->
      \(description : Text) ->
      \(format : FieldFormat) ->
        nScalar name description // { format = Some format }

let nPaths =
      \(name : Text) ->
      \(description : Text) ->
        NestedFieldRule::{
        , field = name
        , description = Some description
        , cardinality = Cardinality.List
        , path = Some PathReferenceRule::{=}
        }

let nPath =
      \(name : Text) ->
      \(description : Text) ->
        NestedFieldRule::{
        , field = name
        , description = Some description
        , path = Some PathReferenceRule::{=}
        }

let bundlePath =
      \(name : Text) ->
      \(description : Text) ->
        scalar name description // { path = Some PathReferenceRule::{=} }

let computationRef = Some HandleReferenceRule::{ localPrefix = "VC" }

let isRun = Some { field = "recordKind", hasValue = [ "run" ] }

let isComparison = Some { field = "recordKind", hasValue = [ "comparison" ] }

let nameValue =
      NestedRules::{
      , required =
        [ nScalar "name" "Name, as the harness spells it."
        , nScalar "value" "Value the run used."
        ]
      }

let attestedComputation =
      TypeRule::{
      , type = "Attested Computation"
      , description = Some
          "How one outcome, verdict or figure is computed from raw run data, and how a deterministic verifier re-checks it."
      , pathPattern = Some "computations/*"
      , idPrefix = Some "VC"
      , frontmatter = FrontmatterRules::{
        , required =
          [ formatted
              "computationId"
              "Bundle-scoped stable VC-N handle."
              (FieldFormat.DocumentHandle "VC")
          , scalar "runtime" "How the computation is run."
          , scalar
              "algorithm"
              "Identifier the harness writes into its documents."
          , formatted
              "algorithmVersion"
              "A change that can alter a result takes a new VC handle."
              FieldFormat.NonNegativeInteger
          , enum
              "produces"
              "What the computation yields."
              [ "outcome", "verdict", "diagnosis", "comparison", "summary" ]
          ,     list "inputs" "Data-link kinds the computation reads."
            //  { allowedValues = dataKinds }
          , scalar "implementation" "Module implementing the algorithm."
          ,     list "parameters" "Typed named holes; empty when it takes none."
            //  { elementFields = Some NestedRules::{
                  , required =
                    [ nScalar "name" "The name the computation binds."
                    , nScalar "type" "What kind of value it takes."
                    ]
                  , optional =
                    [ nFormatted
                        "required"
                        "Whether a caller must supply it."
                        FieldFormat.Boolean
                    ]
                  }
                }
          , FieldRule::{
            , field = "executor"
            , description = Some "How a run is performed and what it returns."
            , objectFields = Some NestedRules::{
              , required =
                [ nPath "resource" "Run instructions: a non-Markdown file here."
                ,     nScalar "receipt" "Run-directory documents a run returns."
                  //  { cardinality = Cardinality.List }
                ]
              }
            }
          , FieldRule::{
            , field = "attester"
            , description = Some "Deterministic code that re-checks a run."
            , objectFields = Some NestedRules::{
              , required =
                [ nPath "resource" "The verifier: a non-Markdown file here." ]
              }
            }
          ]
        , optional =
          [ v02.status
          , v02.staleAfter
          ,     list "appliesTo" "Evidence kinds whose runs may name it."
            //  { allowedValues = kinds }
          , bundlePath "computation" "The computation file, when not inline."
          ,     scalar "supersedes" "The definition this one replaces."
            //  { reference = computationRef }
          ]
        }
      }

let componentMembers =
      NestedRules::{
      , required =
        [ nFormatted
            "project"
            "Mori URI of the owning project."
            (FieldFormat.UriWithScheme "mori")
        , nScalar "package" "Cabal package name."
        , nScalar "version" "Exact resolved version."
        , nEnum "source" "Where the solver took it from." [ "hackage", "git" ]
        ,     nScalar "revision" "Full 40-character commit."
          //  { when = Some { field = "source", hasValue = [ "git" ] } }
        ]
      }

let environmentMembers =
      NestedRules::{
      , required =
        [ nScalar "os" "Operating system."
        , nScalar "arch" "CPU architecture."
        , nScalar "cpuModel" "CPU model string."
        , nFormatted "cores" "Logical cores." FieldFormat.NonNegativeInteger
        , nFormatted
            "memoryBytes"
            "Physical memory."
            FieldFormat.NonNegativeInteger
        , nScalar "ghc" "Compiler that built the harness."
        , nScalar "postgres" "PostgreSQL server version."
        ]
      , optional =
        [ nScalar "kernel" "Kernel release."
        , nScalar "machineType" "Cloud machine type of the driver."
        , nScalar "cell" "Name of the leased cell."
        , nScalar "cellRun" "The cell's own identifier for the leased run."
        , nScalar "zone" "Cloud zone."
        , nScalar "kafka" "Broker version, when a broker took part."
        ]
      }

let dataMembers =
      NestedRules::{
      , required =
        [ nEnum "kind" "What the object is." dataKinds
        , nFormatted
            "uri"
            "Where the object lives in durable storage."
            FieldFormat.Uri
        , nScalar "digest" "Lowercase 64-hex SHA-256 of the object."
        , nScalar "mediaType" "IANA media type."
        , nFormatted "bytes" "Object size." FieldFormat.NonNegativeInteger
        ]
      }

let comparisonMembers =
      NestedRules::{
      , required =
        [ nEnum "verdict" "What the comparison concluded." comparisonVerdicts
        , nEnum
            "factor"
            "What differs between the arms."
            [ "cohort", "harness", "dimension", "knob" ]
        , nScalar "baselineValue" "The factor's value on the baseline arm."
        , nScalar "candidateValue" "The factor's value on the candidate arm."
        , nEnum
            "design"
            "How the arms were interleaved."
            [ "abba", "baab", "sequential" ]
        , nPaths "baselineRuns" "Recorded runs of the baseline arm."
        , nPaths "candidateRuns" "Recorded runs of the candidate arm."
        ]
      , optional =
        [ nScalar "factorName" "Which dimension, knob or package differs." ]
      }

let verificationRun =
      TypeRule::{
      , type = "Verification Run"
      , description = Some
          "One recorded run, or one recorded comparison of runs: what ran, against what, where, with which outcome, and where the data is."
      , pathPattern = Some "runs/*/*/*/*"
      , frontmatter = FrontmatterRules::{
        , required =
          [ scalar "runId" "UUIDv7 of the record. Equals the file name."
          , enum
              "recordKind"
              "One run, or a comparison of runs."
              [ "run", "comparison" ]
          , enum "purpose" "Why this was recorded." purposes
          , scalar "scenario" "Scenario identifier: layer/component/kind/name."
          , scalar "layer" "Runtime layer the scenario isolates."
          , scalar "component" "Component inside the layer."
          , enum "kind" "Kind of evidence." kinds
          , scalar "tier" "Cost tier."
          , enum "placement" "Where it ran." placements
          , enum "outcome" "What came of it." outcomes
          , formatted "startedAt" "UTC start." FieldFormat.Rfc3339Utc
          , formatted "finishedAt" "UTC finish." FieldFormat.Rfc3339Utc
          , formatted
              "subject"
              "Mori URI of the most specific runtime artifact under test."
              (FieldFormat.UriWithScheme "mori")
          , enum "subjectKind" "What `subject` names." [ "project", "package" ]
          , scalar "harnessRevision" "Full 40-character commit of the harness."
          , formatted
              "harnessDirty"
              "Whether the harness was built from a modified tree."
              FieldFormat.Boolean
          ,     list "computations" "Definitions that produced the outcome."
            //  { reference = computationRef }
          ,     list "data" "Digest-pinned links to the data."
            //  { elementFields = Some dataMembers, uniqueBy = Some "uri" }
          ,     scalar "cohort" "Name of the cohort the build linked."
            //  { when = isRun }
          ,     scalar "solverPlanHash" "Hash of the resolved solver plan."
            //  { when = isRun }
          ,     list "components" "Every runtime package the build linked."
            //  { elementFields = Some componentMembers
                , uniqueBy = Some "package"
                , when = isRun
                }
          , FieldRule::{
            , field = "environment"
            , description = Some "Flat excerpt of the environment fingerprint."
            , objectFields = Some environmentMembers
            , when = isRun
            }
          ,     formatted
                  "seed"
                  "Seed of every random choice."
                  FieldFormat.NonNegativeInteger
            //  { when = isRun }
          ,     scalar
                  "compatibilityKey"
                  "64-hex digest of what must match for two runs to be comparable."
            //  { when = isRun }
          , FieldRule::{
            , field = "comparison"
            , description = Some "The arms and the verdict."
            , objectFields = Some comparisonMembers
            , when = isComparison
            }
          ]
        , optional =
          [     list "knobs" "Knob values the run used."
            //  { elementFields = Some nameValue, uniqueBy = Some "name" }
          ,     list "dimensions" "Dimension values the run used."
            //  { elementFields = Some nameValue, uniqueBy = Some "name" }
          ,     list "knownDefects" "Known-defect references of the scenario."
            //  { format = Some FieldFormat.Uri }
          ,     list "produced" "Mori URIs of reports this run caused."
            //  { format = Some (FieldFormat.UriWithScheme "mori") }
          , bundlePath
              "previousRun"
              "Latest earlier record of the same scenario and compatibility key."
          ]
        }
      }

let attestation =
      TypeRule::{
      , type = "Attestation"
      , description = Some
          "A deterministic verifier fetched a record's data, re-checked it, and this is what it concluded."
      , pathPattern = Some "attestations/*/*/*"
      , frontmatter = FrontmatterRules::{
        , required =
          [ scalar "attestationId" "UUIDv7. Equals the file name."
          , bundlePath "run" "The record attested."
          , formatted
              "attester"
              "The verifier, as an OKF actor."
              FieldFormat.Actor
          , scalar
              "attesterRevision"
              "Full 40-character commit of the verifier."
          , formatted "attestedAt" "UTC completion time." FieldFormat.Rfc3339Utc
          , enum
              "verdict"
              "What the verifier concluded."
              [ "confirmed", "refuted", "incomplete" ]
          ,     list "checks" "Every check, and what it found."
            //  { elementFields = Some NestedRules::{
                  , required =
                    [ nEnum "name" "Which check." checkNames
                    , nEnum
                        "result"
                        "What it found."
                        [ "passed", "failed", "skipped" ]
                    ]
                  , optional = [ nScalar "detail" "One line saying why." ]
                  }
                , uniqueBy = Some "name"
                }
          , list
              "dataDigests"
              "64-hex SHA-256 of every object fetched and matched."
          ]
        , optional =
          [ FieldRule::{
            , field = "exception"
            , description = Some "A human's acceptance of an anomaly."
            , objectFields = Some NestedRules::{
              , required =
                [ nFormatted
                    "authority"
                    "The human who accepted it."
                    FieldFormat.HumanActor
                , nScalar "reason" "Why the anomaly is acceptable."
                ]
              }
            }
          ]
        }
      }

let shared =
      Profile::{
      , name = "verification-evidence"
      , description = Some
          "Evidence about a runtime: definitions of how verdicts are computed, immutable records of runs that link to their data by digest, and attestations that a deterministic verifier re-checked that data."
      , okfVersion = "0.2"
      , requireBundleVersion = Some "0.2"
      , allowUnknownTypes = False
      , allowUnknownFields = False
      , idField = Some "computationId"
      , frontmatter = FrontmatterRules::{
        , required =
          [ scalar "type" "One of the three concept types."
          , scalar "title" "What this record is, in one line."
          , scalar "description" "One sentence a reader can evaluate alone."
          , v02.generated
          ]
        , optional = [ v02.verified ]
        }
      , types = [ attestedComputation, verificationRun, attestation ]
      }

in  shared
