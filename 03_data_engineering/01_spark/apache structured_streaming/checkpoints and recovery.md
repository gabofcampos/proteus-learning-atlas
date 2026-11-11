at [[event time windows and state]] in the sink section we saw we could add checkpoints.

==checkpoints are metadata we write after every micro batch with state information for reliable recovery (fault tolerance).==
	where? hdfs, s3, ...

**why is it so important?** checkmarks provide fault tolerance. if a driver or executor crashes spark uses the checkpoint directory to resume processing exactly where it left off without duplicating or losing data

**what gets stored:**
- **offsets:** positions read from the source for each micro batch
- **state data:** running aggregation values/state.
- **metadata:** current query metadata and execution plan.

### how to enable checkpointing
```python
query = df.writeStream
    .format("delta")
    .option("checkpointLocation", "s3a://my-bucket/checkpoints/my_query")
    .outputMode("append")
    .start()
```