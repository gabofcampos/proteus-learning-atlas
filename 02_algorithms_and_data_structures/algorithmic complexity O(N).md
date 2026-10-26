==Algorithmic complexity measures how the runtime or memory consumption of an algorithm scales as the input size ($n$) grows.==

### the basic idea
- it does **not** measure wall-clock execution time (secs or msecs), because hardware, CPU load, and programming language details vary.
- it measures the **rate of growth**: how many fundamental operations (or memory allocations) are performed relative to the size of the input $n$.
- As $n$ grows huge, constants and minor terms become negligible: only the dominant growth rate matters.

---

## asymptotic notation: the Big-O family

In formal computer science, there are three main bounds:
- **Big-O** (_O_) **→ worst case (upper bound):** the alg will never perform worse than this.
- **Big-$\Omega$** (_omega_) **→ best case (lower bound):** the absolute minimum work needed (e.g., finding an element on the very first try in an unsorted list is $\Omega(1)$).
- **Big-$\Theta$** (_theta_) **→ tight bound:** the alg behaves exactly in this range for both best and worst cases (or average).

## rules for calculating O

core simplification rules:
### 1. drop constants
multiplicative and additive constants don't change the growth curve.
- $O(2n) \rightarrow O(n)$
- $O(500) \rightarrow O(1)$
- $O(\frac{n}{2}) \rightarrow O(n)$

### 2. drop non-dominant terms
only keep the term with the steepest growth rate.
- $O(n^2 + 5n + 100) \rightarrow O(n^2)$
- $O(n + \log n) \rightarrow O(n)$
- $O(n! + 2^n) \rightarrow O(n!)$

### 3. add vs multiply
- **consecutive steps $\rightarrow$ add:** if step A is followed by step B:
  $$O(A + B)$$
  *(e.g., loop through list $A$ of length $n$, then loop through list $B$ of length $m \rightarrow O(n + m)$).*
- **nested steps $\rightarrow$ multiply:** if step B runs inside each iteration of step A:
  $$O(A \times B)$$
  *(e.g., nested loops iterating up to $n \rightarrow O(n \times n) = O(n^2)$).*


## common complexity classes

| notation          | name         | intuition / typical example                                                                               |
| :---------------- | :----------- | :-------------------------------------------------------------------------------------------------------- |
| **$O(1)$**        | constant     | instant lookup by index (`arr[i]`), hash map get/set (average), push/pop stack.                           |
| **$O(\log n)$**   | log          | halving the problem space each step: Binary Search, balanced BST search, [[vector databases]] skip lists. |
| **$O(n)$**        | linear       | single pass: iterating through an array, finding min/max in unsorted list.                                |
| **$O(n \log n)$** | linearithmic | efficient sorting: Merge Sort, QuickSort (average), Python's Timsort (`sorted()`).                        |
| **$O(n^2)$**      | quadratic    | nested loops over the same collection: comparing all pairs, Bubble Sort.                                  |
| **$O(2^n)$**      | exponential  | recursive branching: naive Fibonacci, generating all power-set subsets.                                   |
| **$O(n!)$**       | factorial    | Generating all permutations: Traveling Salesperson brute force.                                           |

```text
Complexity Growth:
O(1) < O(log n) < O(n) < O(n log n) < O(n^2) < O(2^n) < O(n!)
-------------------------------------------------------------------->
Excellent        Good         Fair          Poor            Horrible
```

---

## time complexity vs space complexity

- **Time Complexity:** How many operations are executed as $n$ scales.
- **Space Complexity (Auxiliary Space):** How much *extra* memory the algorithm allocates relative to $n$ (excluding the memory taken by the original input itself).

> **recursion trap:** Every recursive function call adds a stack frame to the call stack in memory. Even if you do not allocate any arrays, a recursive function with a recursion depth of $n$ has $O(n)$ space complexity.

---

## practical examples & patterns

### 1. Logarithmic: $O(\log n)$
Whenever the input size is divided (or multiplied) by a constant factor in each step:
```python
def log_example(n):
    count = 0
    while n > 1:
        n = n // 2  # halves every step
        count += 1
    return count
```

### 2. Multi-variable inputs: $O(n + m)$ vs $O(n \times m)$
Be careful when inputs are distinct:
```python
# O(n + m) time, O(1) space
def print_both(list_a, list_b):
    for a in list_a:      # runs n times
        print(a)
    for b in list_b:      # runs m times
        print(b)

# O(n * m) time, O(1) space
def print_pairs(list_a, list_b):
    for a in list_a:      # runs n times
        for b in list_b:  # runs m times inside
            print(a, b)
```

---

## hidden traps & gotchas (especially in Python)

> **trap 1: built-in operations that look like $O(1)$ but are $O(n)$**
> - `x in my_list`: $O(n)$ (linear scan). Convert to `set(my_list)` first if doing repeated lookups ($O(1)$ average).
> - `my_list.insert(0, val)` or `my_list.pop(0)`: $O(n)$ because every subsequent element in memory must be shifted. Use `collections.deque` for $O(1)$ left appends/pops.
> - `string_a += char` inside a loop: In Python, strings are immutable. Repeated string concatenation in a loop can accidentally cause $O(n^2)$ copying. Use `''.join(list_of_strings)` for $O(n)$.

> **trap 2: space-time trade-off**
> You can often trade memory to gain speed. E.g., caching intermediate results with memoization/hash tables can turn an $O(2^n)$ recursive algorithm into $O(n)$ time at the cost of $O(n)$ space.

---

## related notes
- [[vector databases]] → uses logarithmic index traversal (HNSW / Skip Lists).
- [[01_iterators_vs_generators.md|01_iterators_vs_generators]] → generator streams keep space complexity at $O(1)$ compared to loading entire lists $O(n)$ in memory.


## related repos
- [my leet code repository](https://github.com/gabofcampos/leetcode)
