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

## user defined functions and spark

spark provides a framework for distributed processing but UDFs can affect performance bc:
- **serialization:** udfs are executed row by row. each row is serialized and sent to the python process (if pyspark). this adds overhead, unlike native functions which are optimized.
- **lack of optimization:** spark cannot optimize udfs as it has its own fns. (specially problematic with large datasets).

### how did spark originate?
apache spark is born out of a necessity to tackle the downsides hadoop had in terms of speed and real-time processing capabilities, largely due to its disk intensive mapreduce paradigm.
