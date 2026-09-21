# 📚 cheatsheets.dev (v2.0)

> **One repo. Every cheatsheet. Real production commands. Offline forever.**

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

[![Stars](https://img.shields.io/github/stars/yourusername/cheatsheets.dev?style=for-the-badge&logo=github&color=FFD700)](https://github.com/yourusername/cheatsheets.dev/stargazers)
[![Contributors](https://img.shields.io/github/contributors/yourusername/cheatsheets.dev?style=for-the-badge&logo=github&color=4CAF50)](https://github.com/yourusername/cheatsheets.dev/graphs/contributors)
[![Cheatsheets](https://img.shields.io/badge/cheatsheets-74%20sheets-blue?style=for-the-badge&logo=bookstack)](https://github.com/yourusername/cheatsheets.dev)
[![License](https://img.shields.io/badge/license-MIT-green?style=for-the-badge)](LICENSE)
[![Offline](https://img.shields.io/badge/works-100%25%20offline-orange?style=for-the-badge&logo=wifi)](https://github.com/yourusername/cheatsheets.dev)

</div>

---

## ✨ Why This Repo?

- 🔌 **Works 100% offline** — clone once, search forever. Zero internet dependency.
- 🚫 **Zero ads, zero tracking, zero paywalls** — authentic, verified commands with zero AI slop or placeholders.
- 🌍 **Covers everyone** — Software Developers, DevOps Engineers, AI/ML Practitioners, System Architects, IT Support Technicians, PC Builders, and Gamers.
- 🛡️ **Disaster & Crash Recovery Runbooks** — Detailed steps to diagnose and recover from production outages, kernel panics, OOMs, ransomware, boot loops, and network failures.

---

## 📂 Category Index (74 Total Cheatsheets)

| Category | Sheets | Focus & Production Topics |
|---|:---:|---|
| 🖥️ [Dev](./dev/) | 30 | Git, Bash, Vim, Docker, SQL, Python, JS, TS, Go, Rust, C++, Regex, HTTP, Linux commands, JSON/YAML, etc. |
| 🚀 [DevOps](./devops/) | 10 | Kubernetes (`kubectl`), Terraform, GitHub Actions, systemd, iptables, Prometheus, Ansible, AWS/GCP/Azure CLI |
| 🎮 [Gaming](./gaming/) | 5 | PC optimization, emulation, Windows debloat, game mode, latency reduction |
| 🔧 [Hardware](./hardware/) | 5 | BIOS settings, RAM overclocking & timings, SSD/NVMe health, thermal paste & cooling, PC assembly checklist |
| 🤖 [AI & ML](./ai-ml/) | 8 | PyTorch, TensorFlow, HuggingFace, LLM Fine-Tuning (LoRA/QLoRA), Local LLM Serving (vLLM/Ollama), RAG & Vector DBs, CUDA & GPU Troubleshooting, MLOps & Model Evaluation |
| ⚙️ [Systems](./systems/) | 8 | Linux Kernel Tuning, eBPF & Perf Profiling, ZFS & Btrfs Storage, High Availability Clustering (Pacemaker/Corosync), Enterprise Security Hardening, Proxmox & KVM Virtualization, Distributed Storage (Ceph), Disaster Recovery & Ransomware Mitigation |
| 🛠️ [IT Support](./it-support/) | 8 | Windows Disaster Recovery (BSOD/WinRE), macOS Recovery & Rescue, Network Rescue & Packet Diagnostics, Active Directory & Identity, Data Recovery & Digital Forensics, Cybersecurity Incident Response, Printer & Peripheral Diagnostics, Hardware Diagnostic Flowcharts |

---

## ⚡ Quick Start

```bash
# Clone the repository
git clone https://github.com/yourusername/cheatsheets.dev
cd cheatsheets.dev/version2

# Make the search script executable (Linux/macOS)
chmod +x search.sh

# Search any command or recovery playbook across all 74 cheatsheets
./search.sh "cuda oom"
```

> **No dependencies required** for basic search. [fzf](https://github.com/junegunn/fzf) is optional but unlocks interactive fuzzy search.

---

## 🖥️ Interactive Web App (Localhost Docs)

For a fast, responsive, and visually rich graphical interface with instant search and markdown rendering, launch the built-in local docs reader:

```bash
# Start a simple local web server in the version2 directory
python -m http.server 8000
```

Then open your browser and navigate to:
👉 **`http://localhost:8000/docs/`**

**Features of the Localhost Docs App:**
- 🔍 **Instant Live Search:** Real-time multi-keyword fuzzy filtering with visual highlights (`<mark>`).
- 🗂️ **7 Category Filter Tabs:** Switch instantly between All (74), Dev (30), DevOps (10), Gaming (5), Hardware (5), AI & ML (8), Systems (8), and IT Support (8).
- 🔮 **Glassmorphic Markdown Reader Modal:** Reads and formats cheatsheets on-the-fly without refreshing the page.
- 📋 **Single-Click Code Copy:** One-click button to copy any CLI command or configuration snippet.
- 📴 **100% Offline-Safe:** Zero external CDNs or remote dependencies required.

---

## 📴 How to Use Offline

Clone the repo once and you're done — every cheatsheet is a plain Markdown file that renders beautifully in any terminal, code editor, or Markdown tool. Open files directly, search via `./search.sh`, or browse with [Obsidian](https://obsidian.md/), [Typora](https://typora.io/), or VS Code.

---

## 🔍 Search Demo

```
$ ./search.sh "cuda oom"

 ─────────────────────────────────────────────────────────────
  🔍  cheatsheets.dev (v2.0) — Offline Search
 ─────────────────────────────────────────────────────────────

  Found 4 match(es) for "cuda oom" across 2 file(s):

  📄 ai-ml/cuda-gpu-troubleshooting.md
     Line  84 │ export PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True
     Line  89 │ torch.cuda.empty_cache(); gc.collect()

  📄 ai-ml/pytorch.md
     Line 142 │ with torch.no_grad(): output = model(inputs)

 ─────────────────────────────────────────────────────────────
  Tip: Run ./search.sh --list to view all 74 available cheatsheets
 ─────────────────────────────────────────────────────────────
```

---

## 🚀 Features

| Feature | Details |
|---|---|
| 🔌 **100% Offline** | Clone once, works forever without internet |
| 🔍 **Full-Text CLI Search** | `./search.sh <query>` — grep + optional fzf interactive picker |
| 🖥️ **Interactive Web Reader** | Built-in zero-dependency web UI in `docs/` |
| 📋 **Standardized Format** | Every cheatsheet follows the tested [TEMPLATE.md](TEMPLATE.md) |
| ✅ **Real Production Commands** | Battle-tested flags, diagnostic commands, and recovery runbooks |
| 🌍 **Multilingual** | Fully translated README files in 6 languages |
| 🤝 **Community Driven** | MIT Licensed, open for PRs and continuous updates |

---

## 🤝 How to Contribute

We welcome community contributions!

1. Read [CONTRIBUTING.md](CONTRIBUTING.md) — takes less than 5 minutes.
2. Copy [TEMPLATE.md](TEMPLATE.md) into the target category folder.
3. Fill in verified, battle-tested commands and real-world examples.
4. Submit a PR titled: `Add: [tool-name] cheatsheet`

---

## 📜 License

MIT © 2026 [cheatsheets.dev contributors](https://github.com/yourusername/cheatsheets.dev/graphs/contributors)

See [LICENSE](LICENSE) for full legal terms.

---

<div align="center">

**Built for developers, DevOps engineers, AI researchers, sysadmins, and IT technicians — everywhere, offline, forever.**

</div>
