window functions allow us to perform operations over a set of rows, returning results for individual rows.

### types of window fns

#### analytical fns
they return a value for each row in the group based on a group of rows defined by the window.
##### examples
```python
from pyspark.sql.window import Window
windowPartition = Window.partitionBy("Department").orderBy("Age")
```

-  `lead()`: used to access next rows' data as per the defined offset value given to the fn
```python
df.withColumn("lead", lead("salary", 2).over(windowPartition)).show()
```
- `lag()`: used to access previous rows' data as per the defined offset value given to the fn
- `cume_dist()`: cumulative distribution within a window partition

#### ranking fns
they assign a row number or rank to each of the rows in the partition based on the order defined by the window

```python
from pyspark.sql.window import Window
windowPartition = Window.partitionBy("origin").orderBy("depart_time")
```
##### **examples**
-  `row_number()`: assigns sequential row numbers to each row in the group based on given order
```python
df.withColumn("departure_order", row_number().over(windowPartition))
```
- `rank()`: gives ranks to rows in a partition and **skips rank number after a tie.**
```python
df.withColumn("departure_order", rank().over(windowPartition))
```
- `dense_rank()`: gives ranks to rows in a partition and **DOES NOT skip rank numberS after a tie.**
- `percent_rank()`: returns normalized rank between 0 and 1 based on row position within a partition.
```md
+------+-----------+--------+
|origin|depart_time|pct_rank|
+------+-----------+--------+
|   JFK|        800|     0.0|
|   JFK|        900|     0.5|
|   JFK|       1000|     1.0|
|   LAX|        700|     0.0|
|   LAX|       1100|     1.0|
+------+-----------+--------+
```

#### aggregate fns 
they perform calculations on a group of rows to produce a single summary value

```python
data = [ 
	("JFK", 900, 123),
	("JFK", 800, 167),
	("JFK", 1000, 77),
	("LAX", 1100, 232),
	("LAX", 700, 200)
]
df = spark.createDataFrame(
	data, 
	schema=["origin", "depart_time", "flight_occupancy"]
)
```
##### examples
```python
from pyspark.sql.window import Window
from pyspark.sql.functions import col, avg, sum, min, max, row_number 

windowPartitionAgg  = Window.partitionBy("origin").orderBy(depart_time)
df.withColumn("avg", avg(col("flight_occupancy")).over(windowPartitionAgg))
  .withColumn("sum", sum(col("flight_occupancy")).over(windowPartitionAgg))
  .withColumn("min", min(col("flight_occupancy")).over(windowPartitionAgg))
  .withColumn("max", max(col("flight_occupancy")).over(windowPartitionAgg)).show()
```
- `avg()`
- `sum()`
- `min()`
- `max()`

### traps and gotchas

###### what happens under the hood when you omit `.partitionBy` in a window specification?
partitionby let's spark know which records to shuffle accross to different nodes in accordance to the key. 
If no partitionby key is given, **spark is forced to shuffle all rows across the entire cluster into a single partition on a single executor to compute a global sort.** at production scale, this eliminates all parallelism and frequently causes OOM.

###### why is `rowsBetween` preferred over `rangeBetween` for running totals?
- `rowsBetween`: operates on exact row offsets (physical position).
- `rangeBetween`: operates on value ranges of the ordering column (logical values).
if two rows have the exact same timestamp,  `rangebetween` would aggregate them together rather than giving  a strictly progressive accumulation.

###### deterministic deduplication: `dropDuplicates()` vs `row_number()`
in a distributed cluster, `df.dropDuplicates(["flight_id"])` is **non-deterministic** regarding *which* row is kept. Data lives across multiple partitions on different machines, so whichever record happens to arrive first over the network shuffle is preserved.

If you have duplicate records with conflicting timestamps or statuses, `dropDuplicates()` gives you unpredictable results on every run.

**the solution:** use `row_number()` over a window ordered by your criteria (e.g., `updated_at DESC` or `event_time ASC`) and filter for row 1:

```python
from pyspark.sql.window import Window
from pyspark.sql.functions import col, row_number

window_spec = Window.partitionBy("flight_id").orderBy(col("updated_at").desc())

df_deterministic = (
    df.withColumn("row_num", row_number().over(window_spec))
      .filter(col("row_num") == 1)
      .drop("row_num")
)
```

### related
- [[00_spark_basics]]
- 