# Kafka practical scenarios and recall

Session: 2026-11-11. Airport flight-event examples used to practise partitioning, ordering, consumer recovery, and delivery guarantees.

The answers below preserve my reasoning, lightly edited for readability. Tutor feedback records the refinements discussed. These are conceptual exercises, not results from a running Kafka deployment.

## 1. Choosing a partition key

### Scenario

A topic, `flight_events`, has 12 partitions and six consumers in one consumer group. Events contain:

```text
event_id, flight_id, airport_code, event_time, status
```

Flight updates include `scheduled → boarding → departed`. Some events arrive late, and large airports generate more events than small ones. We want per-flight Kafka arrival order and reasonably balanced processing.

Which key should we choose: `airport_code`, `flight_id`, or `event_id`?

### My answer and thought process

My first thought was to keep the same flight's data in the same partition. Updates are per flight, and I imagined querying its status frequently, so grouping that information seemed useful. With `flight_id` as the key, its records land in the same partition and Kafka provides ordered consumption within that partition.

Using `airport_code` could create skew: LAX generates more flight events than Santiago de Compostela, so a partition containing LAX traffic could take much longer to process.

I was unsure what would happen with `event_id`, and whether I was applying Spark thinking too directly to Kafka.

### Tutor reasoning and refinements

The choice of `flight_id` and the skew concern are sound. Spark intuition about keys, partitions, and skew transfers well. Kafka adds an important concern: **the partition is the ordering boundary**.

Grouping by flight primarily supports ordered processing. Query frequency is not the main justification: an application would typically query a downstream database for current flight status rather than use Kafka as a lookup store.

| Key | Consequence |
| --- | --- |
| `flight_id` | Keeps a flight's events together; many flight IDs usually distribute traffic reasonably well. A particularly hot flight can still cause imbalance. |
| `airport_code` | Groups an airport's events but risks hot partitions for busy airports. Several airport keys can map to the same partition. |
| `event_id` | Unique, varied event IDs generally spread traffic well, but updates for one flight can go to different partitions, losing their shared ordering. |

Same-key routing assumes a consistent key-based partitioner and an unchanged partition count. Increasing the partition count can change the destination partition for subsequent records with an existing key.

**Interview answer:** “I would key by flight ID to preserve ordered processing of updates for each flight. Airport code risks hot partitions at busy airports; event ID can scatter a flight's updates across partitions. Kafka log order still differs from event-time order.”

## 2. Late events versus Kafka ordering

### Scenario

The consumer receives these records for `IB3170` through the same partition:

| Arrival order | Event time | Status |
| --- | --- | --- |
| 1 | 10:05 | boarding |
| 2 | 10:15 | departed |
| 3 | 10:00 | scheduled |

Did Kafka break its ordering guarantee? How should a latest-flight-status table handle the third update?

### My answer and thought process

Kafka's ordering guarantee applies within a partition. I thought the producer might have sent the scheduled update later, which explains why it arrived last. To maintain current status, we should check `event_time` instead of trusting the partition's update order.

### Tutor reasoning and refinements

Correct: Kafka did not break its guarantee. More precisely, it preserves **partition append order**, not chronological order by an event's timestamp. With multiple producers, there is no single global producer-send order. Delayed publication of the scheduled event is one plausible explanation.

For the latest-status table, apply an update only if its event time is newer than the stored event time for that flight. This prevents the late `scheduled` event from overwriting `departed`. Retain the late event in history if needed.

A source-provided sequence number or version can be preferable when timestamps tie or source clocks disagree. The business must define tie-breaking and correction rules.

**Takeaway:** Per-flight partition ordering does not eliminate late or out-of-order event times.

## 3. Crash after database writes, before offset commit

### Scenario

A consumer reads offsets `100–109` from one partition, writes all ten events successfully to a database, then crashes before committing its new offset. Its last committed offset is `100`, meaning **100 is the next record to read**.

Which records are replayed? What happens with plain inserts? How can writes be made safe to repeat?

### My answer and thought process

The consumer reads `100–109` again. Plain inserts could produce duplicate records. I proposed upserts: check whether an event exists by key, and write it only if it does not exist.

### Tutor reasoning and refinements

Correct replay and duplicate analysis. The solution is an **idempotent sink**: processing an event again has no additional effect.

Refine the implementation: a separate “check, then insert” can race when concurrent writers both observe that a record is absent. Use database-enforced uniqueness and atomic conflict handling.

- **Event-history table:** a unique `event_id` plus insert-on-conflict-do-nothing.
- **Latest-flight-status table:** upsert by `flight_id`, applying only a newer event time or source version.

An upsert is not automatically idempotent. Setting `status = 'departed'` is repeatable; incrementing `event_count` on each retry is not.

**Interview answer:** “The batch is replayed because its offsets were not committed. I would make sink writes idempotent using a unique event ID and atomic conflict handling, then commit offsets after the write succeeds.”

## 4. Crash after offset commit, before database writes

### Scenario

Reverse the sequence: commit the offset past the batch first, then write to the database. The consumer crashes between those steps.

### My answer and thought process

After restart, those offsets are not replayed. The records are not processed, so we lose them.

### Tutor reasoning and refinements

Correct: normal recovery skips the records and their database effects are missing. The records may still exist in Kafka until retention removes them; the loss is in downstream processing, not necessarily deletion from Kafka. An explicit replay could recover them while they remain available.

| Sequence | Crash between steps | Behavior |
| --- | --- | --- |
| Commit offsets → write | Records skipped | At-most-once delivery to this processing path |
| Write → commit offsets | Records replayed | At-least-once processing |
| Write idempotently → commit offsets | Replay adds no extra sink effect | At-least-once processing with effectively-once sink effects |

These descriptions assume the consumer commits only the intended processed range and handles failures correctly. Partial batch writes also need safe replay.

Kafka transactions alone do not make writes to an arbitrary external database exactly-once. End-to-end guarantees depend on the source, processing engine, sink, and how progress and writes are coordinated.

## 5. Partitions and consumer-group parallelism

### Scenario and my answers

For 12 partitions and six consumers, I answered: two partitions per consumer. Correct under balanced assignment.

The follow-up increased the **consumer count to 15**, keeping 12 partitions. I instead answered a different configuration: **15 partitions and six consumers**, with three consumers handling two partitions each and three handling three.

### Tutor reasoning and correction

My arithmetic was correct for the configuration I described, but I had changed the wrong quantity.

| Partitions | Consumers in one group | Balanced assignment |
| --- | --- | --- |
| 12 | 6 | Two partitions per consumer |
| 12 | 15 | 12 consumers handle one partition each; three are idle |
| 15 | 6 | Three consumers handle two partitions each; three handle three |

Within one group, a partition is assigned to at most one consumer at a time. More consumers than partitions do not increase partition-level consumption parallelism. Separate consumer groups can independently consume the same topic.

## Recall checkpoints

- Can I explain why `flight_id` is a better key for per-flight ordering than `airport_code` or `event_id`?
- Can I distinguish partition append order from event-time order?
- Can I explain both crash windows without confusing the committed offset with the last processed record?
- Can I describe an atomic, idempotent sink write and an upsert that is not idempotent?
- Can I calculate active consumers without changing the scenario's partition count?

## Next learning step

Kafka scenarios completed. Next: essential Structured Streaming, particularly event time versus processing time, stateful windows, watermarks, and checkpoint recovery. Watermarks are a priority from the interview discussion.

The Kafka-to-Spark/Delta end-to-end guarantee discussion remains a follow-up; these exercises covered a generic Kafka consumer writing to a database.
