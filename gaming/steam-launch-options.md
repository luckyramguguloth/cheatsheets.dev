# Steam Launch Options Cheatsheet

> Reference guide for configuring game parameters, Proton tweaks, DXVK variables, and common optimization flags.
> Last verified: May 2026 | Version: Steam Core / Proton 9.x

---

## Quick Reference

| Flag / Parameter | Description |
|---|---|
| `-novid` / `-nosplash` | Skip introductory videos on startup |
| `-high` | Launch game with high CPU priority |
| `-threads X` | Force game to use a specific number of CPU threads |
| `-windowed -noborder` | Run in borderless windowed mode |
| `+fps_max 0` / `+fps_max 144` | Set maximum frames per second limit |
| `PROTON_USE_SECCOMP=1 %command%` | Enable secure sandboxing for Linux gaming |
| `DXVK_HUD=fps %command%` | Display DXVK overlay with FPS metrics (Linux) |

---

## Performance & Optimization Flags

### Source Engine Games (CS2, Dota 2, TF2, Apex Legends)
```bash
# Skip intro, launch in high priority, use native refresh rate, skip DirectX warm-up
-novid -high -refresh 144 -nojoy +fps_max 0
```

### Proton / Wine Launcher Variables (Linux / Steam Deck)
Launch options in Linux can be prefixed with environment variables to customize translation layers:
```bash
# Enable DXVK FPS HUD overlay
DXVK_HUD=fps %command%

# Disable Esync/Fsync for compatibility troubleshooting
PROTON_NO_ESYNC=1 PROTON_NO_FSYNC=1 %command%

# Force Vulkan rendering instead of OpenGL translation
PROTON_USE_WINED3D=0 %command%
```

---

## Tips & Tricks

- **The `%command%` rule:** When using environment variables (like `DXVK_HUD=1`), you MUST append `%command%` to the end of the launch options line so Steam knows where to inject the variables into the actual game startup process.
- **Windowed Borderless:** Modern games run best in "Windowed Borderless" (`-windowed -noborder`) which allows rapid Alt-Tabbing without crashing.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
