`WHERE` filters rows before aggregation.
`HAVING` filters the rows produced after aggregation (ex.: `COUNT()`).
	 although `HAVING` is mostly used along with `GROUP BY` , it is not mandatory for a `group by` to be in the statement.
	 `having` can be used to return an aggregation of a single row (metric, kpi) iff it meets a condition.

```sql 
SELECT 
	AVG(rental_price) as avg_price
FROM 
	rentals
HAVING 
	AVG(rental_price) > 2800;
```