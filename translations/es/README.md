# 📚 cheatsheets.dev (v2.0)

> **Un repositorio. Cada hoja de trucos. Comandos reales de producción. Fuera de línea para siempre.**

<p align="center">
  🌐
  <a href="../../README.md">English</a> |
  <a href="README.md">Español</a> |
  <a href="../hi/README.md">हिन्दी</a> |
  <a href="../pt/README.md">Português</a> |
  <a href="../zh/README.md">简体中文</a> |
  <a href="../ar/README.md">العربية</a>
</p>

<div align="center">

[![Stars](https://img.shields.io/github/stars/yourusername/cheatsheets.dev?style=for-the-badge&logo=github&color=FFD700)](https://github.com/yourusername/cheatsheets.dev/stargazers)
[![Contributors](https://img.shields.io/github/contributors/yourusername/cheatsheets.dev?style=for-the-badge&logo=github&color=4CAF50)](https://github.com/yourusername/cheatsheets.dev/graphs/contributors)
[![Cheatsheets](https://img.shields.io/badge/cheatsheets-74%20hojas-blue?style=for-the-badge&logo=bookstack)](https://github.com/yourusername/cheatsheets.dev)
[![License](https://img.shields.io/badge/licencia-MIT-green?style=for-the-badge)](../../LICENSE)
[![Offline](https://img.shields.io/badge/funciona-100%25%20offline-orange?style=for-the-badge&logo=wifi)](https://github.com/yourusername/cheatsheets.dev)

</div>

---

## ✨ ¿Por qué este repositorio?

- 🔌 **Funciona 100% fuera de línea** — clona una vez, busca para siempre. Cero dependencia de internet.
- 🚫 **Sin anuncios, sin rastreo, sin muros de pago** — comandos auténticos y verificados sin contenido sintético artificial.
- 🌍 **Diseñado para todos** — Desarrolladores de software, ingenieros DevOps, profesionales de IA/ML, arquitectos de sistemas, técnicos de soporte TI, ensambladores de PC y gamers.
- 🛡️ **Guías de recuperación ante desastres y caídas** — Procedimientos detallados para diagnosticar y recuperarse de interrupciones de producción, kernel panics, fallos de memoria OOM, ransomware, bucles de arranque y fallos de red.

---

## 📂 Índice de Categorías (74 Hojas de Trucos en Total)

| Categoría | Hojas | Enfoque y Temas de Producción |
|---|:---:|---|
| 🖥️ [Dev](../../dev/) | 30 | Git, Bash, Vim, Docker, SQL, Python, JS, TS, Go, Rust, C++, Regex, HTTP, comandos Linux, JSON/YAML, etc. |
| 🚀 [DevOps](../../devops/) | 10 | Kubernetes (`kubectl`), Terraform, GitHub Actions, systemd, iptables, Prometheus, Ansible, CLI de AWS/GCP/Azure |
| 🎮 [Gaming](../../gaming/) | 5 | Optimización de PC, emuladores, Windows debloat, modo de juego, reducción de latencia |
| 🔧 [Hardware](../../hardware/) | 5 | Configuración de BIOS, overclocking de RAM y tiempos, salud de SSD/NVMe, pasta térmica y disipación, lista de ensamblaje |
| 🤖 [AI & ML](../../ai-ml/) | 8 | PyTorch, TensorFlow, HuggingFace, Afinamiento de LLMs (LoRA/QLoRA), Inferencia Local (vLLM/Ollama), RAG y Bases Vectoriales, Diagnóstico de GPU/CUDA, MLOps y Evaluación |
| ⚙️ [Sistemas](../../systems/) | 8 | Optimización del Kernel Linux, Perfilado con eBPF y Perf, Almacenamiento ZFS y Btrfs, Clústeres de Alta Disponibilidad (Pacemaker/Corosync), Hardening Empresarial, Virtualización KVM/Proxmox, Almacenamiento Distribuido (Ceph), Recuperación ante Ransomware |
| 🛠️ [Soporte TI](../../it-support/) | 8 | Recuperación ante Desastres en Windows (BSOD/WinRE), Rescate y Recuperación en macOS, Rescate de Red y Análisis de Paquetes, Identidad y Active Directory, Recuperación de Datos y Análisis Forense, Respuesta a Incidentes de Ciberseguridad, Diagnóstico de Impresoras y Periféricos, Diagramas de Flujo de Diagnóstico de Hardware |

---

## ⚡ Inicio Rápido

```bash
# Clonar el repositorio
git clone https://github.com/yourusername/cheatsheets.dev
cd cheatsheets.dev/version2

# Hacer ejecutable el script de búsqueda (Linux/macOS)
chmod +x search.sh

# Buscar cualquier comando o guía de recuperación en las 74 hojas
./search.sh "cuda oom"
```

> **Sin dependencias obligatorias.** [fzf](https://github.com/junegunn/fzf) es opcional pero activa la búsqueda interactiva fuzzy.

---

## 🖥️ Aplicación Web Interactiva (Documentación en Localhost)

Para una experiencia visual ágil, moderna y completa con búsqueda instantánea y renderizado directo de Markdown, inicia el visor web local integrado:

```bash
# Iniciar un servidor web local en el directorio version2
python -m http.server 8000
```

Luego abre tu navegador e ingresa a:
👉 **`http://localhost:8000/docs/`**

**Características del Visor en Localhost:**
- 🔍 **Búsqueda Dinámica Instantánea:** Filtrado en tiempo real con resaltado visual (`<mark>`).
- 🗂️ **7 Pestañas de Filtro por Categoría:** Alterna al instante entre Todas (74), Dev (30), DevOps (10), Gaming (5), Hardware (5), AI & ML (8), Sistemas (8) y Soporte TI (8).
- 🔮 **Modal de Lectura Glassmorphic:** Lee y da formato a las hojas de trucos en pantalla sin recargar la página.
- 📋 **Copia de Código en Un Clic:** Botón dedicado para copiar cualquier instrucción CLI o bloque de configuración.
- 📴 **100% Seguro Fuera de Línea:** Sin dependencias externas ni CDNs remotos.

---

## 📴 Cómo usar fuera de línea

Clona el repositorio una vez y listo: cada hoja de trucos es un archivo Markdown estándar que se visualiza perfectamente en cualquier terminal, editor o visor como [Obsidian](https://obsidian.md/), [Typora](https://typora.io/) o VS Code.

---

## 🔍 Demostración de Búsqueda

```
$ ./search.sh "cuda oom"

 ─────────────────────────────────────────────────────────────
  🔍  cheatsheets.dev (v2.0) — Búsqueda Fuera de Línea
 ─────────────────────────────────────────────────────────────

  Se encontraron 4 coincidencias para "cuda oom" en 2 archivos:

  📄 ai-ml/cuda-gpu-troubleshooting.md
     Línea  84 │ export PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True
     Línea  89 │ torch.cuda.empty_cache(); gc.collect()

  📄 ai-ml/pytorch.md
     Línea 142 │ with torch.no_grad(): output = model(inputs)

 ─────────────────────────────────────────────────────────────
  Consejo: Ejecuta ./search.sh --list para ver las 74 hojas disponibles
 ─────────────────────────────────────────────────────────────
```

---

## 🚀 Características

| Característica | Detalles |
|---|---|
| 🔌 **100% Fuera de Línea** | Clona una vez y funciona siempre sin internet |
| 🔍 **Búsqueda CLI Completa** | `./search.sh <término>` — grep con selector fzf opcional |
| 🖥️ **Visor Web Interactivo** | Interfaz web integrada sin dependencias en `docs/` |
| 📋 **Formato Estandarizado** | Cada hoja sigue la estructura uniforme de [TEMPLATE.md](TEMPLATE.md) |
| ✅ **Comandos Reales de Producción** | Parámetros probados, diagnósticos reales y guías de rescate |
| 🌍 **Soporte Multilingüe** | Archivos README completos en 6 idiomas |
| 🤝 **Impulsado por la Comunidad** | Licencia MIT, listo para contribuciones y PRs |

---

## 🤝 Cómo Contribuir

¡Las contribuciones de la comunidad son bienvenidas!

1. Lee [CONTRIBUTING.md](CONTRIBUTING.md) — toma menos de 5 minutos.
2. Copia [TEMPLATE.md](TEMPLATE.md) en la carpeta de categoría correspondiente.
3. Rellena los comandos reales verificados y ejemplos prácticos.
4. Envía un Pull Request titulado: `Add: [nombre-de-herramienta] cheatsheet`

---

## 📜 Licencia

MIT © 2026 [cheatsheets.dev contributors](https://github.com/yourusername/cheatsheets.dev/graphs/contributors)

Consulta [LICENSE](LICENSE) para los términos completos.

---

<div align="center">

**Creado para desarrolladores, ingenieros DevOps, investigadores de IA, sysadmins y técnicos de TI — en todas partes, fuera de línea, para siempre.**

</div>
