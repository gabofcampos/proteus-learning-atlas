### what is structured streaming?
framework that allows you to treat a stream of data as an unbounded table.
	`unbounded = no fixed size or end (continuously appended to)` 

- spark sql module → run queries over a table with static data
- spark structured streaming (*SSS*)→ run queries over stream of data that is continuously arriving.
	- sss actually is built on top of spark sql and shares optimizations, executions and api architecture.
	- since sss is built on top, we get seamless integration between the two.

##### how does structured streaming differ from a batch dataframe?
- structured streaming: streams of data keep coming
- batch dataframe: static dataset with a fixed size where everything is there before hand.

### key concepts
- **input table:** every new data item in the stream acts like a new row appended to an unbounded input table
- **result table:** output table updated after evaluating the query on the input table.
- **output sink:** final location where the result table is written (*ex.: kafka, parquet files, console, memory*).

### how is data processed? micro batch engine
==spark structured streaming uses a micro batch processing model==
spark reads only rows from the stream that arrived since the last run so the work is incremental (not a full recompute).

#### minimal workflow
in pyspark
```python
from pyspark.sql import SparkSession
from pyspark.sql.functions import explode, split

spark = SparkSession.builder.appName("StructuredStreamingBasics").getOrCreate()

# stream input source
lines = (
    spark.readStream.format("socket")
    .option("host", "localhost")
    .option("port", 9999)
    .load()
)

# transform
words = lines.select(explode(split(lines.value, " ")).alias("word"))
word_counts = words.groupBy("word").count()

# write stream (sink & trigger)
query = (
    word_counts.writeStream.outputMode("complete")
    .format("console")
    .trigger(processingTime="5 seconds")
    .start()
)

# away Termination
query.awaitTermination()
```

#### concepts
- **what is a micro batch?** 
	short lived, discrete batch job created by the spark streaming engine.
	spark groups all incoming data that arrived over a specific time window and processes it using the standard spark sql engine.

- **what does a each micro-batch process?**
	only the new data it has not yet processed → ***new delta.***
	**how does it know which data it has processed?** → offsets

- **difference between a running query and one micro-batch?**
	+ running query: continuous background process that listens ofr new data until it is stopped (`query. stop()`)
	+ micro batch: single discrete loop that happens repeatedly for that data being streamed (read → transform → write)

- **what is a trigger and what does it control?**
	the timing and frequency of a micro batch execution.
	it determines whether spark runs batches back to back as fast as possible, waits for an interval of time, processes everything at once and stops....

### anatomy of a stream - what makes up a streaming query?
standard three part pipeline: `source → transformations → sink` 
#### source 
`readStream` creates a streaming dataframe that acts as an unbounded input table.
	 *examples of sources:* kafka topics [[kafka fundamentals]], tcp sockets.
#### transformations
- applied the same way using standard spark sql functions [[airport_flight_operations]]
- **what is a stateless transformation?** they operate on each incoming row independently without needing past data.
	 *example:* `filer(col("STATUS") == "CANCELLED")`, `select("id", "timestamp")`
#### sink
writeStream` configures:
- where a stream is written → **the sink**.
- how: `append`, `complete`, `update`.
- the trigger interval: how long between micro batch processing.
- check point location for fault tolerance: where the system will write all checkpoint info (hdfs).
- `start()`: this is what makes the query run on the stream. without it, it is just a plan. Returns a `StreamingQuery`.

##### output models
- **append:** only newly added rows since the last trigger are written out.
	- valid only on queries with no aggregations, or aggregations with watermarks ([[watermarks and late data]]).
- **complete:** the entire updated result table is written out on every trigger.
	- requires an aggregation (cannot be used on simple row-by-row transforms).
- **update:** only rows that changed or were newly added in the result table since the last trigger are written out.
	- if there are no aggregations, behaves similarly to `append`.

## related
- [[kafka fundamentals]]