# File Permissions Cheatsheet

> Reference guide for Linux/Unix file permissions, chmod modes, ACLs, and umask.
> Last verified: May 2026 | Version: Linux Core

---

## Quick Reference

| Command / Mode | Octal | Permissions | Description |
|---|---|---|---|
| `chmod 755 file` | 755 | `rwxr-xr-x` | User: full, Group/Others: read/execute (standard binary) |
| `chmod 644 file` | 644 | `rw-r--r--` | User: read/write, Group/Others: read only (standard document) |
| `chmod 600 file` | 600 | `rw-------` | User: read/write, Group/Others: no access (private keys) |
| `chmod 700 dir` | 700 | `rwx------` | User: full, Group/Others: no access (private folder) |
| `chmod +x file` | - | - | Add execute permission to everyone |

---

## Numeric (Octal) Notation

The numeric value is calculated by adding the values of the permissions:
- **Read (r)** = 4
- **Write (w)** = 2
- **Execute (x)** = 1
- **No access (-)** = 0

### Calculator Example:
- User (rwx) = 4 + 2 + 1 = **7**
- Group (r-x) = 4 + 0 + 1 = **5**
- Others (r--) = 4 + 0 + 0 = **4**
- Result: **754**

```bash
# Set specific octal permissions
chmod 754 script.sh
```

---

## Special Permissions (SUID, SGID, Sticky Bit)

### SUID (Set Owner User ID)
When set, the file executes with the privileges of its owner rather than the user running it.
- Numeric: Add **4** to the front (e.g. `chmod 4755 binary`)
- Symbolic: Represented by an `s` in user execute bit (e.g. `-rwsr-xr-x`)

### SGID (Set Group ID)
Files created inside a directory with SGID inherit the parent directory's group instead of the user's primary group.
- Numeric: Add **2** to the front (e.g. `chmod 2755 directory`)
- Symbolic: Represented by an `s` in group execute bit (e.g. `drwxrwsr-x`)

### Sticky Bit
Prevents users from deleting or renaming files in a directory unless they are the owner of the file, the directory, or root.
- Numeric: Add **1** to the front (e.g. `chmod 1777 /tmp`)
- Symbolic: Represented by a `t` in others execute bit (e.g. `drwxrwxrwt`)

---

## Tips & Tricks

- **Umask:** The default mask subtracted from new files (usually 022, yielding 644 permissions on files and 755 on directories).
- **Security Best Practice:** Never set permissions to `777` on production servers. Instead, structure proper user groups and set `755` or `750`.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
