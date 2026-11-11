
### late data
==data that arrives at the processing engine AFTER the time window it belongs to.==

**why does this happen?** network partitions, offline systems, system delays...
**the problem:** if data can arrive after their window has passed, this would mean we might need to keep the state open forever and this would cause an OOM. 
	[[event time windows and state]]

	we need a way to define how long a state to wait for late data before closing or dropping it and clearing it → **watermarks!!**
### watermarks
==mechanism to tell spark how long to wait for late data to arrive before dropping it and clearing the state==

**how does it work?**
	spark tracks the maximum event time seen so far → `max_event_time`
	 it subtracts the specified delay threshold → `max_event_time - threshold`
	 **any data older than that is ignored.**

```python
from pyspark.sql.functions import window, col

watermarked = df
	.withWatermark("event_time", "10 minutes")
	.groupBy(
		window(col("event_time"), "5 minutes"),
		col("device_id")
	).count()
```

| event_id | device_id | event_time | notest                                                                      |
| -------- | --------- | ---------- | --------------------------------------------------------------------------- |
| e1       | device_A  | 10:01:00   | on time                                                                     |
| e2       | device_A  | 10:03:30   | on time                                                                     |
| e3       | device_A  | 10:06:15   | on ime                                                                      |
| e4       | device_A  | 09:45:00   | late, current max event is past 10:00 so the 10 minute watermark drops this |

| window (start, end)    | device_id | count | notes                     |
| ---------------------- | --------- | ----- | ------------------------- |
| `[10:00:00, 10:05:00)` | device_A  | 2     | captured events e1 and e2 |
| `[10:05:00, 10:10:00)` | device_A  | 1     | captured event e3         |
