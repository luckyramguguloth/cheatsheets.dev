# Package Managers Cheatsheet

> Command syntax matrix comparing NPM, Pip, Cargo, Brew, APT, and DNF package systems.
> Last verified: May 2026 | Version: Multi-core Systems

---

## Command Reference Matrix

| Action | NPM (JS) | Pip (Python) | Cargo (Rust) | Homebrew (Mac) | APT (Ubuntu) |
|---|---|---|---|---|---|
| **Install Package** | `npm i pkg` | `pip install pkg` | `cargo add pkg` | `brew install pkg` | `apt install pkg` |
| **Remove Package** | `npm uninstall pkg` | `pip uninstall pkg` | `cargo rm pkg` | `brew uninstall pkg` | `apt remove pkg` |
| **Search Package** | `npm search pkg` | `pip search pkg` | `cargo search pkg` | `brew search pkg` | `apt-cache search pkg` |
| **List Installed** | `npm list` | `pip list` | `cargo tree` | `brew list` | `apt list --installed` |
| **Update DB/All** | `npm update` | `pip install -U pip` | `cargo update` | `brew update && brew upgrade` | `apt update && apt upgrade` |

---

## Project Dependency Files

### JavaScript / Node.js (`package.json`)
```json
{
  "dependencies": {
    "express": "^4.19.0"
  },
  "scripts": {
    "start": "node index.js"
  }
}
```

### Python (`requirements.txt`)
```text
flask==3.0.2
requests>=2.31.0
numpy
```

### Rust (`Cargo.toml`)
```toml
[dependencies]
serde = { version = "1.0", features = ["derive"] }
tokio = { version = "1.37", features = ["full"] }
```

---

## Tips & Tricks

- **Global vs Local:** In NPM, use `-g` only for developer CLI utilities. Project libraries should always be saved locally in `node_modules` via `npm i <name>`.
- **APT Lock Troubleshooting:** If you get an APT lock error (e.g. `Unable to lock directory`), verify no auto-upgrades are running, or run: `sudo killall apt apt-get` (or reboot).

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
