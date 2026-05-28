# FPS Troubleshooting Cheatsheet

> Diagnostic flows and actionable troubleshooting commands for resolving stuttering, low FPS, and screen tearing.
> Last verified: May 2026 | Version: Windows & Linux Systems

---

## Quick Reference

| Symptom | Probable Cause | Quick Fix |
|---|---|---|
| Consistent low FPS | CPU/GPU bottleneck or power limit | Enable High Performance power plan, check temps |
| Micro-stutters (1% low drops) | Background processes, shader compiling | Close apps, enable shader caching, use SSD |
| Screen tearing | Display refresh rate mismatch | Enable G-Sync / FreeSync, use V-Sync |
| Sudden FPS drops after 10 min | Thermal throttling | Clean dust, re-paste thermal paste, adjust fans |

---

## Diagnostics Flow

### 1. Identify Bottlenecks
Use monitoring overlays (MSI Afterburner on Windows, MangoHud on Linux) to view utilization:
- **GPU at 95%+:** Normal in modern gaming. Max graphics settings.
- **GPU below 85% and CPU Core at 100%:** CPU Bottleneck. Lower settings that affect CPU (draw distance, physics, shadows).
- **RAM / VRAM at 100%:** Out of memory bottleneck. Close browser, lower texture resolution.

### 2. Check Input Lag & Driver Latency (Windows)
Run `LatencyMon` (free utility) to test kernel driver execution times:
- If `dxgkrnl.sys` or `nvlddmkm.sys` has high latency, perform a clean GPU driver install.
- If `ndis.sys` has high latency, disable Wi-Fi/Ethernet energy-efficient features.

---

## Tips & Tricks

- **Disable HAGS (Hardware Accelerated GPU Scheduling):** HAGS is known to cause micro-stutters and crashes in VR titles and specific DirectX 12 games. Toggle it off in Windows Graphic Settings.
- **Monitor Refresh Rate:** Verify your Windows/Linux monitor display settings are actually configured to your display's max refresh rate (e.g. 144Hz/240Hz) rather than defaulting to 60Hz.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
