# 📚 cheatsheets.dev

> **One repo. Every cheatsheet. Offline forever.**

<p align="center">
  🌐
  <a href="README.md">English</a> |
  <a href="translations/es/README.md">Español</a> |
  <a href="translations/hi/README.md">हिन्दी</a> |
  <a href="translations/pt/README.md">Português</a> |
  <a href="translations/zh/README.md">简体中文</a> |
  <a href="translations/ar/README.md">العربية</a>
</p>

<div align="center">

[![Stars](https://img.shields.io/github/stars/yourusername/cheatsheets.dev?style=for-the-badge&logo=github&color=FFD700)](https://github.com/luckyramguguloth/cheatsheets.dev/stargazers)
[![Contributors](https://img.shields.io/github/contributors/yourusername/cheatsheets.dev?style=for-the-badge&logo=github&color=4CAF50)](https://github.com/luckyramguguloth/cheatsheets.dev/graphs/contributors)
[![Cheatsheets](https://img.shields.io/badge/cheatsheets-100%2B-blue?style=for-the-badge&logo=bookstack)](https://github.com/luckyramguguloth/cheatsheets.dev)
[![License](https://img.shields.io/badge/license-MIT-green?style=for-the-badge)](LICENSE)
[![Offline](https://img.shields.io/badge/works-100%25%20offline-orange?style=for-the-badge&logo=wifi)](https://github.com/luckyramguguloth/cheatsheets.dev)

</div>

---

## ✨ Why This Repo?

- 🔌 **Works 100% offline** — clone once, search forever. No internet required, ever.
- 🚫 **Zero ads, zero tracking, zero paywalls** — pure signal, no noise.
- 🌍 **Covers everyone** — developers, DevOps engineers, gamers, hardware builders, sysadmins, and students.

---

## 📂 Category Index

| Category | Cheatsheets | Description |
|---|---|---|
| 🖥️ [Dev](./dev/) | 30 | Languages, frameworks, editors, databases, APIs |
| 🚀 [DevOps](./devops/) | 10 | Docker, Kubernetes, CI/CD, cloud providers, networking |
| 🎮 [Gaming](./gaming/) | 5 | PC optimization, emulators, Windows debloat, game mode |
| 🔧 [Hardware](./hardware/) | 5 | BIOS, overclocking, RAM, storage, thermal paste |

---

## ⚡ Quick Start

```bash
# Clone the repo
git clone https://github.com/yourusername/cheatsheets.dev
cd cheatsheets.dev

# Make the search script executable
chmod +x search.sh

# Search any topic instantly
./search.sh "docker stop"
```

> **No dependencies required** for basic search. [fzf](https://github.com/junegunn/fzf) is optional but unlocks interactive fuzzy search.

---

## 🖥️ Interactive Web App (Localhost Docs)

For a premium, interactive graphical experience and faster understanding, check out the built-in static web app:

```bash
# Start a simple local web server in the repository root
python -m http.server 8000
```

Then open your browser and navigate to:
👉 **`http://localhost:8000/docs/`**

**Features of the Localhost View:**
- 🔍 **Instant Search:** Fuzzy real-time search with visual highlights (`<mark>`).
- 🗂️ **Interactive Tab Filters:** Filter cheatsheets dynamically by category (Dev, DevOps, Gaming, Hardware).
- 🔮 **Premium Reader Modal:** Opens and renders markdown sheets in a gorgeous glassmorphic modal with zero page reloads.
- 📋 **Copy to Clipboard:** One-click copy buttons on all code blocks.
- 📴 **100% Offline-Safe:** Functions fully without any active internet connection.

---

## 📴 How to Use Offline

Clone the repo once and you're done — every cheatsheet is a plain Markdown file that renders beautifully in any editor, terminal, or Markdown viewer. Open files directly, use `./search.sh`, or browse with [Obsidian](https://obsidian.md/), [Typora](https://typora.io/), or VS Code.

---

## 🔍 Search Demo

```
$ ./search.sh "docker remove"

 ─────────────────────────────────────────────────────────────
  🔍  cheatsheets.dev — Offline Search
 ─────────────────────────────────────────────────────────────

  Found 3 match(es) for "docker remove" across 2 file(s):

  📄 devops/docker.md
     Line  87 │ docker rm <container>           # Remove a stopped container
     Line  88 │ docker rm -f <container>         # Force remove running container

  📄 devops/kubernetes.md
     Line 204 │ kubectl delete pod <name>         # Remove a pod

 ─────────────────────────────────────────────────────────────
  Tip: Run ./search.sh --list to see all available cheatsheets
 ─────────────────────────────────────────────────────────────
```

---

## 🚀 Features

| Feature | Details |
|---|---|
| 🔌 **100% Offline** | Clone once, works forever without internet |
| 🔍 **Full-Text Search** | `./search.sh <query>` — grep + fzf fuzzy search |
| 📋 **Consistent Format** | Every cheatsheet uses the same [template](TEMPLATE.md) |
| ✅ **Verified Commands** | All commands are tested and marked with last-verified date |
| 🤝 **Community Driven** | Open PRs welcome — merged within 24 hours |

---

## 🤝 How to Contribute

We welcome contributions of all sizes!

1. Read [CONTRIBUTING.md](CONTRIBUTING.md) — it takes 5 minutes.
2. Copy [TEMPLATE.md](TEMPLATE.md) to the right category folder.
3. Fill it in with accurate, tested commands.
4. Open a PR with title: `Add: [tool name] cheatsheet`

---

## 📜 License

MIT © 2026 [cheatsheets.dev contributors](https://github.com/luckyramguguloth/cheatsheets.dev/graphs/contributors)

See [LICENSE](LICENSE) for full terms.

---

<div align="center">

**Built for developers, gamers, and system builders — everywhere, offline, forever.**

</div>
