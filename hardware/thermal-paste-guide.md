# Thermal Paste Application Cheatsheet

> Reference guide for thermal compound types, application styles, cleaning procedures, and monitoring.
> Last verified: May 2026 | Version: Desktop CPU Standard

---

## Thermal Paste Application Styles

| Method | Visual Style | Best For | Description |
|---|---|---|---|
| **Pea Size (Center)** | `●` | Standard Intel/AMD CPUs | Simple, auto-spreads evenly under direct cooler mounting pressure |
| **X Method** | `✕` | Large CPUs (Intel LGA1700, Threadripper) | Ensures solid corner-to-corner coverage on rectangular heatspreaders |
| **Spread Method** | `■` | Bare Die (Laptops, GPUs) | Manual spread using plastic spatula to guarantee 100% direct contact |
| **5-Dot Pattern** | `⁙` | Large heatspreaders | Even distribution across all regions of square dies |

---

## Step-by-Step Repasting Procedure

```bash
# 1. Clean old paste:
#    - Wipe off heavy paste with a dry paper towel.
#    - Wet a microfiber cloth with Isopropyl Alcohol (90%+) and clean the surface until it is mirror-like.
# 2. Inspect surface: Ensure CPU and cooler base are 100% dry and free of residue or fibers.
# 3. Apply compound: Use a pea-sized dot in the center for normal desktop chips, or the X method for LGA 1700.
# 4. Mount cooler: Lower cooler straight down onto the CPU. Tighten mounting screws in a cross pattern (1-4-2-3) to ensure even distribution.
# 5. Test temperatures: Boot up and run HWiNFO64 to verify idle temps (30°C - 45°C) and load temps (< 85°C).
```

---

## Thermal Compound Types

- **Ceramic / Silicon:** Cheap, non-conductive, does not degrade, decent performance (e.g. Noctua NT-H1, Arctic MX-4).
- **Carbon-based:** Exceptional thermals, non-conductive, long-lasting, slightly thicker (e.g. Thermal Grizzly Kryonaut).
- **Liquid Metal:** Absolute best thermal conductivity, but **electrically conductive**. Corrodes aluminum cooler plates instantly. Use only on copper/nickel-plated bases and apply protective tape around the die.

---

## Tips & Tricks

- **Don't use too much:** Excess thermal paste will overflow onto the motherboard socket. While ceramic pastes are non-conductive and won't short-circuit components, excess paste is messy and makes future CPU removal difficult.
- **The "Twist and Pull" rule:** When removing an older cooler (especially on older AMD PGA sockets), run a game for 10 minutes to warm up and soften the paste first. Then, twist the cooler gently back and forth before pulling it up to prevent pulling the CPU straight out of its locked socket.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
