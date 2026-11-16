
- **data warehouse:** data management system to consolidate data from multiple sources in an organized highly structured manner. **very inflexible, expensive and locked in to proprietary systems.**
	- **good for:** structured, tubular data
	- **struggles with:** unstructured data or semi unstructured
	typically used for BI, analytics, data visualization, reporting and prepping data for ML.
	- *examples:* snowflake, databricks, redshift, bigquery, azure synapse analytics.

- **data lake:** flexible repository to store data in it's raw format (**no need to impose a schema**). addresses limitations of warehouse:
	- stores any kind of data (unstructured and semi as well). 
		-  data is ingested without a predefined schema, enabling a **schema-on-read** model where structure is applied only when the data is accessed for analysis. so users are able to apply their own schemas without duplicating or reshaping the underlying data.
	- inexpensive storage
	- raw data can keep its schema without any transformations (*!! could make the data lake a data swamp*)
	- avoid lock in to a proprietary system by decoupling data storage from the engines that process the data
	- *examples:* s3, aws lakeformation, google biglake, databricks deltalake, hadoop hdfs.

### data lakehouse: best of both worlds
==built on data lake to store **all** types of data, it still provides structure, performance and governance of data warehouses==

merging both into a single system means data teams don't need access to a warehouse and a lake and they always have the most complete up to date data available.

- *examples:* snowflake, databricks deltalake, google big lake.


### data intelligence platform: evolution of the data lakehouse
==the integration of the data lakehouse platform with ai automation.==

provides governance and semantic understanding so AI agents can query and act on enterprise data safely, instead of agents being bolted on separately from where the data lives.

### snowflake <!--todo move to separate note-->
can be used as a warehouse  (structured data) and a lakehouse (best of both worlds).
**how?** separates storage layer from compute engine.
originally a warehouse and evolved by adding native support to apache iceberg and unstructured data processing, and multi-language programming environments.

#### snowflake as a data warehouse
sf ingests, optimizes, and manages data internally to deliver fast bi and reporting.
- **managed proprietary storage:** Data is loaded into Snowflake and automatically compressed, encrypted, and organized into micro-partitions for fast SQL query performance.
- **isolated virtual warehouses:** compute clusters scale independently without affecting storage, allowing multiple teams to run heavy BI queries simultaneously without resource contention.
- **built-in governance and ACID compliance:** sf enforces strict schema structures, role-based access control (RBAC), time travel, and full transactional integrity out of the box.
#### snowflake as a lakehouse
to operate as a lakehouse, sf allows you to keep data in your own external cloud storage (like AWS S3, Azure Blob Storage, or Google Cloud Storage) while using sf’s compute engine for analytics, data engineering, and AI.

- **Apache Iceberg Tables:** Snowflake natively supports Apache Iceberg, an open-source table format. You can store data as open Parquet files in your own cloud buckets and read or write to them using Snowflake with near-warehouse performance, avoiding vendor lock-in.
- **External Tables and Data Lake Querying:** You can query raw files (JSON, Parquet, Avro, CSV) sitting directly in external data lakes without moving or ingesting them into Snowflake first.
- **Unstructured Data Support:** Snowflake can store, govern, and process unstructured files such as PDFs, images, audio, and video alongside structured tables.
- **Snowpark for Data Science and AI:** Through Snowpark, data engineers and data scientists can write code in Python, Java, or Scala directly inside Snowflake to build machine learning models and complex data pipelines without exporting data to external Spark clusters.