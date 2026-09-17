---
title: "Databricks Certified Data Engineer Associate: Exam Prep Plan (v2, no Spark assumed)"
exam_guide_version: May 4, 2026
plan_duration: 5 weeks
weekly_hours: 10+
---

# Databricks Certified Data Engineer Associate: 5-Week Prep Plan

Source: official exam guide (May 4, 2026 version), staged at
`03_data_engineering/03_databricks/00_databricks_certified_associate_/`.

**Change from v1:** this version assumes only rusty, masters-level Spark knowledge, with no live DataFrame/PySpark fluency, so it adds a dedicated Spark fundamentals week before touching Databricks-specific content. That pushed the plan from 4 to 5 weeks at the same ~10+ hours/week pace, since roughly half the exam (Sections 2, 3, and 6 total 53% combined) leans on Spark concepts directly, and cramming both a Spark refresher and those sections into the original 4 weeks wasn't realistic. If you'd rather keep it to 4 weeks, the section to compress is week 5 (fold troubleshooting/governance into 4-5 days instead of a full week); just say so and I'll redo it.

## Exam facts

- 45 scored multiple-choice questions, 90 minutes, no test aides.
- $200 registration fee (+ local tax). Online or test center delivery.
- No hard prerequisite, but 6 months hands-on Databricks experience is recommended.
- Valid 2 years; recertify by retaking the live exam.
- Exam may include unscored/experimental items, so don't let an odd question rattle you.

## Section weights (what to spend time on)

| # | Section | Weight |
|---|---------|--------|
| 1 | Databricks Intelligence Platform | 6% |
| 2 | Data Ingestion and Loading | 21% |
| 3 | Data Transformation and Modeling | 22% |
| 4 | Working with Lakeflow Jobs | 16% |
| 5 | Implementing CI/CD | 10% |
| 6 | Troubleshooting, Monitoring, and Optimization | 10% |
| 7 | Governance and Security | 15% |

Sections 2, 3, and 6 (53% combined) all assume you can read and write basic PySpark/SQL and reason about how Spark executes: that's exactly the gap week 1 closes.

## Recommended training (official, from the exam guide)

- Instructor-led: **Data Engineering with Databricks**. Note: this course assumes you already know Spark going in, it does not teach it. See the week 1 training note below for the actual Spark-fundamentals course to take first.
- Self-paced (Databricks Academy):
  - Data Ingestion with Lakeflow Connect
  - Deploy Workloads with Lakeflow Jobs
  - DevOps Essentials for Data Engineering
  - Data Interoperability with Unity Catalog
  - Build Data Pipelines with Lakeflow Spark Declarative Pipeline
  - Get Started with Data Governance on Databricks

## How to use this with the vault

For each topic below, create one atomic note under `03_data_engineering/03_databricks/` (same pattern as `01_spark/`), and link it from an index note in `00_databricks_certified_associate_/`. The week 1 Spark notes actually belong under `03_data_engineering/01_spark/` alongside your existing skew/salting/broadcast-join notes; that's the natural place to rebuild that foundation.

---

## Week 1: Spark fundamentals refresher + Platform basics (underpins 53% of the exam)

Target: ~12-14 hours

This week has no direct exam-outline mapping: it's the foundation Sections 2, 3, and 6 assume you already have. Don't skip it even though it feels like "review"; the goal is to get from *recognize the concept* to *can read and predict what this code does*.

**Concepts**
- Spark architecture: driver, executors, cluster manager; how a job breaks into stages and tasks
- Transformations vs actions, and why Spark is lazy (nothing runs until an action like `.show()`, `.collect()`, `.write()`)
- DataFrame basics: creating DataFrames, inferring/defining schema, `select`, `filter`/`where`, `withColumn`, `groupBy`+`agg`, `orderBy`
- Joins conceptually: inner/left/broadcast, and what each does before worrying about tuning them
- Partitions: what a partition is, how Spark parallelizes across them
- Shuffle: which operations trigger one (`groupBy`, `join`, `repartition`) and why it's the expensive part. This is the concept the Section 3 tuning parameters and the Section 6 "data skew/shuffling/disk spilling" troubleshooting questions are built on
- Reading/writing DataFrames: CSV/JSON/Parquet/Delta formats, and `spark.sql` + temp views for SQL-style queries on DataFrames
- Caching/persistence basics: when and why you'd cache a DataFrame

Then, lighter, Section 1 (Databricks Intelligence Platform, 6%):
- Delta Lake basics: what ACID transactions and time travel actually mean on top of Parquet
- Unity Catalog hierarchy: metastore, catalog, schema, table/volume
- Compute services: all-purpose vs job clusters vs SQL warehouses vs serverless, their characteristics, cost model, and when to use which

**Training to do this week**
- **Correction from earlier draft:** "Data Engineering with Databricks" (the official exam-guide course) actually assumes you already know Spark; it is not where the fundamentals live. The course that actually teaches Spark/PySpark from zero, no prior Spark experience required, is a separate one:
  - **Apache Spark Programming with Databricks** (self-paced version). 16 hours across 4 modules: Spark architecture, the DataFrame API, joins/aggregations/complex types, and an intro to Structured Streaming and Delta Lake optimization. This maps directly onto this week's concept list. Access it via Databricks Academy (create an account at customer-academy.databricks.com if you don't have one through Unit8 already; worth checking with your team first since partner accounts sometimes include free/discounted access). Registration options and current pricing are shown when you go to register, since they vary by account type.
  - Free alternative/supplement: Databricks also offers a **free, self-paced certification overview course** for the Data Engineer Associate exam specifically (new users: catalog DB005a on Databricks Academy). It's lighter than the full Spark course, touching ETL with Spark SQL/Python and incremental processing, so treat it as a quick free primer rather than a replacement for the Spark course above.
- Get Started with Data Governance on Databricks (short, sets vocabulary for later)

**Vault notes to create**
- `03_data_engineering/01_spark/spark architecture (driver executor stages tasks).md`
- `03_data_engineering/01_spark/transformations vs actions and lazy evaluation.md`
- `03_data_engineering/01_spark/dataframe basics (select filter groupby withcolumn).md`
- `03_data_engineering/01_spark/partitions and shuffle.md`: this is the note to write most carefully; it's the prerequisite for both your existing `data skew.md`/`salting hot keys.md` notes and the exam's Section 6 troubleshooting questions
- `03_data_engineering/03_databricks/data lakehouse.md` (already stubbed, fill it in)
- `03_data_engineering/03_databricks/unity catalog basics.md`
- `03_data_engineering/03_databricks/compute types (all-purpose vs job vs sql warehouse vs serverless).md`

**Checkpoint:** without looking anything up, explain out loud why a `groupBy` triggers a shuffle and a `filter` doesn't. If you can't, spend another session on `partitions and shuffle.md` before moving to week 2; everything downstream depends on this.

---

## Week 2: Data Ingestion and Loading (Section 2, 21% of exam)

Target: ~10-12 hours

**Concepts**
- Ingestion patterns: batch, streaming, incremental
- `COPY INTO` for incremental file loads (ADLS/S3/GCS) into Unity Catalog-governed tables
- Auto Loader: schema enforcement + schema evolution, directory listing vs file notification modes
- Lakeflow Connect (standard + managed connectors), JDBC/ODBC/REST ingestion into cloud storage or directly into governed tables
- Choosing between Auto Loader / Lakeflow Connect / partner connectors based on volume, frequency, data types, governance needs
- Ingesting semi-structured/unstructured data (JSON, nested data)

**Training to do this week**
- Data Interoperability with Unity Catalog
- Data Ingestion with Lakeflow Connect

**Vault notes to create**
- `03_data_engineering/03_databricks/auto loader.md`
- `03_data_engineering/03_databricks/copy into.md`
- `03_data_engineering/03_databricks/lakeflow connect.md`
- `03_data_engineering/03_databricks/ingestion pattern decision guide (batch vs streaming vs incremental).md`

**Checkpoint:** answer sample Question 3 from the exam guide (audit log ingestion) from memory before checking the answer key.

---

## Week 3: Data Transformation and Modeling (Section 3, 22% of exam, the biggest section)

Target: ~12-14 hours

With week 1's Spark foundation in place, this week is about the Databricks-specific layer on top of it, plus deliberate PySpark/SQL practice, not learning the syntax cold.

**Concepts**
- Medallion architecture in practice: bronze to silver cleaning (PySpark/SQL, null handling, type standardization)
- Applying week 1's join types to real cleaning tasks: multi-key joins, cross join, union/union all
- Column/row/table manipulation in practice: add/drop/split/rename columns, filters, exploding arrays
- Deduplication and aggregates: count, approx_count_distinct, mean, summary stats
- Core tuning knobs, now meaningful because you understand shuffle from week 1: `spark.sql.shuffle.partitions`, `spark.default.parallelism`, executor/driver memory, `spark.sql.autoBroadcastJoinThreshold`, and how to re-measure after changing them
- Gold layer objects: materialized views vs views vs streaming tables vs plain tables, and when each is right for BI/analytics consumers in Unity Catalog
- Data quality checks and validation rules for silver/gold reliability

**Training to do this week**
- Data Engineering with Databricks (continue: this is the core course, covers most of this section)
- Build Data Pipelines with Lakeflow Spark Declarative Pipeline

**Vault notes to create**
- `03_data_engineering/03_databricks/medallion architecture (bronze silver gold).md`
- `03_data_engineering/03_databricks/gold layer objects (materialized view vs view vs streaming table).md`
- `03_data_engineering/01_spark/spark tuning parameters (shuffle partitions, broadcast threshold, parallelism).md`: cross-link to your existing `data skew.md`, `salting hot keys.md`, `pre-aggregating before shuffle.md`
- `03_data_engineering/03_databricks/data quality checks and validation.md`

**Checkpoint:** answer sample Question 1 (data skew/shuffle diagnosis). If week 1 landed, this should now feel approachable rather than opaque.

---

## Week 4: Lakeflow Jobs + CI/CD (Sections 4 & 5, 26% of exam)

Target: ~10-12 hours

This week is mostly Databricks tooling knowledge rather than Spark concepts, so it should feel like a change of pace from weeks 1-3.

**Concepts**
- Lakeflow Jobs: control flow (retries, conditional branching, looping), task types (notebook, SQL query, dashboard, pipeline), DAG-based dependencies
- Job triggers: scheduled, file arrival, table update, and choosing time-based vs data-driven triggers
- Databricks Git Folders (formerly Repos): branching, commits, pushes, pull requests from within the workspace
- Automation Bundles (formerly Databricks Asset Bundles): environment-specific config (dev/test/prod), variables and overrides
- Deploying bundles to package Lakeflow Jobs, Spark Declarative Pipelines, and other workspace assets across environments
- Databricks CLI for validating/deploying/managing bundles in automated CI/CD

**Training to do this week**
- Deploy Workloads with Lakeflow Jobs
- DevOps Essentials for Data Engineering

**Vault notes to create**
- `03_data_engineering/03_databricks/lakeflow jobs (dag, triggers, control flow).md`
- `03_data_engineering/03_databricks/databricks git folders.md`
- `03_data_engineering/03_databricks/automation bundles (dabs) and cicd.md`
- `03_data_engineering/03_databricks/databricks cli.md`

**Checkpoint:** answer sample Question 5 (DABs/CI-CD) cold, then check against the answer key.

---

## Week 5: Troubleshooting/Monitoring/Optimization + Governance/Security, then full review (Sections 6 & 7, 25% of exam)

Target: ~10-12 hours study + 2-3 hours of practice exams

**Concepts**
- Lakeflow Jobs run history: comparing current vs historical execution times
- Reading the Jobs UI for pipeline health: statuses, DAG task graphs, failure rates
- Spark UI stage-level metrics: spotting skew, shuffling, disk spilling. This is where week 1's `partitions and shuffle.md` pays off directly
- Liquid Clustering and predictive optimization
- Diagnosing cluster startup failures, library conflicts, OOM issues
- Unity Catalog: managed vs external tables, create/modify/delete/convert operations
- Access control: GRANT/REVOKE/DENY via UI and SQL, principals (users, groups, service principals)
- Column-level masking and row-level security
- Unity Catalog ABAC policies for centralized row filtering / column masking

**Training to do this week**
- Finish Data Engineering with Databricks if not already complete
- Get Started with Data Governance on Databricks (revisit deeper this time)

**Vault notes to create**
- `03_data_engineering/03_databricks/liquid clustering and predictive optimization.md`
- `03_data_engineering/03_databricks/unity catalog managed vs external tables.md`
- `03_data_engineering/03_databricks/unity catalog access control (grant revoke deny, row column security, abac).md`
- `03_data_engineering/03_databricks/troubleshooting cluster startup and oom.md`

**Days 1-4: last new content.** Days 5-7: full review + practice.

**Practice test schedule**
- Day 29-30: first full practice run using retired sample-question style (all 5 from the exam guide, timed, no notes); identify weakest section by score.
- Day 31-32: targeted re-study of your two weakest sections only.
- Day 33: second timed practice pass covering all 7 sections proportionally to their weight (roughly 1 question per 2.2% weight if simulating 45 questions).
- Day 34: light review only: skim your atomic notes and the exam guide outline, no new material.
- Day 35: exam day.

Register for the actual exam slot around day 24-26 once week 4 is underway, so you have a firm date pulling the final review days into focus.

---

## Weekly time budget summary

| Week | Focus | Hours |
|------|-------|-------|
| 1 | Spark fundamentals + Platform basics | 12-14 |
| 2 | Data Ingestion and Loading | 10-12 |
| 3 | Data Transformation & Modeling | 12-14 |
| 4 | Lakeflow Jobs + CI/CD | 10-12 |
| 5 | Troubleshooting + Governance + full review/practice | 10-12 + 2-3 practice |

Total: ~55-64 hours over 5 weeks, matching a 10+ hour/week pace with the added Spark foundation.

## Final pre-exam checklist

- [ ] Can explain shuffle, partitions, and lazy evaluation without notes
- [ ] All 7 section atomic notes created and linked from an index note
- [ ] Both practice runs scored and reviewed
- [ ] Weakest section re-studied after first practice run
- [ ] Exam slot booked (online or test center)
- [ ] Reviewed all 5 sample questions + answers from the official guide without looking
