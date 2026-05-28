# 📚 cheatsheets.dev

> **Un repositorio. Cada hoja de trucos. Fuera de línea para siempre.**

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

[![Stars](https://img.shields.io/github/stars/luckyramguguloth/cheatsheets.dev?style=for-the-badge&logo=github&color=FFD700)](https://github.com/luckyramguguloth/cheatsheets.dev/stargazers)
[![Contributors](https://img.shields.io/github/contributors/luckyramguguloth/cheatsheets.dev?style=for-the-badge&logo=github&color=4CAF50)](https://github.com/luckyramguguloth/cheatsheets.dev/graphs/contributors)
[![Cheatsheets](https://img.shields.io/badge/cheatsheets-100%2B-blue?style=for-the-badge&logo=bookstack)](https://github.com/luckyramguguloth/cheatsheets.dev)
[![License](https://img.shields.io/badge/licencia-MIT-green?style=for-the-badge)](../../LICENSE)
[![Offline](https://img.shields.io/badge/funciona-100%25%20offline-orange?style=for-the-badge&logo=wifi)](https://github.com/luckyramguguloth/cheatsheets.dev)

</div>

---

## ✨ ¿Por qué este repositorio?

- 🔌 **Funciona 100% fuera de línea** — clona una vez, busca para siempre. Sin necesidad de internet, nunca.
- 🚫 **Sin anuncios, sin rastreo, sin muros de pago** — señal pura, cero distracciones.
- 🌍 **Para todos** — desarrolladores, ingenieros DevOps, jugadores, ensambladores de hardware, sysadmins y estudiantes.

---

## 📂 Índice de Categorías

| Categoría | Hojas de Trucos | Descripción |
|---|---|---|
| 🖥️ [Dev](../../dev/) | 30 | Lenguajes, frameworks, editores, bases de datos, APIs |
| 🚀 [DevOps](../../devops/) | 10 | Docker, Kubernetes, CI/CD, proveedores de nube, redes |
| 🎮 [Gaming](../../gaming/) | 5 | Optimización de PC, emuladores, Windows debloat, game mode |
| 🔧 [Hardware](../../hardware/) | 5 | BIOS, overclocking, RAM, almacenamiento, pasta térmica |

---

## ⚡ Inicio Rápido

```bash
# Clonar el repositorio
git clone https://github.com/yourusername/cheatsheets.dev
cd cheatsheets.dev

# Hacer ejecutable el script de búsqueda
chmod +x search.sh

# Buscar cualquier tema al instante
./search.sh "docker stop"
```

> **Sin dependencias obligatorias.** [fzf](https://github.com/junegunn/fzf) es opcional pero activa la búsqueda interactiva.

---

## 🖥️ Aplicación Web Interactiva (Documentación en Localhost)

Para una experiencia gráfica premium e interactiva y un entendimiento más rápido, prueba la aplicación web estática integrada:

```bash
# Iniciar un servidor web local en la raíz del repositorio
python -m http.server 8000
```

Luego abre tu navegador y navega a:
👉 **`http://localhost:8000/docs/`**

**Características de la Vista en Localhost:**
- 🔍 **Búsqueda Instantánea:** Búsqueda fuzzy en tiempo real con resaltado visual (`<mark>`).
- 🗂️ **Filtros de Pestañas Interactivos:** Filtra las hojas dinámicamente por categoría (Dev, DevOps, Gaming, Hardware).
- 🔮 **Modal de Lectura Premium:** Abre y renderiza las hojas markdown en un hermoso modal glassmorphic sin recargas de página.
- 📋 **Copiar al Portapapeles:** Botones de copia con un solo clic en todos los bloques de código.
- 📴 **100% Seguro Sin Conexión:** Funciona completamente sin ninguna conexión activa a internet.

---

## 📴 Cómo usar fuera de línea

Clona el repositorio una vez y listo — cada hoja es un archivo Markdown plano que se abre perfectamente en tu terminal, VS Code u Obsidian. Abre los archivos directamente, usa `./search.sh` o navega con [Obsidian](https://obsidian.md/), [Typora](https://typora.io/) o VS Code.

---

## 🔍 Demostración de Búsqueda

```
$ ./search.sh "docker remove"

 ─────────────────────────────────────────────────────────────
  🔍  cheatsheets.dev — Búsqueda Fuera de Línea
 ─────────────────────────────────────────────────────────────

  Se encontraron 3 coincidencias para "docker remove" en 2 archivos:

  📄 devops/docker.md
     Línea  87 │ docker rm <container>           # Eliminar contenedor detenido
     Línea  88 │ docker rm -f <container>         # Forzar eliminación de contenedor

  📄 devops/kubernetes.md
     Línea 204 │ kubectl delete pod <name>         # Eliminar un pod

 ─────────────────────────────────────────────────────────────
  Consejo: Ejecuta ./search.sh --list para ver todas las hojas
 ─────────────────────────────────────────────────────────────
```

---

## 🚀 Características

| Característica | Detalles |
|---|---|
| 🔌 **100% Offline** | Clona una vez, funciona para siempre sin internet |
| 🔍 **Búsqueda Completa** | `./search.sh <query>` — búsqueda integrada grep + fzf |
| 📋 **Formato Consistente** | Cada hoja usa la misma plantilla [TEMPLATE.md](../../TEMPLATE.md) |
| ✅ **Comandos Verificados** | Todos los comandos probados y marcados con fecha de última verificación |
| 🤝 **Comunidad Activa** | PRs abiertos son bienvenidos — fusionados en menos de 24 horas |

---

## 🤝 Cómo contribuir

¡Aceptamos contribuciones de todos los tamaños!

1. Lee la [Guía de Contribución](../../CONTRIBUTING.md) — toma 5 minutos.
2. Copia la plantilla [TEMPLATE.md](../../TEMPLATE.md) en la carpeta de la categoría correcta.
3. Completa con comandos precisos y probados.
4. Abre un PR con el título: `Add: [tool name] cheatsheet`

---

## 📜 Licencia

MIT © 2026 [Colaboradores de cheatsheets.dev](https://github.com/luckyramguguloth/cheatsheets.dev/graphs/contributors)

Ver [LICENSE](../../LICENSE) para los términos completos.

---

<div align="center">

**Creado para desarrolladores, jugadores y ensambladores de sistemas — en todas partes, sin conexión, para siempre.**

</div>
