# JavaScript Cheatsheet

> Modern ECMAScript (ES6+) reference covering arrays, objects, promises, and async operations.
> Last verified: May 2026 | Version: ES2023+

---

## Quick Reference

| Feature | Syntax |
|---|---|
| Array Mapping | `arr.map(x => x * 2)` |
| Array Filtering | `arr.filter(x => x > 10)` |
| Object Destructuring | `const { name, age } = user;` |
| Nullish Coalescing | `const score = user.score ?? 100;` |
| Optional Chaining | `const street = user?.address?.street;` |
| Promise Concurrency | `await Promise.all([p1, p2, p3])` |
| Dynamic Imports | `const module = await import('./module.js')` |

---

## Modern Syntax & Operators

### Destructuring & Spread
```javascript
// Destructuring with default values and renaming
const user = { id: 1, profile: { name: 'Alice' } };
const { id, profile: { name: userName }, role = 'User' } = user;

// Array destructuring and rest operator
const [first, second, ...rest] = [10, 20, 30, 40, 50];

// Spreading arrays and objects (Shallow copy)
const cloneObj = { ...user, updated: true };
const mergedArr = [...rest, 60, 70];
```

### Advanced Array Methods
```javascript
const items = [{ id: 1, cost: 10 }, { id: 2, cost: 20 }];

// Reduce: sum totals
const total = items.reduce((sum, item) => sum + item.cost, 0);

// Find & FindIndex
const item = items.find(i => i.id === 2);
const index = items.findIndex(i => i.id === 2);

// FlatMap
const words = ["hello world", "javascript language"].flatMap(x => x.split(" "));
```

---

## Async JavaScript

### Promises & Async/Await
```javascript
// Native fetch with Async/Await
async function fetchUserData(userId) {
    try {
        const response = await fetch(`https://api.example.com/users/${userId}`);
        if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
        const data = await response.json();
        return data;
    } catch (error) {
        console.error('Fetch failed:', error);
        throw error;
    }
}
```

---

## Tips & Tricks

- **Object.freeze vs Object.seal:** `freeze` prevents any changes to properties, while `seal` allows modifying existing properties but prevents adding new ones.
- **Set for Unique items:** Deduplicate an array in one line: `const unique = [...new Set(arr)]`.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
