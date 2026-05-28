# 📚 cheatsheets.dev

> **一个仓库。所有速查表。永久离线。**

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
[![Cheatsheets](https://img.shields.io/badge/cheatsheets-100%2B-blue?style=for-the-badge&logo=bookstack)](https://github.com/yourusername/cheatsheets.dev)
[![License](https://img.shields.io/badge/%E8%AE%B8%E5%8F%AF%E8%AF%81-MIT-green?style=for-the-badge)](../../LICENSE)
[![Offline](https://img.shields.io/badge/%E6%94%AF%E6%8C%81-100%25%20%E7%A6%BB%E7%BA%BF-orange?style=for-the-badge&logo=wifi)](https://github.com/yourusername/cheatsheets.dev)

</div>

---

## ✨ 为什么选择本仓库？

- 🔌 **100% 离线可用** — 一次克隆，永久使用。完全不需要互联网连接。
- 🚫 **零广告、零追踪、零付费限制** — 纯粹的技术干货，无任何干扰。
- 🌍 **面向所有人** — 开发者、DevOps 工程师、游戏玩家、硬件DIY爱好者、系统管理员和学生。

---

## 📂 分类索引

| 分类 | 速查表数量 | 描述 |
|---|---|---|
| 🖥️ [开发](../../dev/) | 30 | 编程语言、框架、编辑器、数据库、API |
| 🚀 [DevOps](../../devops/) | 10 | Docker、Kubernetes、CI/CD、网络、运维 |
| 🎮 [游戏](../../gaming/) | 5 | 系统精简、性能优化、游戏模式、故障排除 |
| 🔧 [硬件](../../hardware/) | 5 | 装机指南、内存超频、BIOS设置、散热硅脂 |

---

## ⚡ 快速开始

```bash
# 克隆仓库
git clone https://github.com/yourusername/cheatsheets.dev
cd cheatsheets.dev

# 赋予搜索脚本执行权限
chmod +x search.sh

# 立即搜索任何主题
./search.sh "docker stop"
```

> **无必装依赖项。** [fzf](https://github.com/junegunn/fzf) 是可选的，但安装后可开启强大的交互式模糊搜索。

---

## 🖥️ 交互式网页应用（本地托管文档）

为了获得更高级的交互式图形体验和更直观的理解，推荐访问内置的静态网页应用：

```bash
# 在仓库根目录下启动一个简单的本地 Web 服务器
python -m http.server 8000
```

然后打开浏览器并访问：
👉 **`http://localhost:8000/docs/`**

**本地托管视图特色：**
- 🔍 **即时搜索：** 带有视觉高亮（`<mark>`）的实时模糊搜索。
- 🗂️ **交互式标签过滤：** 动态地按分类（开发、DevOps、游戏、硬件）筛选速查表。
- 🔮 **高级阅读弹窗：** 在无需刷新页面的情况下，在精美的毛玻璃（glassmorphic）弹窗中渲染 Markdown 速查表。
- 📋 **复制到剪贴板：** 代码块带有快速一键复制代码功能。
- 📴 **100% 离线安全：** 完全在没有互联网连接的环境下独立运行。

---

## 📴 如何离线使用

一次克隆，即可永久在离线环境中使用 — 每一个速查表都是纯 Markdown 文件，能够在任何编辑器、终端或 Markdown 浏览器中完美显示。您可以直接打开文件、使用 `./search.sh`，或者通过 [Obsidian](https://obsidian.md/)、[Typora](https://typora.io/) 或 VS Code 进行浏览。

---

## 🔍 搜索效果演示

```
$ ./search.sh "docker remove"

 ─────────────────────────────────────────────────────────────
  🔍  cheatsheets.dev — 离线搜索
 ─────────────────────────────────────────────────────────────

  在 2 个文件中找到了 3 个关于 "docker remove" 的匹配项：

  📄 devops/docker.md
     第  87 行 │ docker rm <container>           # 删除一个已停止的容器
     第  88 行 │ docker rm -f <container>         # 强制删除一个运行中的容器

  📄 devops/kubernetes.md
     第 204 行 │ kubectl delete pod <name>         # 删除一个 pod

 ─────────────────────────────────────────────────────────────
  提示：运行 ./search.sh --list 来查看所有可用的速查表
 ─────────────────────────────────────────────────────────────
```

---

## 🚀 仓库特色

| 特色 | 详情 |
|---|---|
| 🔌 **100% 离线** | 克隆一次，永久使用，完全脱离网络限制 |
| 🔍 **全文本搜索** | `./search.sh <query>` — 支持 grep + fzf 模糊检索 |
| 📋 **统一的格式** | 所有的速查表均遵循相同的模板标准 [TEMPLATE.md](../../TEMPLATE.md) |
| ✅ **真实的命令** | 所有命令皆经过严格测试，并标有最近验证日期 |
| 🤝 **社区驱动** | 极度欢迎 PR — 24 小时内快速审核合并 |

---

## 🤝 如何参与贡献

我们极其欢迎任何大小的贡献！

1. 阅读 [贡献指南 (CONTRIBUTING.md)](../../CONTRIBUTING.md) — 仅需 5 分钟。
2. 将 [TEMPLATE.md](../../TEMPLATE.md) 模板复制到正确的分类文件夹中。
3. 填入测试过的常用命令和简短说明。
4. 提交 Pull Request，标题格式为: `Add: [tool name] cheatsheet`

---

## 📜 许可协议

MIT © 2026 [cheatsheets.dev 贡献者](https://github.com/yourusername/cheatsheets.dev/graphs/contributors)

有关完整条款，请参阅 [LICENSE](../../LICENSE)。

---

<div align="center">

**专为开发者、游戏玩家和硬件极客打造 — 随时随地，离线使用，永久免费。**

</div>
