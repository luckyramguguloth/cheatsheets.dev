# 🌍 Translations

> Help make cheatsheets.dev accessible to developers around the world.

---

## Available Translations

| Language | Folder | Status | Maintainer |
|---|---|---|---|
| Spanish | `es/` | 🚧 Needs contributors | — |
| Hindi | `hi/` | 🚧 Needs contributors | — |
| Portuguese | `pt/` | 🚧 Needs contributors | — |
| Chinese (Simplified) | `zh/` | 🚧 Needs contributors | — |
| Arabic | `ar/` | 🚧 Needs contributors | — |

> **None of these translations exist yet — your contribution can be the first!**

---

## Folder Structure

Each language lives in its own subfolder, mirroring the structure of the English source:

```
translations/
├── es/               # Spanish
│   ├── README.md
│   ├── dev/
│   │   └── git.md
│   └── devops/
│       └── docker.md
├── hi/               # Hindi
├── pt/               # Portuguese
├── zh/               # Chinese (Simplified)
└── ar/               # Arabic
```

Translated files must match the **exact relative path** of the English original.

| English original | Translation path |
|---|---|
| `dev/git.md` | `translations/es/dev/git.md` |
| `devops/docker.md` | `translations/zh/devops/docker.md` |

---

## How to Translate

### Step 1 — Pick a file

Choose any English cheatsheet from `dev/`, `devops/`, `gaming/`, or `hardware/` that does not yet have a translation in your language.

### Step 2 — Copy and translate

```bash
# Example: translating dev/git.md into Spanish
cp dev/git.md translations/es/dev/git.md
```

Open the file and translate:
- Section headings (`##`, `###`)
- Descriptions and comments (lines starting with `#` inside code blocks)
- The **Quick Reference** table descriptions
- The **Tips & Tricks** section

> ⚠ **Do NOT translate** command names, flags, or code itself.
> Keep all code blocks exactly as they are in the English source.

### Step 3 — Update the header

Add a note at the top of the translated file indicating the language and translator:

```markdown
> 🌍 Esta es la versión en **español**. [View English original](../../dev/git.md)
> Traducido por: @your-github-handle
```

### Step 4 — Submit a Pull Request

- Branch name: `translation/es/git` (language/file)
- PR title: `[es] Add Spanish translation for git.md`
- Fill in the PR template checklist

---

## Translation Guidelines

| Rule | Details |
|---|---|
| **Keep commands exact** | Never translate CLI commands, flags, or file paths |
| **Match formatting** | Keep all headers, code blocks, and tables in the same structure |
| **Be consistent** | Use the same terminology throughout a file |
| **Credit yourself** | Add your GitHub handle in the file header |
| **Stay up to date** | If the English file changes, update the translation too |
| **No machine-only translations** | AI-assisted is fine, but a human must review the output |

---

## Adding a New Language

If your language is not listed above, open an issue with the label `new language` and we will add the folder and update this README.

---

## Contact

Questions? Open an issue or start a [Discussion](https://github.com/cheatsheets-dev/cheatsheets/discussions).

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
