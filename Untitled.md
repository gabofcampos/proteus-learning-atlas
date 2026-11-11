# 03 - Checkpoints, Recovery, and Output Modes

### what is checkpointing?
- **definition:** writing metadata and current state information to reliable fault-tolerant storage (ex: HDFS, S3, ADLS) after every micro-batch.
- **why it's critical:** provides end-to-end **fault tolerance**. if a driver or executor crashes, spark uses the checkpoint directory to resume processing exactly where it left off without duplicating or losing data.
- **what gets stored:** 
  - **offsets:** the exact positions read from the source for each micro-batch.
  - **state data:** running aggregation values/state.
  - **metadata:** current query metadata and execution plan.

### how to enable checkpointing (pyspark)
```python
query = df.writeStream \
    .format("delta") \
    .option("checkpointLocation", "s3a://my-bucket/checkpoints/my_query") \
    .outputMode("append") \
    .start()
```
    
### deep dive: output modes

determines _how_ data from the **result table** is written to the **output sink** during each micro-batch trigger:

- **`append` mode (default):**
    
    - **behavior:** only new rows added to the result table since the last batch are written to the sink.
        
    - **use case:** stateless queries (`filter`, `select`) OR stateful windowed aggregations with a watermark defined.
        
    - **rule:** cannot be used on standard aggregations without a watermark (because past rows might still change).
        
- **`complete` mode:**
    
    - **behavior:** the **entire result table** is re-written to the sink on every trigger.
        
    - **use case:** stateful aggregations (ex: global `count()`) where you want the full running total output every time.
        
    - **rule:** requires aggregation; cannot be used on simple stateless queries (writing an infinite log via `complete` is invalid).
        
- **`update` mode:**
    
    - **behavior:** only rows that were **updated or added** in the result table since the last batch are written.
        
    - **use case:** streaming aggregations where downstream sinks (ex: Key-Value stores/Databases) support upserts.
        
    - **rule:** if a query has no aggregations, `update` mode behaves identically to `append` mode.