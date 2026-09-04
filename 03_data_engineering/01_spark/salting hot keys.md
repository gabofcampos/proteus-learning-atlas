technique to mitigate data skewing.

*example*
```md
US, search -> 1.8 billion rows
ES, search -> 120 million rows
FR, click -> 40 million rows
```
#### How it works
1. Add a random suffix: Append a random integer or hash (the "salt") to the overloaded hot key.
```md
US would become -> US_0, US_1, US_2, ..., US_n
```

2. Split the partition: This transforms one massive, congested partition into multiple smaller, balanced sub-partitions.
```python
salted = df.withColumn( "salted_key", (F.rand() * 10).cast("int") )
```

3. Process in parallel: The cluster can now distribute the workload across different executors or nodes.
```python
# what before meant shuffleing only by country and leaving a task to a huge partition
# skewed = ( salted .groupBy("country") .count() )

# now means shuffleing by country and salted key, and having a task to a smaller salted key partition
partial = ( salted .groupBy("country", "salted_key") .count() )
```

4. Aggregate results: After computation, you group or sum the data back together across the sub-keys.
```python
result = ( partial .groupBy("country") .agg(F.sum("count").alias("count")) )
```
