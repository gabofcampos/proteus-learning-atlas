==dynamic programming (dp) is essentially careful brute force with caching: breaking a problem into overlapping subproblems and storing the answers so you never solve the same state twice (memoization).==

### the basic idea
- if recursion is exploring a decision tree, dp is trimming the tree so you don't recalculate identical branches.
- it turns exponential time $O(2^n)$ into polynomial time (often $O(n)$ or $O(n^2)$) by trading memory for speed.
- two prerequisites:
  1. **optimal substructure:** optimal solution to the problem can be constructed from optimal solutions of its subproblems.
  2. **overlapping subproblems:** the same subproblems are solved again and again.

---

## the 4-step mental framework
whenever you suspect dp, run through these steps in order:

### 1. state definition
what does `dp[i]` (or `dp[i][j]`) actually mean in plain english?
- *example (max number of points with cost):* `dp[r][c]` = max points you can earn from a row r given you pick column c.

### 2. state transition (the recurrence relation)
what choice can you make at the current state?
- *example:* which column `k` from the previous row `r-1` should I transition from?
	`dp[i][j] = dp[i][j] - abs((j-1) - j)`

### 3. base cases & boundaries
what are the simplest states that don't need computation?
- *example:* in the first row, since there is no row above, there is no distance penalization:
	`dp[0][j] = dp[0][j]`

### 4. computation direction & space optimization
- **top-down (memoization):** natural recursion with a cache / `@lru_cache(None)`.
	- start with the big problem and break it down recursively
	- every time you solve a subproblem you cache the answer (lookup table or dict)
	- if the subproblem is needed again you pull it from memory
- **bottom-up (tabulation):** iterative loops filling an array or table.
	- start by solving the smallest subproblem first and save the result
	- use the smaller subproblem answers to build the results to progressively larger subproblems
- **space optimization:** if state only depends on the previous 1 or 2 values, drop the array and use variables ($O(1)$ space).


## gotchas & python traps

- **the 2d array reference trap**
> - `dp = [[0] * cols] * rows` ❌ (duplicates the same row reference in memory; editing one row modifies all rows).
> - `dp = [[0] * cols for _ in range(rows)]` ✅
```python
>>> cols =2  
>>> rows=3  
>>> dp = [[0] * cols ] * rows  
>>> dp1 = [[0] * cols for _ in range(rows)]  
>>> dp[0][1] = 22  
>>> dp1[0][1] = 99  
>>> dp  
[[0, 22], [0, 22], [0, 22]]  
>>> dp1  
[[0, 99], [0, 0], [0, 0]]
```

- **recursion depth limit in top-down:** python's recursion limit defaults to 1000. for deep trees:
```python
import sys
from functools import lru_cache
sys.setrecursionlimit(20000)
 
@lru_cache(maxsize=None)
def dfs(i):
	...
```

- **state compression:** always ask: do i need the full table, or just the previous row / last 2 values?
> turning $O(n)$ space into $O(1)$ space is a very common follow-up question.


## related notes
- [[algorithmic complexity O(N)]] → call stack frames and space-time trade-offs.
## related repos
- [my leetcode repository](https://github.com/gabofcampos/leetcode)
