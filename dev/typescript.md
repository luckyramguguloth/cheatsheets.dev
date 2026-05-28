# TypeScript Cheatsheet

> Reference guide for TypeScript static typing, interfaces, generics, and utility types.
> Last verified: May 2026 | Version: 5.x

---

## Quick Reference

| Feature | Syntax |
|---|---|
| Interface Definition | `interface User { id: number; name: str }` |
| Type Alias | `type ID = string | number;` |
| Generic Function | `function first<T>(arr: T[]): T` |
| Readonly Properties | `interface Point { readonly x: number }` |
| Optional Fields | `interface Config { port?: number }` |
| Type Assertion | `const canvas = el as HTMLCanvasElement;` |
| Partial Utility Type | `Partial<User>` (All properties optional) |
| Omit Utility Type | `Omit<User, 'password'>` (Exclude property) |

---

## Types & Interfaces

### Core Interfaces & Type Intersection
```typescript
interface Animal {
    name: string;
    speak(): void;
}

interface Pet extends Animal {
    owner: string;
}

// Type intersection
type Loggable = { log(msg: string): void };
type DatabaseUser = User & Loggable;
```

### Generics
```typescript
class Repository<T> {
    private items: T[] = [];

    add(item: T): void {
        this.items.push(item);
    }

    get(index: number): T | undefined {
        return this.items[index];
    }
}
```

---

## Utility Types

```typescript
interface Todo {
    id: number;
    title: string;
    completed: boolean;
    priority: 'low' | 'medium' | 'high';
}

// Partial: all keys optional
const updateTodo = (id: number, fieldsToUpdate: Partial<Todo>) => {};

// Pick: choose specific keys
type TodoPreview = Pick<Todo, 'title' | 'completed'>;

// Omit: remove specific keys
type UnidentifiedTodo = Omit<Todo, 'id'>;

// Record: key-value dictionary type
const routeConfigs: Record<string, string> = {
    home: '/home',
    about: '/about'
};
```

---

## Tips & Tricks

- **Strict Mode:** Always enable `strict: true` in your `tsconfig.json` to enable strict null checks and other critical compiler safeguards.
- **Type Guards:** Use `typeof`, `instanceof`, or custom type guards (`item is CustomType`) to dynamically narrow down types safely.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
