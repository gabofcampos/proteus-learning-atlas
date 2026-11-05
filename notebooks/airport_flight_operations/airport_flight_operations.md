## notebook

[[flight_operations_spark_basics.ipynb]]

## what am I building?
a PySpark data transformation and aggregation pipeline analyzing airport flight departure events.

## why?
hands-on practice to solidify spark fundamentals:
1. revisiting pyspark df APIs (`withColumn`, `when`, `filter`, `groupBy`, `agg`).
2. distinguishing **narrow transformations** (pipelined in-memory) from **wide transformations** (triggering shuffles).
3. Learning how to read and interpret execution plans with `.explain()`.

---

## tasks I need to solve

### 1. calculate delays & status (narrow transformations)
- derive `delay_minutes`: difference in minutes between `actual_dep` and `scheduled_dep`.
- derive flight `status`:
  - if `actual_dep` is null $\rightarrow$ `"CANCELLED"`
  - if `delay_minutes` > 15 $\rightarrow$ `"DELAYED"`
  - otherwise $\rightarrow$ `"ON_TIME"`
- *concept check:* are these transformations narrow or wide? does any shuffle occur here?

### 2. aggregate delay metrics by airline (wide transformation)
- Filter out cancelled flights.
- Group by `airline`.
- Compute:
  - `total_flights`: total non-cancelled flights.
  - `delayed_flights`: count of flights where status is `"DELAYED"`.
  - `avg_delay_min`: average delay in minutes (rounded to 1 decimal place).
- Order the results descending by `avg_delay_min`.

### 3. execution plan inspection (`.explain()`)
- Call `.explain()` on the final aggregated DataFrame.
- Identify where the physical plan executes narrow operations (`Filter`, `Project`) vs. where the `Exchange` (shuffle) occurs.
- Understand how Spark breaks this DAG into stages.


## concepts
- [[00_spark_basics]]
- [[00 spark architecture and topology]]
- [[data skew]]
