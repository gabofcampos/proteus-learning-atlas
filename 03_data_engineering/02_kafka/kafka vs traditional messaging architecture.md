- **traditional messaging systems** traditionally use queues where messages are delivered and consumers pop and process them → once popped they are no longer in the queue.
- **kafka** uses a distributed log and messages are retained for a configurable retention period (they can be reprocessed by consumers).

key differences:
- **kafka appends only**. Events are stored in an append only distributed log not a queue where they are removed from.
- kafka consumers use an offset to track event processing. messaging systems read once.
- partitioning distributes data across brokers instead of queue sharding models.
- sequential disk writes improve throughput compared with random I/O patterns used by many traditional messaging systems.

## related
- [[kafka fundamentals]]