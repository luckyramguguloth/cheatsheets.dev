# 📚 cheatsheets.dev

> **Um repositório. Cada folha de dicas. Offline para sempre.**

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
[![Cheatsheets](https://img.shields.io/badge/cheatsheets-100%2B-blue?style=for-the-badge&logo=bookstack)](https://github.com/yourusername/cheatsheets.dev)
[![License](https://img.shields.io/badge/licenca-MIT-green?style=for-the-badge)](../../LICENSE)
[![Offline](https://img.shields.io/badge/funciona-100%25%20offline-orange?style=for-the-badge&logo=wifi)](https://github.com/yourusername/cheatsheets.dev)

</div>

---

## ✨ Por que este repositório?

- 🔌 **Funciona 100% offline** — clone uma vez, pesquise para sempre. Sem necessidade de internet, nunca.
- 🚫 **Zero anúncios, zero rastreamento, zero paywalls** — sinal puro, sem ruído.
- 🌍 **Completo para todos** — programadores, desenvolvedores DevOps, gamers, técnicos de hardware, sysadmins e estudantes.

---

## 📂 Índice de Categorias

| Categoria | Folhas de Dicas | Descrição |
|---|---|---|
| 🖥️ [Dev](../../dev/) | 30 | Linguagens, frameworks, editores, bancos de dados, APIs |
| 🚀 [DevOps](../../devops/) | 10 | Docker, Kubernetes, CI/CD, provedores de nuvem, redes |
| 🎮 [Gaming](../../gaming/) | 5 | Otimização de PC, emuladores, Windows debloat, game mode |
| 🔧 [Hardware](../../hardware/) | 5 | BIOS, overclocking, RAM, armazenamento, pasta térmica |

---

## ⚡ Início Rápido

```bash
# Clonar o repositório
git clone https://github.com/yourusername/cheatsheets.dev
cd cheatsheets.dev

# Tornar o script de busca executável
chmod +x search.sh

# Buscar qualquer comando instantaneamente
./search.sh "docker stop"
```

> **Sem dependências obrigatórias.** [fzf](https://github.com/junegunn/fzf) é opcional mas ativa a busca interactiva.

---

## 🖥️ Aplicativo Web Interativo (Documentação no Localhost)

Para uma experiência gráfica premium e interativa e um entendimento mais rápido, confira o aplicativo web estático integrado:

```bash
# Iniciar um servidor web local na raiz do repositório
python -m http.server 8000
```

Depois abra seu navegador e navegue para:
👉 **`http://localhost:8000/docs/`**

**Recursos da Vista no Localhost:**
- 🔍 **Busca Instantânea:** Busca fuzzy em tempo real com realce visual (`<mark>`).
- 🗂️ **Filtros de Abas Interativos:** Filtre as folhas dinamicamente por categoria (Dev, DevOps, Gaming, Hardware).
- 🔮 **Modal de Leitura Premium:** Abre e renderiza as folhas markdown em um lindo modal glassmorphic sem recargas de página.
- 📋 **Copiar para a Área de Transferência:** Botões de cópia com um único clique em todos os blocos de código.
- 📴 **100% Seguro Sem Conexão:** Funciona totalmente sem nenhuma conexão ativa de internet.

---

## 📴 Como usar offline

Clone o repositório uma vez e pronto — cada folha é um arquivo Markdown plano que se abre perfeitamente em seu terminal, VS Code ou Obsidian. Abra os arquivos diretamente, use `./search.sh` ou navegue com [Obsidian](https://obsidian.md/), [Typora](https://typora.io/) ou VS Code.

---

## 🔍 Demonstração de Busca

```
$ ./search.sh "docker remove"

 ─────────────────────────────────────────────────────────────
  🔍  cheatsheets.dev — Busca Offline
 ─────────────────────────────────────────────────────────────

  Foram encontrados 3 resultados para "docker remove" em 2 arquivos:

  📄 devops/docker.md
     Linha  87 │ docker rm <container>           # Remover contêiner parado
     Linha  88 │ docker rm -f <container>         # Forçar remoção de contêiner

  📄 devops/kubernetes.md
     Linha 204 │ kubectl delete pod <name>         # Remover um pod

 ─────────────────────────────────────────────────────────────
  Dica: Execute ./search.sh --list para ver todas as folhas
 ─────────────────────────────────────────────────────────────
```

---

## 🚀 Recursos

| Recurso | Detalhes |
|---|---|
| 🔌 **100% Offline** | Clone uma vez, funciona para sempre sem internet |
| 🔍 **Busca Completa** | `./search.sh <query>` — busca integrada grep + fzf |
| 📋 **Formato Consistente** | Cada folha usa o mesmo modelo [TEMPLATE.md](../../TEMPLATE.md) |
| ✅ **Comandos Verificados** | Todos os comandos testados e marcados com data de última verificação |
| 🤝 **Comunidade Ativa** | PRs abertos são bem-vindos — integrados em menos de 24 horas |

---

## 🤝 Como contribuir

Contribuições de todos os tamanhos são muito bem-vindas!

1. Leia o [Guia de Contribuição](../../CONTRIBUTING.md) — leva 5 minutos.
2. Copie o arquivo [TEMPLATE.md](../../TEMPLATE.md) na pasta de categoria correta.
3. Preencha com comandos precisos e testados.
4. Abra um PR com o título: `Add: [tool name] cheatsheet`

---

## 📜 Licença

MIT © 2026 [Colaboradores de cheatsheets.dev](https://github.com/yourusername/cheatsheets.dev/graphs/contributors)

Veja [LICENSE](../../LICENSE) para termos completos.

---

<div align="center">

**Criado para desenvolvedores, gamers e montadores de PC — em todos os lugares, offline, para sempre.**

</div>
