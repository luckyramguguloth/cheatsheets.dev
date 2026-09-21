# 🌍 Translations (v2.0)

> Help make cheatsheets.dev accessible to developers, engineers, and IT specialists worldwide.

---

## Available Language Guides

| Language | Folder | Status | Maintainer |
|---|---|---|---|
| English | Root `README.md` | ✅ Complete (v2.0 - 74 Sheets) | Core Team |
| Spanish (Español) | `es/` | ✅ Complete (v2.0 - 74 Sheets) | Core Team |
| Hindi (हिन्दी) | `hi/` | ✅ Complete (v2.0 - 74 Sheets) | Core Team |
| Portuguese (Português) | `pt/` | ✅ Complete (v2.0 - 74 Sheets) | Core Team |
| Chinese (简体中文) | `zh/` | ✅ Complete (v2.0 - 74 Sheets) | Core Team |
| Arabic (العربية) | `ar/` | ✅ Complete (v2.0 - 74 Sheets) | Core Team |

---

## Folder Structure

Each language lives in its own subfolder, mirroring the categories of the main source repository:

```
translations/
├── es/               # Spanish
│   ├── README.md
│   └── ...
├── hi/               # Hindi
│   ├── README.md
│   └── ...
├── pt/               # Portuguese
│   ├── README.md
│   └── ...
├── zh/               # Chinese (Simplified)
│   ├── README.md
│   └── ...
└── ar/               # Arabic
    ├── README.md
    └── ...
```

---

## How to Translate Cheatsheets

### Step 1 — Pick a Cheatsheet
Select any cheatsheet from the 7 core categories:
- `dev/` (30 sheets)
- `devops/` (10 sheets)
- `gaming/` (5 sheets)
- `hardware/` (5 sheets)
- `ai-ml/` (8 sheets)
- `systems/` (8 sheets)
- `it-support/` (8 sheets)

### Step 2 — Copy and Translate
Translate:
- Section titles and headings (`##`, `###`)
- Contextual explanations, summaries, and comments
- Quick reference descriptions
- Troubleshooting tips and warning notices

> ⚠ **Rule:** Never translate CLI commands, flags, arguments, or code snippets. Keep all commands exactly as written.

### Step 3 — Submit a PR
- Branch name: `translation/<lang>/<tool>` (e.g., `translation/es/pytorch`)
- PR Title: `[<lang>] Add translation for <tool>.md`

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
