# Python Cheatsheet

> Modern Python reference guide covering syntax, idioms, collections, and best practices.
> Last verified: May 2026 | Version: 3.12+

---

## Quick Reference

| Action / Construct | Syntax |
|---|---|
| Virtual Env Setup | `python -m venv .venv` |
| List Comprehension | `[x**2 for x in items if x > 0]` |
| Dict Comprehension | `{k: v for k, v in zip(keys, values)}` |
| Read File (Context Manager) | `with open('file.txt', 'r') as f:` |
| Write JSON | `json.dump(data, f, indent=4)` |
| Merge Dictionaries | `merged = dict1 | dict2` (Python 3.9+) |
| Type Hinting Function | `def greet(name: str) -> str:` |
| Run Server | `python -m http.server 8000` |

---

## Collections & Data Structures

### Lists, Sets & Dictionaries
```python
# List slicing: [start:stop:step]
numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
reverse_even = numbers[::-2]  # [9, 7, 5, 3, 1] but even indices: [8, 6, 4, 2, 0]

# List unpacking
first, *middle, last = [1, 2, 3, 4, 5]  # first=1, middle=[2,3,4], last=5

# Dictionaries with defaults (using collections)
from collections import defaultdict
dd = defaultdict(list)
dd['keys'].append('value')

# Named Tuples (using typing)
from typing import NamedTuple
class Point(NamedTuple):
    x: int
    y: int

p = Point(10, 20)
print(p.x, p.y)
```

---

## Control Flow & Idioms

### Pattern Matching (Python 3.10+)
```python
def process_status(status_code):
    match status_code:
        case 200 | 201:
            return "Success"
        case 400:
            return "Bad Request"
        case 404:
            return "Not Found"
        case 500 as code:
            return f"Server Error: {code}"
        case _:
            return "Unknown Status"
```

### Context Managers (Custom)
```python
from contextlib import contextmanager

@contextmanager
def temp_change_dir(path):
    import os
    original = os.getcwd()
    os.chdir(path)
    try:
        yield
    finally:
        os.chdir(original)
```

---

## Tips & Tricks

- **Use Pathlib:** Always use `pathlib.Path` instead of `os.path` for path manipulations — it's cleaner and cross-platform.
- **F-Strings Formatting:** You can use `= ` inside f-strings for quick debugging (e.g. `f"{x=}"` prints `x=10`).

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
