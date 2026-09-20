
# 3. Python Coding

## Python 1 — Event Counts

Given:

```python
events = [
    {"user_id": "u1", "event_type": "search"},
    {"user_id": "u1", "event_type": "click"},
    {"user_id": "u2", "event_type": "search"},
    {"user_id": "u1", "event_type": "search"},
]
```

Return the number of events of each type.

Expected result:

```python
{
    "search": 3,
    "click": 1
}
```

Do it first without external libraries.

---

## Python 2 — Grouping

Using the same input, group event types by user.

Expected result:

```python
{
    "u1": ["search", "click", "search"],
    "u2": ["search"]
}
```

---

## Python 3 — Deduplication

Given a list of event dictionaries containing:

```text
event_id
event_timestamp
payload
```

the same `event_id` may occur multiple times.

Return only the **latest version of each event**.

---

## Python 4 — Generator

Imagine you're reading a huge event file.

Write a generator that yields only events where:

```python
event["event_type"] == "booking"
```

Be prepared to explain why a generator could be preferable to returning a list.

---

## Python 5 — Memory

Explain the differences between:

```python
list
tuple
set
dict
```

Consider:

* mutability
* ordering
* duplicates
* lookup complexity
* appropriate use cases

---

## Python 6 — Iterator vs Generator

Explain:

* What is an iterable?
* What is an iterator?
* What is a generator?
* What does `yield` do?
* Why are generators useful when processing large datasets?

---

## Python 7 — Shallow vs Deep Copy

Given:

```python
a = [[1, 2], [3, 4]]
b = a.copy()

b[0].append(5)
```

What happens to `a`?

Explain why.

How would `copy.deepcopy()` change the behaviour?
