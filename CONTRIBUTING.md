# 🤝 Contributing to cheatsheets.dev

> Thank you for making this the best offline cheatsheet collection on the internet.  
> A great cheatsheet takes about **10 minutes** to write. Here's exactly how.

---

## 📋 Table of Contents

- [5-Step Process to Add a Cheatsheet](#-5-step-process-to-add-a-cheatsheet)
- [Rules](#-rules)
- [PR Title Format](#-pr-title-format)
- [Types of Contributions](#-types-of-contributions)
- [Code Style Guide](#-code-style-guide)
- [Review Process](#-review-process)
- [Good First Issues](#-good-first-issues)
- [Community Standards](#-community-standards)

---

## ✅ 5-Step Process to Add a Cheatsheet

This takes about 10 minutes. No setup, no dependencies, no build system.

### Step 1 — Fork & Clone

```bash
# Fork the repo on GitHub, then:
git clone https://github.com/YOUR_USERNAME/cheatsheets.dev
cd cheatsheets.dev
git checkout -b add-toolname-cheatsheet
```

### Step 2 — Copy the Template

```bash
# Pick the right category folder:
#   dev/       → languages, editors, frameworks, databases, APIs
#   devops/    → Docker, Kubernetes, CI/CD, cloud, networking
#   gaming/    → PC optimization, emulators, console commands, modding
#   hardware/  → BIOS, overclocking, RAM, GPU, storage

cp TEMPLATE.md dev/your-tool.md   # adjust path as needed
```

Use the exact filename format: `lowercase-with-hyphens.md`  
Examples: `docker-compose.md`, `vim.md`, `aws-cli.md`, `git.md`

### Step 3 — Fill in the Cheatsheet

Open your new file and replace all placeholder text.

- Start with the **Quick Reference table** — these are the 10–15 commands most people search for.
- Write **accurate commands** — test them yourself before adding.
- Keep **descriptions under 8 words** — people scan, they don't read.
- Group commands into logical **sections and subsections**.
- Add `# comments` inside code blocks explaining what the command does.
- End with **Tips & Tricks** — at least 3 real-world tips.
- Update the `Last verified:` date to today.

### Step 4 — Verify Your Work

Before pushing, run through this checklist:

```
[ ] Title matches the format: "# [Tool Name] Cheatsheet"
[ ] One-line description is accurate and concise
[ ] Last verified date is current (Month YYYY)
[ ] Version number is correct
[ ] Quick Reference table has 10+ commands
[ ] All commands have been tested and work
[ ] Descriptions are 8 words or fewer
[ ] Code blocks use ```bash for shell commands
[ ] Code blocks have # comments explaining what each command does
[ ] File is 300–600 lines long (comprehensive but scannable)
[ ] Tips & Tricks section exists with 3+ tips
[ ] Contributor note at the bottom is included
[ ] No spelling errors (run a spellchecker)
```

### Step 5 — Open the PR

```bash
git add dev/your-tool.md
git commit -m "Add: your-tool cheatsheet"
git push origin add-toolname-cheatsheet
```

Then open a Pull Request on GitHub with:

- **Title:** `Add: [tool name] cheatsheet` (see format below)
- **Description:** One sentence explaining what the tool is and who it's for.

---

## 📏 Rules

These rules keep every cheatsheet consistent and trustworthy:

| Rule | Reason |
|---|---|
| **Use the template** | Consistency makes scanning easier for everyone |
| **Test every command** | Untested commands destroy trust |
| **Descriptions ≤ 8 words** | Cheatsheets are for scanning, not reading |
| **Facts only — no opinions** | "Use X instead of Y" arguments don't belong here |
| **No version-specific hacks without a note** | Deprecated commands waste people's time |
| **No paywalled tool commands** | This repo is for accessible, widely used tools |
| **No AI-generated content without human verification** | AI hallucinates flags and options constantly |
| **Cite official docs when possible** | Helps readers go deeper |
| **One tool per file** | `docker.md` ≠ `docker-compose.md` |
| **Keep files under 600 lines** | Longer = harder to scan |

---

## 📌 PR Title Format

Always use this exact format for PR titles:

```
Add: [tool name] cheatsheet
Fix: [tool name] — [brief description of fix]
Update: [tool name] — version X.X
Rename: [old name] → [new name]
Remove: [tool name] — [reason]
```

**Examples:**

```
Add: Helm cheatsheet
Fix: Docker — update deprecated `docker run` flag syntax
Update: Kubernetes — version 1.30
Add: tmux cheatsheet
Fix: Git — remove incorrect rebase flag
```

Do **not** use: `feat:`, `chore:`, `docs:` — keep it human-readable.

---

## 🎯 Types of Contributions

All of these are welcome and valued:

| Type | Examples |
|---|---|
| ✨ **New cheatsheet** | Add a missing tool (see Good First Issues) |
| 🐛 **Bug fix** | Broken command, wrong flag, outdated syntax |
| 📅 **Version update** | Update for a new major release |
| 🔠 **Typo / grammar fix** | Spelling, punctuation, clarity |
| 🗂️ **New category** | Propose a new category folder with 3+ cheatsheets |
| 🔍 **Search improvement** | Improve `search.sh` with new features |
| 📋 **Template improvement** | Better structure, new section types |
| 🌐 **Translation** | Translate a cheatsheet (create language subfolder) |

---

## 🎨 Code Style Guide

### File Naming

```
✅ docker.md
✅ docker-compose.md
✅ aws-cli.md
✅ vim.md
✅ github-actions.md

❌ Docker.md        (no uppercase)
❌ docker_compose.md  (use hyphens, not underscores)
❌ AWSCli.md        (no camelCase)
```

### Markdown Formatting

```markdown
# Always use ATX-style headers (# not underlines)

## Two hashes for major sections

### Three hashes for subsections

# Code blocks — always specify the language
```bash
command --flag value   # Always add a comment
```

# Tables — always include header separator row
| Column 1 | Column 2 |
|---|---|
| value    | value    |

# Blank lines — always add one blank line between sections
```

### Command Comments

Every command in a code block MUST have a comment:

```bash
# ✅ Good
docker ps -a          # List all containers (including stopped)
docker stop myapp     # Stop a running container gracefully

# ❌ Bad (no comment)
docker ps -a
docker stop myapp
```

### Descriptions in Tables

Keep descriptions scannable — 8 words max:

```markdown
# ✅ Good
| `docker ps` | List running containers |
| `docker stop <name>` | Stop a container gracefully |

# ❌ Too long
| `docker ps` | This command will list all of the currently running containers on your system |
```

### Section Ordering

Every cheatsheet must follow this section order:

1. Title and description
2. Quick Reference table
3. Installation (if applicable)
4. Core sections (tool-specific)
5. Configuration (if applicable)
6. Tips & Tricks
7. Contributor note

---

## 🔄 Review Process

We aim to review every PR within **24 hours**.

Here's what happens after you open a PR:

```
1. Automated checks run (Markdown lint, filename format)
2. A maintainer reviews the content for accuracy
3. Minor feedback is given as inline comments
4. You address feedback (usually 1–2 small changes)
5. PR is approved and merged 🎉
6. Your name appears in the Contributors section
```

**Common reasons for requests-for-changes:**

- Commands not tested (we may ask you to add a verification note)
- Descriptions over 8 words
- Missing Quick Reference table
- Code blocks without comments
- File over 600 lines without splitting

We will **never** reject a PR for being "too small" — a one-line fix is as valuable as a 500-line cheatsheet.

---

## 🌱 Good First Issues

These cheatsheets are **missing** and ready to be claimed. Pick one, comment on the issue, and go!

| # | Tool | Category | Notes |
|---|---|---|---|
| 1 | `tmux` | dev/ | Session management, panes, windows |
| 2 | `sed` | dev/ | Stream editor, substitutions |
| 3 | `awk` | dev/ | Text processing, field extraction |
| 4 | `Helm` | devops/ | Kubernetes package manager |
| 5 | `Prometheus` | devops/ | Metrics, PromQL queries |
| 6 | `Grafana` | devops/ | Dashboard setup, data sources |
| 7 | `ffmpeg` | dev/ | Video/audio conversion commands |
| 8 | `rsync` | devops/ | File sync, backup flags |
| 9 | `GPU overclocking` | hardware/ | MSI Afterburner, nvidia-smi |
| 10 | `RetroArch` | gaming/ | Core loading, shaders, netplay |

> To claim an issue: open a GitHub Issue titled `Claim: [tool name] cheatsheet` and we'll assign it to you.

---

## 🌐 Community Standards

This project follows the [Contributor Covenant Code of Conduct v2.1](CODE_OF_CONDUCT.md).

**In short:** Be kind. Assume good intent. Focus on the cheatsheet, not the person.

If you experience or witness unacceptable behavior, please report it by opening a private GitHub Issue marked `[conduct]` or emailing the maintainers listed in CODE_OF_CONDUCT.md.

---

## ❓ Questions?

- **Something unclear?** Open a [GitHub Discussion](https://github.com/yourusername/cheatsheets.dev/discussions).
- **Found a bug?** Open a [GitHub Issue](https://github.com/yourusername/cheatsheets.dev/issues).
- **Want to chat?** Join our community in Discussions — we're friendly.

---

*Thank you for contributing. Every cheatsheet you write will be read by thousands of people working offline, in data centers, on planes, and in terminal sessions around the world.*
