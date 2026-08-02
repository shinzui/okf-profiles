---
type: Event Stream
title: order
description: Logical order aggregate stream inside the message store.
resource: postgresql://example/message_store/messages#order
generated:
  by: process:schema-sync
  at: "2026-07-30T00:00:00Z"
verified:
  by: human:nadeem
  at: "2026-07-31T00:00:00Z"
---

# order

Logical order aggregate stream. A stream is not a single physical table, so its
`resource` locates the message-store table it lives in and names the category as
a fragment. A human confirmed this description after the synchronisation process
produced it, so the concept carries both the machine and the human trust path.
