---
okf_version: "0.2"
---

# Failure Mode

- [Scheduled exports stop silently when the credential rotates](first.md) - A rotated credential leaves the exporter running and reporting success while every upload is rejected.
- [Nightly reindex leaves the search cluster with two primaries](second.md) - A reindex that overruns its window is observed to leave duplicate primaries, with no mechanism yet established.
- [Retry storm after a dependency timeout](third.md) - An earlier and coarser account of the retry amplification now recorded more precisely as FM-1's acknowledgement gap.

