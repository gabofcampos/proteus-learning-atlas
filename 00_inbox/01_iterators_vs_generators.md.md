- Iterators: objectos to iterate upon. For looping and list comprehensions.

## iterators
- follow iteration protocol
- Need a way to track the **iterators' state** and raise a `StopIteration`.
- `__iter__()` : converts iterable to iterator
- `__next__()` : returns next item in iterator

### but what actually is an iterator ?
- data structures: lists, tuples, sets, strings and dictionaries are all considered iterables.
> **rule of thumb:** if you can think of iterated over in a for loop as an iterable.
	**Iterables produce an iterator only once it is iterated on.**

```python
iterable = [1, 2, 3, 4] # type list

iter(iterable) # type: list iterator
```

- multiple iterators instanciated from the same source object will keep separate iterator states. **They are lazy in nature: even if an iterator is created they don't yield an item until requested.** 

## generators
- function that returns an iterator object with a sequence of values
- `yield`: returns generator object  

> **a generator object does not return items, it uses yield to generate items on the spot**
