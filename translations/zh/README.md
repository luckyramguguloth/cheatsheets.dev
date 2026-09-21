# 📚 cheatsheets.dev (v2.0)

> **一个仓库。所有速查表。生产环境真实命令。永久离线可用。**

<p align="center">
  🌐
  <a href="../../README.md">English</a> |
  <a href="../es/README.md">Español</a> |
  <a href="../hi/README.md">हिन्दी</a> |
  <a href="../pt/README.md">Português</a> |
  <a href="README.md">简体中文</a> |
  <a href="../ar/README.md">العربية</a>
</p>

<div align="center">

[![Stars](https://img.shields.io/github/stars/yourusername/cheatsheets.dev?style=for-the-badge&logo=github&color=FFD700)](https://github.com/yourusername/cheatsheets.dev/stargazers)
[![Contributors](https://img.shields.io/github/contributors/yourusername/cheatsheets.dev?style=for-the-badge&logo=github&color=4CAF50)](https://github.com/yourusername/cheatsheets.dev/graphs/contributors)
[![Cheatsheets](https://img.shields.io/badge/cheatsheets-74%20%E7%AF%87-blue?style=for-the-badge&logo=bookstack)](https://github.com/yourusername/cheatsheets.dev)
[![License](https://img.shields.io/badge/%E8%AE%B8%E5%8F%AF%E8%AF%81-MIT-green?style=for-the-badge)](../../LICENSE)
[![Offline](https://img.shields.io/badge/%E6%94%AF%E6%8C%81-100%25%20%E7%A6%BB%E7%BA%BF-orange?style=for-the-badge&logo=wifi)](https://github.com/yourusername/cheatsheets.dev)

</div>

---

## ✨ 为什么选择本仓库？

- 🔌 **100% 离线可用** — 一次克隆，永久搜索。完全不需要互联网连接。
- 🚫 **零广告、零追踪、零付费限制** — 纯粹的技术干货，所有命令均经真实生产验证，无虚构指令或低质AI灌水。
- 🌍 **全领域覆盖** — 软件开发者、DevOps 工程师、AI/ML 研究员、系统架构师、IT 运维支持人员、装机爱好者及游戏玩家。
- 🛡️ **生产级灾备恢复方案** — 涵盖系统崩溃、内核宕机（Kernel Panic）、内存溢出（OOM）、勒索软件入侵、启动死循环及网络断网的完整排错与救砖步骤。

---

## 📂 分类索引（共 74 篇速查表）

| 分类 | 篇数 | 核心领域与生产重点 |
|---|:---:|---|
| 🖥️ [开发 (Dev)](../../dev/) | 30 | Git、Bash、Vim、Docker、SQL、Python、JS、TS、Go、Rust、C++、Regex、HTTP、Linux命令、JSON/YAML等 |
| 🚀 [DevOps](../../devops/) | 10 | Kubernetes (`kubectl`)、Terraform、GitHub Actions、systemd、iptables、Prometheus、Ansible、AWS/GCP/Azure CLI |
| 🎮 [游戏优化 (Gaming)](../../gaming/) | 5 | PC硬件优化、模拟器配置、Windows深度精简、游戏模式、降低输入延迟 |
| 🔧 [硬件工程 (Hardware)](../../hardware/) | 5 | BIOS核心设置、内存超频与时序调优、固态硬盘NVMe健康检测、散热硅脂涂抹、PC装机避坑清单 |
| 🤖 [AI与机器学习 (AI & ML)](../../ai-ml/) | 8 | PyTorch、TensorFlow、HuggingFace、LLM微调（LoRA/QLoRA）、本地大模型推理（vLLM/Ollama）、RAG与向量数据库、CUDA/GPU故障排错、MLOps与模型评测 |
| ⚙️ [系统工程 (Systems)](../../systems/) | 8 | Linux内核参数调优、eBPF与Perf性能分析、ZFS与Btrfs存储管理、高可用集群（Pacemaker/Corosync）、企业级安全加固、KVM/Proxmox虚拟化、Ceph分布式存储、勒索软件应急灾备 |
| 🛠️ [IT运维支持 (IT Support)](../../it-support/) | 8 | Windows蓝屏与系统崩溃恢复（BSOD/WinRE）、macOS急救与恢复、网络故障急救与数据包分析、Active Directory域控与身份验证、数据恢复与数字取证、安全事件应急响应、打印机与外设排障、硬件故障排查流程图 |

---

## ⚡ 快速开始

```bash
# 克隆仓库
git clone https://github.com/yourusername/cheatsheets.dev
cd cheatsheets.dev/version2

# 赋予搜索脚本执行权限（Linux/macOS）
chmod +x search.sh

# 在全部 74 篇速查表中立即检索任何命令或恢复指南
./search.sh "cuda oom"
```

> **基础搜索无需任何外部依赖。** [fzf](https://github.com/junegunn/fzf) 为可选工具，安装后可开启交互式模糊搜索。

---

## 🖥️ 交互式网页应用（本地托管文档）

想要更快速、更直观地浏览和检索速查表，可启动内置的轻量级本地文档服务：

```bash
# 在 version2 目录下启动本地 HTTP 服务
python -m http.server 8000
```

随后在浏览器中打开：
👉 **`http://localhost:8000/docs/`**

**本地文档特性：**
- 🔍 **毫秒级即时检索：** 多关键词模糊过滤，搜索词自动高亮标注（`<mark>`）。
- 🗂️ **7大分类标签筛选：** 一键切换全部（74）、开发（30）、DevOps（10）、游戏（5）、硬件（5）、AI/ML（8）、系统（8）、IT支持（8）。
- 🔮 **磨砂玻璃拟态阅读弹窗：** 无需刷新页面即可优雅渲染并阅读任意 Markdown 文档。
- 📋 **单键复制代码：** 所有命令与配置片段均配备一键复制按钮。
- 📴 **100% 离线安全：** 纯本地静态资源，不加载任何远程 CDN。

---

## 📴 如何完全离线使用

只需克隆一次仓库即可：每一张速查表均为标准 Markdown 文件，可直接在终端中查看，亦可在 [Obsidian](https://obsidian.md/)、[Typora](https://typora.io/) 或 VS Code 中阅读。

---

## 🔍 搜索演示

```
$ ./search.sh "cuda oom"

 ─────────────────────────────────────────────────────────────
  🔍  cheatsheets.dev (v2.0) — 离线搜索
 ─────────────────────────────────────────────────────────────

  在 2 个文件中找到 4 处与 "cuda oom" 相关的匹配：

  📄 ai-ml/cuda-gpu-troubleshooting.md
     Line  84 │ export PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True
     Line  89 │ torch.cuda.empty_cache(); gc.collect()

  📄 ai-ml/pytorch.md
     Line 142 │ with torch.no_grad(): output = model(inputs)

 ─────────────────────────────────────────────────────────────
  提示: 运行 ./search.sh --list 可查看全部 74 篇可用速查表
 ─────────────────────────────────────────────────────────────
```

---

## 🚀 核心特性

| 特性 | 详情 |
|---|---|
| 🔌 **100% 纯离线** | 一次克隆，无网络环境下永久使用 |
| 🔍 **命令行全文搜索** | `./search.sh <关键字>` — 基于 grep 与可选 fzf 联动 |
| 🖥️ **内置交互式 Web 阅读器** | `docs/` 目录下零依赖的现代化图形界面 |
| 📋 **高度标准化的结构** | 严格遵循统一的 [TEMPLATE.md](TEMPLATE.md) 模板规范 |
| ✅ **真实生产命令** | 真实命令行参数、故障诊断日志分析与紧急救灾演练 |
| 🌍 **多语言原生支持** | 提供 6 种主流语言的高质量完整 README |
| 🤝 **开源社区驱动** | 基于 MIT 开源协议，欢迎提交 Pull Request |

---

## 🤝 如何参与贡献

我们非常欢迎来自社区的贡献！

1. 阅读 [CONTRIBUTING.md](CONTRIBUTING.md) — 仅需不到 5 分钟。
2. 复制 [TEMPLATE.md](TEMPLATE.md) 到对应分类目录下。
3. 填写真实、经过生产验证的命令与实用示例。
4. 提交 Pull Request，标题格式：`Add: [工具名称] cheatsheet`

---

## 📜 开源许可证

MIT © 2026 [cheatsheets.dev 贡献者](https://github.com/yourusername/cheatsheets.dev/graphs/contributors)

完整许可条款请参阅 [LICENSE](LICENSE) 文件。

---

<div align="center">

**专为开发者、DevOps 工程师、AI 研究人员、系统架构师和 IT 运维工程师打造 — 随时随地，纯净离线，永久可用。**

</div>
