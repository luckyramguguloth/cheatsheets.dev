# Rust Cheatsheet

> Reference guide for Rust ownership, lifetimes, structs, enums, cargo, and standard library.
> Last verified: May 2026 | Version: 1.78+

---

## Quick Reference

| Feature | Syntax |
|---|---|
| Variable Declaration | `let mut x = 5;` |
| Pattern Matching | `match val { 1 => println!("one"), _ => () }` |
| Option Type | `let opt: Option<i32> = Some(5);` |
| Result Type | `let res: Result<i32, Error> = Ok(10);` |
| Unwrap or Default | `let value = opt.unwrap_or(0);` |
| Vector Init | `let mut v = vec![1, 2, 3];` |
| String Formatting | `let s = format!("x = {}", x);` |
| Struct Implementation | `impl MyStruct { fn new() -> Self {} }` |

---

## Ownership, Borrowing & Lifetimes

### Ownership Rules
- Each value in Rust has an owner.
- There can only be one owner at a time.
- When the owner goes out of scope, the value is dropped.

### Borrowing & References
```rust
fn main() {
    let s1 = String::from("hello");

    // Immutable borrow (multiple allowed)
    let len = calculate_length(&s1); 

    // Mutable borrow (only one allowed at a time)
    let mut s2 = s1; // s1 moved to s2 here
    change(&mut s2);
}

fn calculate_length(s: &String) -> usize {
    s.len()
}

fn change(s: &mut String) {
    s.push_str(", world");
}
```

---

## Pattern Matching & Enums

```rust
enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
    ChangeColor(i32, i32, i32),
}

fn process_message(msg: Message) {
    match msg {
        Message::Quit => println!("Quit message"),
        Message::Move { x, y } => println!("Move to x:{}, y:{}", x, y),
        Message::Write(text) => println!("Text: {}", text),
        Message::ChangeColor(r, g, b) => println!("Change color to R:{}, G:{}, B:{}", r, g, b),
    }
}
```

---

## Tips & Tricks

- **Clippy:** Use `cargo clippy` to run a comprehensive set of lints to analyze code correctness and idiomatic improvements.
- **Cargo.toml Dependencies:** Use standard Semantic Versioning (e.g. `serde = "1.0"` matching compatible upgrades).

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
