# RAM Configuration & Overclocking Cheatsheet

> Quick reference for enabling XMP/EXPO profiles, understanding memory timings, and validating stability.
> Last verified: May 2026 | Version: DDR4 & DDR5 Standard

---

## Quick Reference

| Profile Name | Platforms | Purpose |
|---|---|---|
| **XMP (eXtreme Memory Profile)** | Intel (supported on AMD) | Automatically applies tested frequencies, voltages, and timings |
| **EXPO (Extended Profiles for OC)** | AMD Ryzen (AM5+) | AMD's open standard for memory profile tuning, optimized for Infinity Fabric |
| **D.O.C.P. / E.O.C.P.** | ASUS Motherboards | Asus translation layer for XMP profiles on AMD platforms |

---

## Understanding Memory Timings (Primary)

Primary timings look like `16-18-18-38` or `30-40-40-96`:
- **CL (CAS Latency):** Clock cycles needed to access data. Lower is better.
- **tRCD (RAS to CAS Delay):** Cycles between active command and read/write.
- **tRP (Row Precharge Time):** Cycles to open a new line/page of memory.
- **tRAS (Active to Precharge Delay):** Minimum cycles a row must remain active.

```bash
# General Performance Rule:
# Frequency / Latency ratio determines real latency.
# DDR5 6000 CL30 is the modern sweet spot for AMD Ryzen 7000/9000.
```

---

## Stability Validation Workflow

Always validate memory settings to prevent silent OS corruption:
```bash
# 1. Enable XMP/EXPO in BIOS -> Save and Reboot.
# 2. Boot into OS and open terminal/CMD.
# 3. Download MemTest86, TestMem5 (with Anta777 profile), or HCI MemTest.
# 4. Run MemTest for at least 3 passes or 400% coverage.
# 5. If even 1 error is detected, XMP/EXPO is unstable. Manually bump RAM voltage by 0.01V or lower frequency.
```

---

## Tips & Tricks

- **Dual Channel configuration:** Always place two RAM sticks in slots **A2 and B2** (slots 2 and 4 from the CPU). Running them in adjacent slots (A1 and A2) limits the CPU to single-channel bandwidth, cutting gaming performance by up to 30%.
- **Safe Voltages:** DDR4 safe daily limit is `1.35V - 1.45V`. DDR5 safe daily limit is `1.35V - 1.43V`.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
