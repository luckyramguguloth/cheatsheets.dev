# JSON Cheatsheet

> Reference guide for JSON format standards, data types, structures, and parsing rules.
> Last verified: May 2026 | Version: RFC 8259

---

## Quick Reference

| Feature / Rule | Specification |
|---|---|
| File Extension | `.json` |
| MIME Type | `application/json` |
| String Format | Must be double quoted (`"string"`) |
| Key Requirement | Keys must be double quoted (`"key": "value"`) |
| Supported Data Types | String, Number, Object, Array, Boolean, Null |
| Trailing Commas | **Forbidden** (causes parser error) |

---

## Syntax Structure

### Valid Example
```json
{
  "user_id": 1024,
  "username": "alice",
  "is_admin": true,
  "preferences": {
    "theme": "dark",
    "notifications": null
  },
  "roles": [
    "user",
    "moderator"
  ]
}
```

---

## JQ Command Line JSON Processor

`jq` is the standard command-line JSON parser.

### Common jq Operations
```bash
# Pretty print a JSON file
cat data.json | jq .

# Select a nested field
jq '.preferences.theme' data.json

# Filter array item by index
jq '.roles[0]' data.json

# Extract only specific keys and map to list
jq '.username, .is_admin' data.json

# Map an array of objects to pull values
jq '[.users[].username]' data.json
```

---

## Tips & Tricks

- **Validation:** Always validate JSON when editing configuration files. Invalid trailing commas (e.g., `{"a": 1,}`) will cause runtime errors in Python, JS, and Node.
- **Minification:** JSON can be stripped of whitespaces and newlines for compact transmission. To minify, use: `cat data.json | jq -c .`.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
