# C++ Cheatsheet

> Reference guide for modern C++ (C++17/C++20/C++23) syntax, pointers, STL containers, and algorithms.
> Last verified: May 2026 | Version: C++20+

---

## Quick Reference

| Feature | Syntax |
|---|---|
| Standard Console Output | `std::cout << "Hello" << std::endl;` |
| Vector Initialization | `std::vector<int> v = {1, 2, 3};` |
| Smart Pointer (Unique) | `auto ptr = std::make_unique<Type>();` |
| Smart Pointer (Shared) | `auto ptr = std::make_shared<Type>();` |
| String Formatting | `std::string s = std::format("x = {}", x);` (C++20) |
| Lambda Function | `auto f = [](int x) { return x * 2; };` |
| Range-based Loop | `for (const auto& item : items) { ... }` |

---

## Pointers & Smart Pointers

### Modern Smart Pointers (Memory Safety)
```cpp
#include <iostream>
#include <memory>

class Widget {
public:
    Widget() { std::cout << "Widget Created\n"; }
    ~Widget() { std::cout << "Widget Destroyed\n"; }
    void process() { std::cout << "Processing\n"; }
};

int main() {
    // Unique pointer (exclusive ownership, automatic cleanup)
    std::unique_ptr<Widget> w1 = std::make_unique<Widget>();
    w1->process();

    // Shared pointer (reference-counted ownership)
    std::shared_ptr<Widget> w2 = std::make_shared<Widget>();
    {
        std::shared_ptr<Widget> w3 = w2; // count increases to 2
    } // w3 out of scope, count decreases to 1
} // w2 out of scope, count decreases to 0, Widget destroyed
```

---

## Standard Template Library (STL)

### Vectors, Maps & Algorithms
```cpp
#include <vector>
#include <unordered_map>
#include <algorithm>
#include <iostream>

int main() {
    // Vector
    std::vector<int> nums = {5, 3, 8, 1, 4};
    nums.push_back(10);

    // Sorting (STL Algorithms)
    std::sort(nums.begin(), nums.end());

    // Unordered Map (Hash Map)
    std::unordered_map<std::string, int> ages;
    ages["Alice"] = 30;
    
    // Check if key exists
    if (auto it = ages.find("Bob"); it != ages.end()) {
        std::cout << "Found Bob: " << it->second << "\n";
    }
}
```

---

## Tips & Tricks

- **RAII:** Resource Acquisition Is Initialization. Always rely on objects managing their resource lifetimes in their constructors and destructors to prevent memory/file leaks.
- **Pass by reference-to-const:** Avoid copying large objects by passing them as `const Type& obj` to functions.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
