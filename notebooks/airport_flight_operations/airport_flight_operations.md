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

### 4. string formatting, derived metrics & SQL 'HAVING' equivalent
- In `df_flights_delayed`:
  - derive `route`: formatted string as `"MAD -> LHR"` from `origin` and `destination`.
  - derive `airline_code`: extract the 2-letter airline code prefix from `flight_id` (e.g., `"IB"`, `"BA"`, `"LH"`).
- In `flights_not_cancelled_stats`:
  - add `delayed_pct`: percentage of flights delayed out of total flights, rounded to 1 decimal place (`delayed_flights / total_flights * 100`).
  - filter out airlines with fewer than 2 total flights (PySpark equivalent to SQL `HAVING total_flights >= 2`).

### 5. compound boolean filters, null handling & deduplication
- Working with a dirty batch of radar updates:
  - impute missing `airline` values with `"UNKNOWN"` using `F.coalesce` or `.fillna()`.
  - filter flights matching: (`origin == "MAD"` AND `delay_minutes > 15`) OR (`destination == "JFK"`). Notice parentheses and bitwise `&` / `|` syntax.
  - deduplicate by `flight_id` using `.dropDuplicates()`.

### 6. pivoting / cross-tabulation
- Find the count of flights operated by each airline per `origin` airport (`origin` as rows, `airline` as columns).
- Replace any resulting `NULL` counts with `0`.
- *Concept check:* Why is `.pivot()` expensive on high-cardinality columns?

### 7. joins & broadcast optimization (`.explain()`)
- Join `df_flights_delayed` with static metadata `df_airports` on `origin == iata_code`.
- Inspect default physical execution plan with `.explain(mode="formatted")`.
- Disable auto-broadcasting (`spark.sql.autoBroadcastJoinThreshold = -1`) and compare SortMergeJoin / Exchange vs BroadcastHashJoin.

### 8. window functions (ranking & running totals)
- Rank non-cancelled flights by `delay_minutes` descending within each `airline` to isolate the worst flight.
- Calculate running cumulative delay minutes throughout the day per origin airport using `rowsBetween(Window.unboundedPreceding, Window.currentRow)`.

## concepts
- [[00_spark_basics]]
- [[00 spark architecture and topology]]
- [[join strategies]]
- [[data skew]]
