# Structured Streaming practical scenarios and recall

Session: 2026-11-19. Airport flight-event examples used to practise event time vs processing time, state store lifecycle, watermark mechanics, late data handling, and output modes.

The answers below preserve my reasoning, lightly edited for readability. Tutor feedback records the refinements discussed. These are conceptual exercises, not results from a running Spark cluster.

---

## 1. Event time versus processing time

### Scenario

A streaming pipeline processes flight telemetry departure events to count departures per 10-minute window.
A flight departs physically at **10:02** (`event_time = 10:02`).
Due to a network delay in airport telemetry, the message is ingested via Kafka and processed by Spark at **10:14** (`processing_time = 10:14`).

Which timestamp determines whether the flight belongs to the 10:00–10:10 departure-count window?

### My answer and thought process

The flight enters the count window determined by its `event_time`, not its `processing_time`. A flight takes off at a specific real-world time. If network delays cause the event to be processed later, that is an infrastructure delay, but the event itself belongs to the window of its `event_time`. In this case, `event_time = 10:02` places it in the 10:00–10:10 window.

### Tutor reasoning and refinements

Spot on. In streaming systems, **business semantics live in event time**. Processing time reflects arbitrary network and compute latency. 
If an airport evaluated departures by processing time, network downtime would create false zero-departure windows followed by artificial spikes when connectivity recovers.

**Interview answer:** "Aggregations must be keyed by event time to maintain accurate domain semantics regardless of network jitter or processing lag."

---

## 2. Why watermarks and state stores are necessary

### Scenario

Why can't Spark Structured Streaming simply keep all past time windows open forever in memory to catch all late arrivals?

### My answer and thought process

Streams represent an unbounded, continuous production of data. If we kept all windows open indefinitely, two major issues arise:
1. **Recalculation and aggregation overhead:** Windows would never close, meaning past results would continually need recalculation and rewriting.
2. **State Store OOM (Out Of Memory):** Retaining every historical window in memory creates an unbounded state size. Because compute nodes cannot scale memory infinitely, the cluster will eventually crash with an Out of Memory error.

### Tutor reasoning and refinements

Exactly right.
* **State Store:** Spark maintains intermediate state (e.g., partial window counts) in the executor's memory (JVM heap / RocksDB). Periodically, this state is checkpointed to durable storage (ADLS / S3) for fault recovery.
* **The Watermark as a bounded state garbage collector:** The watermark is a moving threshold that defines the trailing edge of time. Once the watermark passes the end of a window, Spark purges that window's state from the executor's RAM.

**Interview answer:** "The watermark acts as a bounded state garbage collector. Without it, maintaining state for unbounded streams inevitably results in State Store Out-Of-Memory (OOM) failures."

---

## 3. Watermark calculation and late data drops

### Scenario

We configure our streaming query with a 10-minute watermark threshold:
```python
df_stream.withWatermark("event_time", "10 minutes") \
         .groupBy(window("event_time", "10 minutes")) \
         .count()
```

- **Micro-batch 1:** The maximum event time observed is `10:15`.
- **Micro-batch 2:** A late event arrives with `event_time = 10:02` (processed at wall-clock time 10:16).

What is the watermark for Micro-batch 2? Does Spark process this flight or drop it? What if the threshold were 15 minutes?

### My answer and thought process

1. At the end of Micro-batch 1, the watermark is calculated as:
   $$\text{Watermark} = \max(\text{event\_time}) - \text{threshold} = 10:15 - 10\text{ min} = \mathbf{10:05}$$
2. In Micro-batch 2, the event arrives with `event_time = 10:02`. Since $10:02 < 10:05$, the event falls behind the watermark and is **dropped**.
3. If the threshold were 15 minutes:
   $$\text{Watermark} = 10:15 - 15\text{ min} = \mathbf{10:00}$$
   Since $10:02 > 10:00$, the event falls within the acceptable late window and **is processed**.

### Tutor reasoning and refinements

Perfect. A critical nuance often tested in interviews:
- **Calculation timing:** The watermark is computed at the **end** of a micro-batch based on the maximum event time seen, and that value is applied to filter the **subsequent** micro-batch.
- **Direction:** An event is dropped if its `event_time < watermark`. The watermark represents the minimum acceptable threshold for incoming data.

**Interview answer:** "Watermarks trail the maximum observed event time: $\text{Watermark} = \max(\text{event\_time}) - \text{delay}$. Spark updates the watermark at the end of each micro-batch and applies it to the next. Records with event time older than the current watermark are dropped and their corresponding state is purged."

---

## 4. Output modes with watermarked aggregations

### Scenario

We have 10-minute tumbling windows and a 10-minute watermark.
The sink is a Delta Lake table written in **Append mode**.
The query processes an event with `event_time = 10:15` (belonging to window `[10:10 - 10:20]`).

Why has nothing been written to Delta Lake yet for window `[10:10 - 10:20]`, or even for the previous window `[10:00 - 10:10]`?

### My answer and thought process

If nothing is written for `[10:10 - 10:20]`, it means the window is still open and either we are in Update mode or the first event has just landed. If neither window has written to the sink, it indicates that the output mode is **Append**, meaning windows only write out when closed. Since the watermark is $10:15 - 10\text{ min} = 10:05$, the previous window `[10:00 - 10:10]` is not yet closed because $10:05 \le 10:10$.

### Tutor reasoning and refinements

Precisely. This distinction separates developers who have merely read the documentation from those who understand execution mechanics:

| Output Mode | When rows are emitted to Sink | Use case |
| :--- | :--- | :--- |
| **Update Mode** | Immediately in each micro-batch if that specific window's aggregate changed. | Dashboards, live metrics, upserts to relational stores or key-value sinks. |
| **Append Mode** | **Only after the window has closed** ($\text{Watermark} > \text{window\_end}$). Rows are emitted once and are immutable. | Cold storage, append-only logs, Delta Lake tables where historical updates are not permitted. |

Because the watermark is currently `10:05`, Spark still allows late arrivals up to `10:05` for the `[10:00 - 10:10]` window. It cannot finalize the count until an event with $\text{event\_time} > 10:20$ arrives, advancing the watermark beyond `10:10`.

**Interview answer:** "In Append mode with aggregations, Spark only emits a row when the window is definitively closed, meaning $\text{Watermark} > \text{window\_end}$. Until the watermark advances past the window boundary, late data could still arrive, so Spark holds the record in the state store."
