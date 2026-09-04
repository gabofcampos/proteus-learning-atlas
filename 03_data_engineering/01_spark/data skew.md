term used in distributed systems to refer to the phenomena under which for a chosen partitioning key there is significantly more data for a single key than for the rest.

```md
US, search -> 1.8 billion rows
ES, search -> 120 million rows
FR, click -> 40 million rows
```

in the above case, our data is significantly skewed towards US. 

## the issue?
when grouping this could cause the task handling that partition to be far slower than the rest. The task will become a **straggler**.

## how to mitigate this?
- rethink partitioning keys
- salting hot keys
- pre-aggregating before shuffle
- using skew aware join/aggregation techniques