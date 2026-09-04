technique to mitigate data skewing.

> **when to use:** useful for joins

*example*: 
```python
events.join(users, "user_id")
```
```md
running a join like that, when having a `user_id` that appears hundreds of millions of times, might overload that one partition.
```
#### Solution
1. If the users table is small, the simplest solution is to broadcast join. That way, Spark sends the user table to every executor instead of shuffling both datasets by `user_id`.
```python
result = events.join( broadcast(users), "user_id" )
```

2. Modern Spark can also use **Adaptive Query Execution (AQE)** to detect skewed shuffle partitions at runtime and split them into smaller pieces so one task does not become a straggler.

