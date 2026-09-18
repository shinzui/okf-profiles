---
okf_version: "0.2"
---

# Term

- [decider](decider.md) - A pure pair of functions that decides which events a command produces and evolves state from events.
- [inline projection](inline-projection.md) - A projection that is applied in the same transaction that appends the events it reads.
- [process manager](process-manager.md) - A long-running coordinator that reacts to events by issuing commands, possibly to several streams.
- [projection](projection.md) - A function that folds events from one or more streams into a queryable read model.
- [sidecar](sidecar.md) - The former name for the generated file that records which slots a code generator owns.
- [slot ledger](slot-ledger.md) - A generated file that records which slots of a source file a code generator owns and at which version.
- [stream](stream.md) - An ordered, append-only sequence of events that records the history of one entity.
