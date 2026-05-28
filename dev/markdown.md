# Markdown Cheatsheet

> Complete reference for GitHub Flavored Markdown (GFM), syntax styles, and formatting blocks.
> Last verified: May 2026 | Version: GFM Standard

---

## Quick Reference

| Element | Syntax |
|---|---|
| Heading 1 | `# Heading 1` |
| Heading 2 | `## Heading 2` |
| Bold | `**bold text**` |
| Italic | `*italic text*` |
| Inline Code | `` `code` `` |
| Hyperlink | `[text](https://url)` |
| Blockquote | `> quotes` |
| Ordered List | `1. First item` |

---

## Core Formatting Syntax

### Lists and Tasks
```markdown
* Unordered List Item A
* Unordered List Item B
  * Sub-item B1
  * Sub-item B2

1. Ordered Item 1
2. Ordered Item 2

- [x] Completed task item
- [ ] Remaining task item
```

### Tables
```markdown
| Header Left | Header Center | Header Right |
| :--- | :---: | ---: |
| Left aligned | Centered | Right aligned |
| Text | Text | Text |
```

---

## GFM Callouts & Alerts

Standard alert boxes rendered beautifully on modern platforms like GitHub:
```markdown
> [!NOTE]
> Information that users should take notice of even when skimming.

> [!TIP]
> Helpful advice for doing things better or more efficiently.

> [!IMPORTANT]
> Key information users need to know to achieve their goal.

> [!WARNING]
> Urgent info that needs immediate user attention to avoid problems.

> [!CAUTION]
> Negative consequences of an action.
```

---

## Tips & Tricks

- **HTML inside Markdown:** Standard Markdown supports raw HTML. You can use `<br>` for forced line breaks, or `<details>` + `<summary>` for collapse blocks.
- **Escape Characters:** Use a backslash `\` to escape markdown characters and print them literally (e.g., `\*` will render a literal asterisk instead of formatting).

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
