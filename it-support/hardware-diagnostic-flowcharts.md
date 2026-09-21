# Hardware Diagnostic Flowcharts & Fault Triage Cheatsheet

> Systematic triage flowcharts for POST failure, beep codes, power supply testing, thermal shutdown, and motherboard component diagnosis.
> Last verified: May 2026 | Version: ATX12V / EPS12V Standards

---

## Master POST Failure Triage Flowchart

```
                          [Press Power Button]
                                    │
                  ┌─────────────────┴─────────────────┐
                  ▼                                   ▼
             [Fans Spin?]                        [No Power / No Fans]
                  │                                   │
         ┌────────┴────────┐                          ├──> Check PSU I/O switch & AC outlet
         ▼                 ▼                          ├──> Paperclip test on 24-pin PSU
     [Display?]       [No Display]                    └──> Inspect front panel PWR_SW pins
         │                 │
      [Success]   ┌────────┴────────────────┐
                  ▼                         ▼
            [Beep / Q-LED]            [No Beep / No Q-LED]
                  │                         │
                  │                         ├──> Reseat 24-pin & 8-pin EPS power cables
                  │                         └──> Breadboard motherboard outside chassis
                  ▼
   Check Motherboard Diagnostic Code
   (DRAM / CPU / VGA / BOOT)
```

---

## Motherboard Debug LED Diagnostic Matrix

Modern motherboards feature 4 diagnostic LEDs near the 24-pin ATX header:

| LED Label | State | Probable Cause | Action |
|---|---|---|---|
| **CPU** | Solid Red | Missing CPU power, bent socket pins, incompatible BIOS | Reseat 8-pin EPS; inspect LGA socket pins; flash BIOS via USB Flashback |
| **DRAM** | Solid Yellow/Orange | Unseated memory, dirty gold fingers, wrong channel slots | Test single RAM stick in slot A2; clean contacts with 90%+ isopropyl alcohol |
| **VGA** | Solid White | GPU not detected, missing 8-pin PCIe power, HDMI plugged in mobo | Verify monitor cable is in GPU port, not motherboard; reseat GPU in PCIe slot |
| **BOOT** | Solid Green | No bootable OS drive found | Check NVMe seating; verify UEFI/CSM boot order in BIOS |

---

## Power Supply (PSU) Paperclip Test

To verify if a power supply can power on independently of the motherboard:
1. Turn off PSU rocker switch and unplug all cables from PC components.
2. Locate the 24-pin main motherboard connector.
3. Locate **Green wire** (PS_ON# - Pin 16) and any adjacent **Black wire** (Ground - Pin 15 or 17).
4. Insert a conductive paperclip connecting Pin 16 to Pin 17.
5. Plug PSU into wall and toggle power switch to ON.
6. **Result:** If PSU fan spins, the power supply's primary rail is capable of switching on.

---

## ATX Voltage Tolerances (Multimeter Measurement)

Measure with DC voltmeter on yellow/red/orange pins relative to black ground:

| Rail | Nominal Voltage | Minimum Safe | Maximum Safe | Typical Power Use |
|---|---|---|---|---|
| **+12V (Yellow)** | 12.00 V | 11.40 V (-5%) | 12.60 V (+5%) | CPU, GPU, Fans, Liquid Cooling Pumps |
| **+5V (Red)** | 5.00 V | 4.75 V (-5%) | 5.25 V (+5%) | SSDs, HDDs, USB ports, RGB controllers |
| **+3.3V (Orange)** | 3.30 V | 3.135 V (-5%) | 3.465 V (+5%) | Motherboard chipset, PCIe logic, M.2 logic |

---

## Tips & Tricks

- **Breadboarding:** When a PC refuses to POST, remove the motherboard from the computer case and place it on its cardboard box with only CPU, 1 RAM stick, and PSU connected. This eliminates case standoff short circuits.
- **CMOS Clear:** Always disconnect the wall AC power cord before bridging the CLRTC / JBAT1 clear CMOS pins.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
