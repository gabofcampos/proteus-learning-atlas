# 4. PySpark

Assume:

```python
df
```

contains:

```text
event_id pyspark_solutions.py
user_id
event_type
event_timestamp
domain
country
```

## Spark 1 — Filter

Return only booking events.

---

## Spark 2 — Aggregation

Count events by:

```text
country
event_type
```

---

## Spark 3 — Deduplication

Keep the latest row for each `event_id`.

Use a Spark window.

---

## Spark 4 — Top N

Return the **top 3 event types per country**.

## Spark 5 — Join

You have:

```text
events
------
user_id
event_type
event_timestamp

users
-----
user_id
country
segment
```

Join the datasets to enrich each event with the user's country and segment.

What join would you use?

What happens if `users` is very small?
