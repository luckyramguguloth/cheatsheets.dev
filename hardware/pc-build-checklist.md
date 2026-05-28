# PC Build Checklist Cheatsheet

> Step-by-step master reference for PC assembly, verification, and first-boot troubleshooting.
> Last verified: May 2026 | Version: ATX Standard

---

## The Master Build Order

```
[Phase 1: Motherboard Prep] ──> [Phase 2: Case Prep] ──> [Phase 3: PSU & Cable Routing]
               │                                                │
               ▼                                                ▼
     Install CPU, RAM, & SSD                          Mount Motherboard & CPU Cooler
                                                                │
                                                                ▼
                                                      [Phase 4: GPU & Expansion]
                                                                │
                                                                ▼
                                                      [Phase 5: First Boot & POST]
```

---

## Detailed Steps

### Phase 1: Motherboard Preparation (Do this on the motherboard box!)
- [ ] **Unbox Motherboard:** Place it on top of its non-conductive box. Do NOT place it on the anti-static bag (which is conductive on the outside).
- [ ] **Install CPU:**
  - **Intel (LGA):** Align gold triangle on CPU with gold triangle on socket. Lower clamp; do not touch LGA pins.
  - **AMD (AM5):** Same alignment mechanism. Lower arm. Keep the plastic socket cover in place; it will pop off automatically when tightening the lever.
- [ ] **Install RAM:** Ensure dual-channel slots are populated first (usually slots 2 and 4, labeled A2 and B2). Push until it clicks on both ends.
- [ ] **Install M.2 NVMe SSD:** Insert at 30° angle, push down, secure with screw or quick-latch. Remove peel-off plastic cover from motherboard heatsink pad.

### Phase 2: Case Preparation & Motherboard Mounting
- [ ] **Mount I/O Shield:** (Skip if motherboard has a pre-installed integrated I/O shield).
- [ ] **Motherboard Standoffs:** Ensure standoffs in case align *exactly* with motherboard screw holes. Extra standoffs can cause a short circuit.
- [ ] **CPU Cooler Mounting:** 
  - Install mounting brackets.
  - Apply thermal paste (if not pre-applied).
  - Mount AIO pump or air heatsink. Tighten screws in a cross pattern for even pressure.
  - Plug fan/pump connector into `CPU_FAN` or `AIO_PUMP` headers.

---

## Tips & Tricks

- **The GPU Click:** Always pull the PCIe slot retention clip back *before* inserting the GPU. Push the card down firmly until the clip clicks locked.
- **Cable Management:** Feed power cables through the case cutouts *before* mounting the motherboard, especially the 8-pin CPU EPS cable at the top left.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
