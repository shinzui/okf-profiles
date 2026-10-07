# Adopt platform transitions

Run the `adopt-transitions` Seihou blueprint in a project that has explicit plans to move
responsibilities between projects. It creates or repairs a declared transition bundle while
preserving handles and ownership. A repository with no transition intent receives no changes.
An already adopted repository reuses its concepts and is unchanged unless a defect or new
owner-backed intent is found.

The bundled profile snapshot is self-contained. The prompt requires strict OKF validation and
Mori semantic validation, and reports any unavailable CLI gate. It never invents runtime
observations or owner acceptance. Read [the authoring reference](files/migration-reference.md)
for defaults and constraints the bounded profile engine delegates to Mori.

The source is `coordination.transitions`; release consumers should pin a catalog release and
its semantic hash. `scripts/update-transition-snapshot.py` regenerates the snapshot and checks
semantic equality with the source profile.
