### event time vs. processing time
- **event time:** the time when the event *actually occurred* on the device or source (embedded in the data record, *ex: flight departure timestamp*). **(use this for business logic)**.
- **processing time:** the local system time of the spark cluster node when the event *is processed* by the stream.
- **why it matters:** networks lag, devices go offline, and data arrives out of order. 
	relying on processing time gives incorrect analytics → **event time ensures accuracy regardless of when data arrives.**

### window types
when grouping streaming data over time, spark uses two main windowing functions:
- **tumbling windows (non-overlapping):** fixed-size, consecutive time blocks. 
	**every event belongs to exactly *one* window.**
	*example:* 10-minute tumbling window $\rightarrow$ `[00:00-00:10)`, `[00:10-00:20)`, ... 

- **sliding windows (overlapping):** fixed-size windows that move forward by a specified slide duration.
	*example:* 10-minute window sliding every 5 minutes $\rightarrow$ an event at `00:04` falls into *both* the `[23:55-00:05)` and `[00:00-00:10)` windows.

### code example: windowed aggregation (pyspark)
```python
from pyspark.sql.functions import window, col

# dfflight_id, action, event_time (TimestampType)
windowed_counts = df \
    .groupBy(
        window(col("event_time"), "10 minutes", "5 minutes"), # 10 min window, sliding every 5 min
        col("device_id")
    ).count()
```


### stateful computations
if stateless computations means rows can be transformed independently without any additional info from other rows →

**stateful computations means computations need and maintain information for a micro batch across multiple micro-batches**

#### why windowing needs state
if a 10 min sliding window spans across several micro-batches, spark cannot forget what happened to the events in all the micro batches so partial aggregation results need to be stored in state memory until the window closes.

> [!warning] the state grows indefinitely unless you manage it
## related
- [[structured streaming basics]]