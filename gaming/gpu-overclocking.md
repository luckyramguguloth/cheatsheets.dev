# GPU Overclocking Cheatsheet

> Safe reference guide for GPU overclocking, voltage adjustments, monitoring, and stability testing.
> Last verified: May 2026 | Version: NVIDIA & AMD Core

---

## Quick Reference

| Metric | Target / Range (Varies by Model) | Action |
|---|---|---|
| Safe Core OC | +50 MHz to +150 MHz | Boost gaming frames / throughput |
| Safe Memory OC | +200 MHz to +1000 MHz | Boost high-resolution performance |
| Power Limit | Increase to max (110% - 120%) | Prevents power limit throttling |
| Temp Limit | Safe up to 83°C (95°C Max) | Adjusts thermal throttling target |
| Fan Curve | Custom aggressive profile | Maintains lower temps, preserves clocks |

---

## Step-by-Step Overclocking Workflow (MSI Afterburner)

```bash
# 1. Benchmark: Run a baseline benchmark (e.g., Unigine Heaven / 3DMark) to establish baseline scores and temps.
# 2. Power & Temp Limit: Slide Power Limit and Temp Limit to their maximum values in Afterburner (safe; built-in safeguards remain active).
# 3. Core Overclock:
#    - Increase Core Clock by +50 MHz.
#    - Run a quick stability test.
#    - Repeat in increments of +15 MHz until instability or artifacts appear, then dial back by 20 MHz.
# 4. Memory Overclock:
#    - Increase Memory Clock by +100 MHz.
#    - Repeat in increments of +50 MHz until stable limits are found.
# 5. Long-term Stability: Run a loops benchmark or heavy game for 2 hours.
```

---

## AMD Radeon Software Adrenalin Settings

For AMD graphics cards, overclocking is performed directly in the official software:
- Navigate to **Performance** > **Tuning**.
- Change Tuning Control to **Manual** > Enable **GPU Tuning** and **VRAM Tuning**.
- Adjust **Max Frequency %** in increments of 2%.
- Enable **Fast Timing** under VRAM Memory Tuning for a free bandwidth bump.

---

## Tips & Tricks

- **Avoid Instant Artifacts:** If you see white dots, colored flashes, or game crashes, your core clock is too high. If the game crashes to desktop instantly or the display driver resets, your memory clock is too high.
- **Save Profiles:** Always save stable profiles in Afterburner and set them to load *only* after Windows fully boots, rather than launching on startup immediately in case of a crash loop.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
