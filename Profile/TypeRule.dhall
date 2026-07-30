--| Schema for a single per-`type` rule inside an OKF house profile.
--
-- Both the type and its defaults come from okf's pinned canonical schema so this
-- package cannot accidentally drift from the decoder.
let okf = ./okf.dhall in okf.defaults.TypeRule
