
# 5. Spark Concepts

Be able to explain each of these without needing a textbook definition.

## Transformations vs Actions

Examples:

```python
df.filter(...)
df.select(...)
df.groupBy(...)

df.count()
df.collect()
df.write...
```

What is lazy evaluation?

---

## Partitions

Explain:

* What is a Spark partition?
* Why do partitions matter?
* What happens with too few partitions?
* What happens with too many partitions?

---

## Shuffle

What is a shuffle?

Which operations commonly cause one?

Consider:

```text
groupBy
join
distinct
orderBy
repartition
```

Why are shuffles expensive?

---

## Narrow vs Wide Transformations

Explain the difference.

Examples:

```text
filter
map

vs.

groupBy
join
orderBy
```

---

## `repartition()` vs `coalesce()`

Explain when you would use each.

---

## Broadcast Join

When would you broadcast a table?

What problem does it solve?

What happens if the broadcast table is too large?

---

## Data Skew

Imagine one `user_id` represents **30% of all events**.

What happens during:

```python
df.groupBy("user_id").count()
```

How could you identify and mitigate the problem?

---

## Spark Optimization

Be prepared to discuss:

* Predicate pushdown
* Column pruning
* Partition pruning
* Broadcast joins
* Avoiding unnecessary shuffles
* Avoiding `collect()`
* Data skew
* Appropriate partitioning
* Parquet
* Small-file problems
