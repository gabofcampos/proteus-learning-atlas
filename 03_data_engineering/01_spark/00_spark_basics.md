**what is spark??**

- spark is **fault tolerant**: fault tolerance achieved through the **use of RDDs: Resilient Distributed Datasets.** If a partition of an RDD is lost due to node failure, spark can recompute it using the lineage info stored for each RDD.
- spark uses **lazy evaluation**: commands don't get executed right away, a plan is created and runs only when an action explicitly triggers computation.

### key features 
1. **in memory computing:** stores intermediate data in memory making data processing much faster than disk based systems.
2. **unified analytics:** spark provides a single platform for batch processing, real-time streaming, ML and interactive queries, reducing the need for multiple tools.
3. **support for multiple languages (polyglot programming):** R, java, python, scala.
4. **built in libraries:** spark sql, spark MLlib, spark graphx, spark structured streaming

### advanced DAG execution graph
under the hood, apache uses a Directed Acyclic Graph to represent the data processing workflow.

==a DAG represents the transformations an RDD goes through.==

#### how does it work?
when a user submits a spark application, the system constructs a DAG (stages + tasks).
then the DAG scheduler divides the DAG into stages, each containing multiple tasks that can be executed in parallel.
**this allows spark to optimize complex chains of operations and improve performance.**

### RDDs
**spark's fundamental data structure**
==immutable collections of objects that can be distributed across a cluster==

RDDs can be created from data in storage (HDFS or S3) or from exiting RDDs through transformations.

RDDs support fault tolerance by tracking lineage information, allowing spark to recompute lost partitions if necessary.

### how did spark originate?
apache spark is born out of a necessity to tackle the downsides hadoop had in terms of speed and real-time processing capabilities, largely due to its disk intensive mapreduce paradigm.
