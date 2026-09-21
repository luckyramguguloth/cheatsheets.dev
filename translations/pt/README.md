# 📚 cheatsheets.dev (v2.0)

> **Um repositório. Todas as folhas de dicas. Comandos reais de produção. Offline para sempre.**

<p align="center">
  🌐
  <a href="../../README.md">English</a> |
  <a href="../es/README.md">Español</a> |
  <a href="../hi/README.md">हिन्दी</a> |
  <a href="README.md">Português</a> |
  <a href="../zh/README.md">简体中文</a> |
  <a href="../ar/README.md">العربية</a>
</p>

<div align="center">

[![Stars](https://img.shields.io/github/stars/yourusername/cheatsheets.dev?style=for-the-badge&logo=github&color=FFD700)](https://github.com/yourusername/cheatsheets.dev/stargazers)
[![Contributors](https://img.shields.io/github/contributors/yourusername/cheatsheets.dev?style=for-the-badge&logo=github&color=4CAF50)](https://github.com/yourusername/cheatsheets.dev/graphs/contributors)
[![Cheatsheets](https://img.shields.io/badge/cheatsheets-74%20folhas-blue?style=for-the-badge&logo=bookstack)](https://github.com/yourusername/cheatsheets.dev)
[![License](https://img.shields.io/badge/licenca-MIT-green?style=for-the-badge)](../../LICENSE)
[![Offline](https://img.shields.io/badge/funciona-100%25%20offline-orange?style=for-the-badge&logo=wifi)](https://github.com/yourusername/cheatsheets.dev)

</div>

---

## ✨ Por que este repositório?

- 🔌 **Funciona 100% offline** — clone uma vez, consulte para sempre. Zero dependência de internet.
- 🚫 **Zero anúncios, zero rastreamento, zero paywalls** — comandos autênticos e verificados, sem informações fictícias ou geradas sem validação.
- 🌍 **Feito para todos** — Desenvolvedores de software, engenheiros DevOps, pesquisadores de IA/ML, arquitetos de sistemas, técnicos de suporte de TI, entusiastas de hardware e gamers.
- 🛡️ **Procedimentos de Recuperação de Desastres e Falhas** — Etapas completas para diagnosticar e recuperar interrupções de produção, kernel panics, erros de OOM, ataques de ransomware, loops de inicialização e panes de rede.

---

## 📂 Índice de Categorias (74 Folhas de Dicas no Total)

| Categoria | Folhas | Foco e Temas de Produção |
|---|:---:|---|
| 🖥️ [Dev](../../dev/) | 30 | Git, Bash, Vim, Docker, SQL, Python, JS, TS, Go, Rust, C++, Regex, HTTP, comandos Linux, JSON/YAML, etc. |
| 🚀 [DevOps](../../devops/) | 10 | Kubernetes (`kubectl`), Terraform, GitHub Actions, systemd, iptables, Prometheus, Ansible, CLIs AWS/GCP/Azure |
| 🎮 [Gaming](../../gaming/) | 5 | Otimização de PC, emuladores, Windows debloat, modo de jogo, redução de latência |
| 🔧 [Hardware](../../hardware/) | 5 | Configurações de BIOS, overclocking e timings de RAM, saúde de SSD/NVMe, pasta térmica e refrigeração, checklist de montagem |
| 🤖 [AI & ML](../../ai-ml/) | 8 | PyTorch, TensorFlow, HuggingFace, Ajuste Fino de LLM (LoRA/QLoRA), Servidores Locais de LLM (vLLM/Ollama), RAG e Bancos Vetoriais, Diagnóstico de GPU/CUDA, MLOps e Avaliação |
| ⚙️ [Sistemas](../../systems/) | 8 | Otimização do Kernel Linux, Profiling com eBPF e Perf, Armazenamento ZFS e Btrfs, Clusters de Alta Disponibilidade (Pacemaker/Corosync), Hardening de Segurança, Virtualização KVM/Proxmox, Armazenamento Distribuído (Ceph), Recuperação contra Ransomware |
| 🛠️ [Suporte de TI](../../it-support/) | 8 | Recuperação do Windows (BSOD/WinRE), Resgate e Recuperação do macOS, Diagnóstico e Resgate de Redes, Identidade e Active Directory, Recuperação de Dados e Computação Forense, Resposta a Incidentes de Segurança, Diagnóstico de Impressoras e Periféricos, Fluxogramas de Diagnóstico de Hardware |

---

## ⚡ Início Rápido

```bash
# Clonar o repositório
git clone https://github.com/yourusername/cheatsheets.dev
cd cheatsheets.dev/version2

# Tornar o script de busca executável (Linux/macOS)
chmod +x search.sh

# Buscar qualquer comando ou procedimento nas 74 folhas
./search.sh "cuda oom"
```

> **Sem dependências obrigatórias.** [fzf](https://github.com/junegunn/fzf) é opcional, mas ativa a pesquisa fuzzy interativa.

---

## 🖥️ Aplicativo Web Interativo (Documentação no Localhost)

Para uma experiência visual rica, moderna e intuitiva com pesquisa em tempo real e visualização de Markdown, inicie o leitor local integrado:

```bash
# Iniciar um servidor web simples no diretório version2
python -m http.server 8000
```

Em seguida, abra o navegador e acesse:
👉 **`http://localhost:8000/docs/`**

**Recursos do Aplicativo no Localhost:**
- 🔍 **Busca Dinâmica em Tempo Real:** Filtragem ágil por palavras-chave com destaque visual (`<mark>`).
- 🗂️ **7 Abas de Filtro por Categoria:** Alterne instantaneamente entre Todas (74), Dev (30), DevOps (10), Gaming (5), Hardware (5), AI & ML (8), Sistemas (8) e Suporte de TI (8).
- 🔮 **Leitor Glassmorphic:** Visualize folhas de consulta instantaneamente em um modal elegante sem recarregar a página.
- 📋 **Cópia de Código com Um Clique:** Botão dedicado para copiar qualquer comando ou trecho de configuração.
- 📴 **100% Seguro Offline:** Sem qualquer dependência externa ou CDNs remotos.

---

## 📴 Como Usar Offline

Basta clonar o repositório uma vez: cada folha de dicas é um arquivo Markdown comum que pode ser lido em qualquer terminal, editor ou em ferramentas como [Obsidian](https://obsidian.md/), [Typora](https://typora.io/) e VS Code.

---

## 🔍 Demonstração de Busca

```
$ ./search.sh "cuda oom"

 ─────────────────────────────────────────────────────────────
  🔍  cheatsheets.dev (v2.0) — Busca Offline
 ─────────────────────────────────────────────────────────────

  Encontradas 4 correspondências para "cuda oom" em 2 arquivos:

  📄 ai-ml/cuda-gpu-troubleshooting.md
     Linha  84 │ export PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True
     Linha  89 │ torch.cuda.empty_cache(); gc.collect()

  📄 ai-ml/pytorch.md
     Linha 142 │ with torch.no_grad(): output = model(inputs)

 ─────────────────────────────────────────────────────────────
  Dica: Execute ./search.sh --list para ver todas as 74 folhas
 ─────────────────────────────────────────────────────────────
```

---

## 🚀 Recursos

| Recurso | Detalhes |
|---|---|
| 🔌 **100% Offline** | Clone uma vez, funciona sempre sem precisar de internet |
| 🔍 **Busca Completa na CLI** | `./search.sh <termo>` — grep com seletor fzf opcional |
| 🖥️ **Leitor Web Integrado** | Interface moderna com zero dependências em `docs/` |
| 📋 **Formato Padronizado** | Todas as folhas utilizam a estrutura oficial de [TEMPLATE.md](TEMPLATE.md) |
| ✅ **Comandos Reais de Produção** | Sintaxe validada, flags de emergência e playbooks de recuperação |
| 🌍 **Multilíngue** | Arquivos README completos e fiéis em 6 idiomas |
| 🤝 **Código Aberto** | Licença MIT, pronto para colaborações e pull requests |

---

## 🤝 Como Contribuir

Contribuições da comunidade são muito bem-vindas!

1. Leia [CONTRIBUTING.md](CONTRIBUTING.md) — leva menos de 5 minutos.
2. Copie [TEMPLATE.md](TEMPLATE.md) para a pasta da categoria correspondente.
3. Preencha com comandos reais testados e explicações objetivas.
4. Envie um Pull Request intitulado: `Add: [nome-da-ferramenta] cheatsheet`

---

## 📜 Licença

MIT © 2026 [cheatsheets.dev contributors](https://github.com/yourusername/cheatsheets.dev/graphs/contributors)

Consulte o arquivo [LICENSE](LICENSE) para termos legais completos.

---

<div align="center">

**Criado para desenvolvedores, engenheiros DevOps, pesquisadores de IA, administradores de sistemas e técnicos de TI — em todos os lugares, offline, para sempre.**

</div>
