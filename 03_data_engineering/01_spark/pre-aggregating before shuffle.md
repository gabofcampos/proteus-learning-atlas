technique to mitigate data skewing.

*example*
```md
partition 1:
US
US
US
ES
US

partition 2:
US
FR
US
US
```
#### How it works
reduce the dataset before the expensive shuffle when semantics allow it.


```md
for an aggregation like
```
```python
df.groupBy("country").count()
```
```md
rather than sending all original dataset rows accross the network, we'd be better off having something like:
 
partition 1:
US -> 4
ES -> 1

partition 2:
US -> 3
FR -> 1

to accomplish that we might do something like:
```
```python
small = ( 
	df
	.select("country", "event_type")
	.groupBy("country", "event_type")
	.count()
	)
```