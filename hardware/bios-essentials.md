# BIOS/UEFI Essentials Cheatsheet

> Step-by-step navigation, critical features, and configuration settings for PC motherboards.
> Last verified: May 2026 | Version: Modern UEFI Standard

---

## Quick Reference

| Vendor | BIOS Access Key | Common Option Page |
|---|---|---|
| **ASUS** | `F2` or `Del` | Extreme Tweaker (OC) / Advanced Mode |
| **Gigabyte** | `F2` or `Del` | Tweaker / Settings |
| **MSI** | `F2` or `Del` | OC / Settings |
| **ASRock** | `F2` or `Del` | OC Tweaker / Advanced |

---

## Critical Settings to Change

### 1. Enable Hardware Virtualization
Required for Windows WSL2, Docker, Sandbox, and emulator setups:
- **Intel:** Enable **Intel Virtualization Technology (VT-x)** and **VT-d**.
- **AMD:** Enable **SVM Mode** (Secure Virtual Machine) and **IOMMU**.

### 2. TPM 2.0 (Required for Windows 11)
- **Intel:** Enable **Intel Platform Trust Technology (PTT)**.
- **AMD:** Enable **AMD CPU fTPM** / **Firmware TPM**.

### 3. Resize BAR / Smart Access Memory (SAM)
Allows the CPU to access the entire GPU VRAM buffer at once, increasing gaming performance:
- Enable **Above 4G Decoding**.
- Enable **Re-Size BAR Support**.

---

## Clearing CMOS (Factory Reset)

If your PC fails to boot (e.g. invalid memory overclock):
```
1. Shut down the computer and unplug the PSU from the wall socket.
2. Locate the two-pin JBAT1 / CLRTC header on the motherboard.
3. Bridge the two pins with a metal screwdriver tip for 10 seconds.
4. (Alternative) Remove the CR2032 round silver battery from the motherboard for 5 minutes.
5. Plug the PC back in and power it on. All BIOS settings will be back to factory defaults.
```

---

## Tips & Tricks

- **Flashing BIOS:** Never flash BIOS during a thunderstorm. Keep the update file on a FAT32-formatted USB drive, navigate to the flash utility in BIOS (EZ Flash, Q-Flash, M-Flash), and select the file. Do NOT touch or power off the PC during the 5-minute flash progress.
- **CSM Mode:** Always disable CSM (Compatibility Support Module) in modern PCs. Disabling it enables UEFI mode, which allows Secure Boot, Resize BAR, and faster boot speeds.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
