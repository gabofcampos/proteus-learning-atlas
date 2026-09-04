- `collect` brings all rows in a df to the driver as a python list
	***!!** if very large dataset will make driver collapse.*
- `take(n)` grabs first n rows without triggering a full df shuffle
	***!!** use instead of `collect` for subset inspection.*
- `show(n)` action to show data in tabular format.
- `head(n)` grabs first n rows with
	***!!** only use if small data as it is loaded into driver.*