# YAML Cheatsheet

> YAML configurations reference guide covering key-value structures, arrays, anchors, and multiline blocks.
> Last verified: May 2026 | Version: YAML 1.2

---

## Quick Reference

| Feature / Rule | Specification |
|---|---|
| File Extension | `.yml` or `.yaml` |
| MIME Type | `application/x-yaml` or `text/yaml` |
| Indentation | Must use spaces (Tabs are strictly **forbidden**) |
| Document Separator | `---` (starts a document), `...` (ends a document) |
| Comments | Prefixed with `#` |

---

## Basic Syntax Structures

### Scalars, Lists, and Mappings
```yaml
# Simple key-value mapping
api_version: v1
port: 8080

# Sequence / List (block format)
supported_methods:
  - GET
  - POST
  - DELETE

# Sequence / List (flow format)
allowed_origins: [localhost, dev.example.com]
```

### Multiline Strings
- **Literal block operator (`|`):** preserves all newlines literally.
- **Folded block operator (`>`):** collapses simple single-line breaks into spaces.

```yaml
literal_block: |
  This multiline string
  will preserve
  all newlines.

folded_block: >
  This text block will be compiled
  as a single continuous line,
  collapsing single line breaks.
```

---

## Advanced Features: Anchors & Aliases

Anchors (`&`) allow marking duplicate configurations, and Aliases (`*`) let you inject them elsewhere to keep code DRY.

```yaml
# Define base configuration anchor
defaults: &base_config
  adapter: postgres
  host: localhost
  timeout: 5000

# Reuse configurations inside specific environments
development:
  <<: *base_config
  database: dev_db

production:
  <<: *base_config
  database: prod_db
  host: db.prod.internal
```

---

## Tips & Tricks

- **Tabs vs Spaces:** Always configure your code editor to convert Tabs to 2 Spaces when writing YAML. A single tab character anywhere inside a YAML file will cause parse failure.
- **Booleans gotcha:** In older YAML 1.1 specs, keywords like `yes`, `no`, `on`, and `off` were parsed as booleans (`true`/`false`). Quote them (e.g. `"yes"`) if they represent string values.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
