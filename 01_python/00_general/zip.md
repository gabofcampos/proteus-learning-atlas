==`zip()` takes multiple iterables and aggregates their elements into an iterator of tuples, pairing corresponding items at each index.==

- `zip()` runs through iterables in parallel, yielding tuples `(item1, item2, ...)`.
- **lazy evaluation:**  `zip()` returns an **iterator** (not a list). It generates pairs on the fly without loading all combinations into memory ($O(1)$ auxiliary space).
- ties directly into the iteration protocol → see [[iterators vs generators]].

```python
names = ["Alice", "Bob", "Charlie"]
scores = [85, 92, 78]

for name, score in zip(names, scores):
    print(f"{name}: {score}")
```

## common patterns

### 1. building dictionaries from parallel lists
```python
keys = ["id", "name", "role"]
values = [101, "Gabriel", "Data Engineer"]

user = dict(zip(keys, values))
# {'id': 101, 'name': 'Gabriel', 'role': 'Data Engineer'}
```

### 2. unzipping / unpacking with `*`
Passing the unpack operator `*` to `zip` inverts the process (transposing rows into columns):
```python
pairs = [(1, "a"), (2, "b"), (3, "c")]
nums, chars = zip(*pairs)

# nums  -> (1, 2, 3)
# chars -> ('a', 'b', 'c')
```

### 3. transposing a 2D matrix
```python
matrix = [
    [1, 2, 3],
    [4, 5, 6]
]
transposed = [list(col) for col in zip(*matrix)]
# [[1, 4], [2, 5], [3, 6]]
```

---

## handling unequal lengths
> by default, **`zip()` terminates at the shortest iterable** and silently discards trailing elements from longer ones.

### option A: catch bugs with `strict=True` (Python 3.10+)
If you expect datasets or columns to match exactly, use `strict=True` so silent data truncation raises an immediate error:
```python
ids = [1, 2, 3, 4]
names = ["Alice", "Bob"]

# ValueError: zip() argument 2 is shorter than argument 1
list(zip(ids, names, strict=True))
```

### option B: keep all items with `itertools.zip_longest`
When you need to preserve longer iterables, pad missing items with a fallback:
```python
from itertools import zip_longest

list(zip_longest(ids, names, fillvalue="N/A"))
# [(1, 'Alice'), (2, 'Bob'), (3, 'N/A'), (4, 'N/A')]
```

---

## traps & gotchas

> **trap 1: the one-shot iterator**
> Because `zip()` returns a generator/iterator, **it can only be consumed once**. 
> ```python
> z = zip([1, 2], ["a", "b"])
> print(list(z))  # [(1, 'a'), (2, 'b')]
> print(list(z))  # [] -> empty! It is now exhausted.
> ```
> If you need to iterate multiple times, convert it to a `list(zip(...))` or `tuple(zip(...))`.

> **trap 2: silent truncation without `strict=True`**
> In data pipelines, iterating over two columns or streams of mismatched lengths without `strict=True` leads to dropped rows without any warning or exception.

---

## complexity & connections
- **Time Complexity:** $O(\min(len_1, len_2, ...))$ → stops as soon as the shortest iterable ends.
- **Space Complexity:** $O(1)$ auxiliary memory since it yields tuples lazily.

## related notes
- [[iterators vs generators]] → details how iterators maintain internal state and `StopIteration`
- [[time and space complexity (Big-O)]] → time & space trade-offs.
