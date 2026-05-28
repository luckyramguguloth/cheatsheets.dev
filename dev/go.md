# Go (Golang) Cheatsheet

> Production reference guide for Go syntax, slices, maps, concurrency, and channels.
> Last verified: May 2026 | Version: 1.22+

---

## Quick Reference

| Feature | Syntax |
|---|---|
| Initialize Variable | `name := "Alice"` |
| Slice Slice | `slice[1:3]` |
| Make Map | `m := make(map[string]int)` |
| Start Goroutine | `go doSomething()` |
| Create Channel | `ch := make(chan string)` |
| Select Multiplex | `select { case msg := <-ch1: ... }` |
| Package Main | `package main` |
| Defer Execution | `defer file.Close()` |

---

## Syntax & Constructs

### Structs, Pointers & Interfaces
```go
package main

import "fmt"

type Speaker interface {
    Speak() string
}

type Person struct {
    Name string
    Age  int
}

func (p *Person) Speak() string {
    return fmt.Sprintf("Hi, I am %s", p.Name)
}
```

### Arrays, Slices & Maps
```go
// Slices (Dynamic Arrays)
slice := []int{10, 20, 30}
slice = append(slice, 40)

// Maps (Hash Tables)
users := make(map[string]int)
users["alice"] = 30
age, exists := users["bob"] // exists is false if key not present
```

---

## Concurrency

### Goroutines & Channels
```go
package main

import "fmt"

func worker(id int, jobs <-chan int, results chan<- int) {
    for j := range jobs {
        results <- j * 2
    }
}

func main() {
    jobs := make(chan int, 100)
    results := make(chan int, 100)

    // Start 3 workers
    for w := 1; w <= 3; w++ {
        go worker(w, jobs, results)
    }

    // Send jobs
    for j := 1; j <= 5; j++ {
        jobs <- j
    }
    close(jobs)

    // Receive results
    for a := 1; a <= 5; a++ {
        fmt.Println(<-results)
    }
}
```

---

## Tips & Tricks

- **Error Handling:** Go doesn't have exceptions. Return errors explicitly as the last return parameter: `val, err := Func()`.
- **Formatting:** Always run `go fmt` on your files to adhere to Go's absolute code standard.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
