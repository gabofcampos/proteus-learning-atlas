> context managers allow you to allocate and free up resources precisely when you want to.

most common use is the `with` statement:
```python
with open('path_to_file.md', 'w') as file:
	file.write('epa!')
```

the equivalent of the above lines without the `with` statement is way lengthier and would require a `try` + `finally` sequence to match the closing of the file done by the context manager in the example.

**a common use of context managers is locking and unlocking resources and closing opened files**

### how to implement a context manager class

the minimum requirement for a class to be a context manager is it containing:

```python
class SomeCMClass:
    def __init__(self):
        # self.file = open(file_path, 'w')
        self._connection = sqlite3.connect(db_path)
    
    def __enter__(self) -> SomeCMClass:
        return self
    
    def __exit__(self, exc_type, exc_value, traceback):
	    # self.file.close()
        self.close()
```

by defining a class with `__enter__` and `__exit__` we can use it with a `with` statement.

#### how does this work?
1. the `with` statement stores the `__exit__` method of the class
2. it calls the `__enter__` of the class and returns it
3. the object is passed to the with statement as the named variable and the block does whatever is stated
4. then the `with` calls the `__exit__` method 

#### how does the `__exit__` work?
if at any point the statement raises an exception, the exception is passed on to the `__exit__` method passing the type, the value and the traceback.