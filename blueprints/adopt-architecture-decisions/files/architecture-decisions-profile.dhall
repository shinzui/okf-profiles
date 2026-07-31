--| Shared ADR profile. Bump the tag and semantic hash together when upgrading.
--
-- `supersedes`, `supersededBy`, and `originatingPlan` are reclassified from the
-- upstream `recommended` list to `optional`. They are provenance whose absence
-- is ordinary rather than deficient: a live decision that has never been
-- superseded has nothing to record, and ADRs predating plan tracking have no
-- originating plan. Under `--strict` a recommended field that is absent is an
-- error, so leaving them recommended fails every ADR in a typical corpus.
-- `optional` still enforces every constraint the upstream rule declares --
-- including the ADR handle references -- whenever the field is present.
--
-- Delete this override if your project genuinely records all three on every
-- decision and you want the stricter check.
let Profiles =
      https://raw.githubusercontent.com/shinzui/okf-profiles/v0.7.0/package.dhall
        sha256:3a785b2ee66301e2bcd6466352e9480e71b7fafdca62256b4a2038cace5d0bb8

let base = Profiles.documentation.architectureDecisions

in  base
    //  { frontmatter =
            base.frontmatter
        //  { recommended = [] : List Profiles.FieldRule.Type
            , optional = base.frontmatter.recommended
            }
        }
