**what is spark??**
==open source framework for distributed data processing== 

- spark is **fault tolerant**: fault tolerance achieved through the **use of RDDs: Resilient Distributed Datasets.** If a partition of an RDD is lost due to node failure, spark can recompute it using the lineage info stored for each RDD. [[00 spark architecture and topology]]
- spark uses **lazy evaluation**: commands don't get executed right away, a plan is created and runs only when an action explicitly triggers computation.
- spark is **scalable**: data processing runs on nodes, if needed more nodes can be added making it faster and more scalable.

### key features 
1. **in memory computing:** stores intermediate data in memory making data processing much faster than disk based systems.
2. **unified analytics:** spark provides a single platform for batch processing, real-time streaming, ML and interactive queries, reducing the need for multiple tools.
3. **support for multiple languages (polyglot programming):** R, java, python, scala.
4. **built in libraries:** spark sql, spark MLlib, spark graphx, spark structured streaming

### user defined functions and spark

spark provides a framework for distributed processing but UDFs can affect performance bc:
- **serialization:** udfs are executed row by row. each row is serialized and sent to the python process (if pyspark) and then the result gets sent back to the jvm. this adds overhead, unlike native functions which are optimized.
- **lack of optimization:** spark cannot optimize udfs as it has its own fns. (specially problematic with large datasets).

```python
from pyspark.sql.functions import udf  
from pyspark.sql.types import DoubleType  
  
# udf to double the price
def double_price(price): return price * 2  
# register udf 
double_price_udf = udf(double_price, DoubleType())  

df = spark.read.csv("catalog_data.csv")  
df_modiffied = df.withColumn("double_price", double_price_udf(df["price"]))
```

the spark optimized version would be
```python
from pyspark.sql import functions as F

df = spark.read.csv("catalog_data.csv", header=True, inferSchema=True)
df_modified = df.withColumn("double_price", F.col("price") * 2)
```

### how to avoid UDFs
**what happens if native pyspark functions cannot do what you need?**

then the best way to handle this is to use **pandas udfs/vectorized udfs via apache arrow**.

==apache arrow is an in memory columnar data format designed to let diff languages share data instantly without expensive serialization==

when using pandas udf, the process becomes:
1. **batch transfer:** instead of sending data row by row, spark grabs a large batch of rows and converts them into Arrow columnar data structure.
2. **zero copy sharing:** bc arrow format is standarized in memory, python can read it without translation overhead.
3. **vectorized processing in python:** inside the fn, the data arrives not as a row but as a pd.Series or pd.DataFrame which allows for faster vectorized operations rather than looping through the individual rows.

```python
import pandas as pd
from pyspark.sql.functions import pandas_udf
from pyspark.sql.types import DoubleType

# define a pd udf (takes and returns a pd.Series)
@pandas_udf(DoubleType())
def double_price_vectorized(price: pd.Series) -> pd.Series:
    return price * 2

df_modified = df.withColumn("double_price", double_price_vectorized(df["price"]))
```

### how did spark originate?
apache spark is born out of a necessity to tackle the downsides hadoop had in terms of speed and real-time processing capabilities, largely due to its disk intensive mapreduce paradigm.
