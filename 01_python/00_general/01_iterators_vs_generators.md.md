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

`yield` controls the flow of a generator function. It returns the function but remembers the state of its local variables as well. The generator returned by `yield` can be assigned to a variable and and iterated through with `next()`. This will execute the function up to the first `yield` keyword it encounters. Once the `yield` keyword is hit, the execution of the function is suspended

### how to create them?

1. using `yield`
2. using **generator comprehension/generator expression**: using an expression using parenthesis to create a lazy iterator:
```python
l = [x for x in range(10)]
g = (x for x in range(10))
```

## when to choose which

**Iterator over generator if a complex state-maintaining behavior is required** or if you wish to expose other methods beyond `__next__()`, `__iter__()`, and `__init__()`. 

On the other hand, **a generator may be preferable when dealing with large sets of data since they do not store their contents in memory** or when it is not necessary to implement an iterator.

**generators are not faster than iterators in raw speed but they are more efficient because they produce values on demand**