# Linux Gaming Optimization Cheatsheet

> Reference guide for configuring Feral GameMode, Proton, MangoHud, custom kernels, and driver optimizations.
> Last verified: May 2026 | Version: Linux Kernel 6.x / Proton 9.x

---

## Quick Reference

| Feature | Action / Flag | Description |
|---|---|---|
| Feral GameMode | `gamemoderun %command%` | CPU governor performance mode, dynamic nice priorities |
| MangoHud Overlay | `mangohud %command%` | Premium FPS, temp, RAM, and CPU core utilization HUD |
| CPU Governor | `cpupower frequency-set -g performance` | Force all CPU cores to maximum performance state |
| GPU Performance | `nvidia-smi -pm 1` | Set NVIDIA GPU persistence mode to prevent downclocking |

---

## Feral GameMode Configurations

GameMode optimizes Linux performance on the fly when games are launched:
```bash
# Run steam game inside gamemode (add in steam launch options)
gamemoderun %command%

# Run any standalone terminal game/emulator with gamemode
gamemoderun lutris
```

---

## MangoHud Custom HUD Overlay

Create custom config file at `~/.config/MangoHud/MangoHud.conf`:
```text
# Performance stats to show
fps
frame_timing
cpu_stats
cpu_temp
gpu_stats
gpu_temp
ram
vram
hud_position=top-left
font_size=18
```

---

## Tips & Tricks

- **Use Zen Kernel:** For gaming, run custom kernels like `linux-zen` (Arch) or `liquorix` (Ubuntu) which feature low-latency thread scheduling optimized for interactive applications.
- **Vulkan Shader Caching:** Enable background shader processing in Steam (Settings > Shader Pre-Caching) to completely eliminate in-game micro-stuttering.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
