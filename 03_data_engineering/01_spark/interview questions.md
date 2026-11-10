### your PySpark job suddenly takes 2 hours instead of 20 minutes. What do you check?

When a job suddenly regresses from 20 minutes to 2 hours, my first instinct is to look at what changed, not just the code.

open spark UI and look at the stage view to find the bottleneck
1. compare the task duration distribution:
	if one task takes an hour and the rest finish in minutes → **DATA SKEW ISSUE**( [[data skew]]) → check new hot key in the source data
		***sol.:*** salting or AQE.
2. check the shuffle read write metrics to see if shuffle volume has increased → this would point to a change in data vol. or a shift in query exec. plan.
3. check SQL tab to see if catalyst optimizer has chosen a different join strategy (SMJ vs BHJ)
		***sol.:*** update statistics with `ANALYZE TABLE`
4. check executor tab to see if cluster size or autoscaling behaviour has changed or if executors are being lost due to OOM
5. check input data 
	1. → has vol. changed?
	2. → has format changed?
	3. → has an upstream pipeline changed partitioning? (more smaller files) 
		***sol.:*** compact small files
6. resources → has another heavy job run on the same cluster?
		***sol.:*** scale cluster


### source sends duplicate data, how do you prevent duplicates?
	
**design idempotent pipeline**

use `upsert` operation:
	1. if matching record by key exists → update record
	2. if no matching record exists → insert new record

`upsert` in:
1. **snowflake** - native using `MERGE` statement.
```sql
MERGE INTO target_table AS target
USING source_table AS source
    ON target.id = source.id

-- update when a match is found
WHEN MATCHED THEN
    UPDATE SET
        target.name = source.name,
        target.updated_at = source.updated_at

-- insert when no match exists
WHEN NOT MATCHED THEN
    INSERT (user_id, name, updated_at)
    VALUES (source.user_id, source.name, source.updated_at);
```
2. **pyspark**-  require a table format that supports ACID transactions (*atomicity, consistency, isolation, durability*) such as **Delta Lake** (standard in Databricks) or **Apache Iceberg**. 
> [!WARNING] Standard Parquet or CSV files in Spark do not support native row-level updates.

because native Spark DataFrames are immutable, the standard way to run an upsert in PySpark is via the `DeltaTable` API.
```python
from delta.tables import DeltaTable
from pyspark.sql import SparkSession

spark = SparkSession.builder.appName("upsert_example").getOrCreate()

# load tables
target_table = DeltaTable.forPath(spark, "/path/to/target_delta_table")
updates_df = spark.read.parquet("/path/to/new_data")

# execute the upsert
(
    target_table.alias("target")
    .merge(updates_df.alias("source"), "target.id = source.id")
    .whenMatchedUpdate(
        set={"name": "source.name", "updated_at": "source.updated_at"}
    )
    .whenNotMatchedInsert(
        values={
            "user_id": "source.user_id",
            "name": "source.name",
            "updated_at": "source.updated_at",
        }
    )
    .execute()
)
```
## related
- [[00_spark_basics]]