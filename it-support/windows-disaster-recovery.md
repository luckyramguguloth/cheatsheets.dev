# Windows Disaster Recovery & BSOD Cheatsheet

> Diagnostic flows, DISM/SFC image repairs, BCD bootloader rebuilds, Windows Recovery Environment (WinRE), and BSOD stop code triage.
> Last verified: May 2026 | Version: Windows 10 / Windows 11 / Windows Server

---

## Quick Reference: Core Recovery Commands

| Tool / Command | Context | Purpose |
|---|---|---|
| `sfc /scannow` | Admin CMD / WinRE | Scan and repair corrupt system files from component store |
| `DISM /Online /Cleanup-Image /RestoreHealth` | Admin CMD | Repair corrupted component store using Windows Update |
| `bootrec /fixmbr` | WinRE Command Prompt | Rewrite Master Boot Record |
| `bootrec /fixboot` | WinRE Command Prompt | Write new boot sector to system partition |
| `bootrec /rebuildbcd` | WinRE Command Prompt | Scan and re-add Windows installations to BCD |
| `chkdsk C: /f /r` | Admin CMD / WinRE | Locate bad sectors and recover readable information |
| `net start wuauserv` | Admin CMD | Restart Windows Update Service |

---

## BSOD Stop Code Diagnostic Matrix

| BSOD Stop Code | Root Cause | Primary Action |
|---|---|---|
| **CRITICAL_PROCESS_DIED** | Vital process (csrss.exe, wininit.exe) terminated | Run `sfc /scannow`; inspect memory dump |
| **SYSTEM_THREAD_EXCEPTION_NOT_HANDLED** | Faulty device driver exception | Boot Safe Mode; rollback recently updated driver |
| **INACCESSIBLE_BOOT_DEVICE** | Missing AHCI/NVMe driver or corrupt BCD | Rebuild BCD; toggle SATA mode (AHCI/RAID) in BIOS |
| **PAGE_FAULT_IN_NONPAGED_AREA** | Faulty RAM, corrupted NTFS, or driver fault | Run `mdsched.exe` (Windows Memory Diagnostic) |
| **KERNEL_SECURITY_CHECK_FAILURE** | Corrupted kernel structures or driver failure | Run Driver Verifier (`verifier.exe`) |
| **WHEA_UNCORRECTABLE_ERROR** | Hardware failure (unstable CPU OC, failing NVMe) | Reset BIOS to defaults; check CPU voltage & thermals |

---

## Emergency BCD & UEFI Bootloader Rebuild (WinRE)

When Windows fails to boot with `0xc000000e` or `0xc0000098`:
```cmd
:: 1. Launch WinRE from USB installer -> Troubleshoot -> Advanced Options -> Command Prompt
diskpart
list disk
select disk 0
list partition

:: Locate EFI System Partition (FAT32, usually ~100MB-500MB)
list volume
select volume 2
assign letter=V:
exit

:: 2. Re-create UEFI boot structures
cd /d V:\EFI\Microsoft\Boot\
bootrec /fixboot

:: If "Access is Denied" occurs on fixboot, regenerate BCD completely:
bcdboot C:\Windows /s V: /f UEFI

:: 3. Rebuild BCD store
bootrec /rebuildbcd
```

---

## DISM Offline Image Repair via Installation Media

When `DISM ... /RestoreHealth` fails because Windows Update is unreachable:
```cmd
:: Mount Windows Install ISO (e.g. assigned letter E:)
DISM /Online /Cleanup-Image /RestoreHealth /Source:WIM:E:\sources\install.wim:1 /LimitAccess
```

---

## Windows Safe Mode via Command Line

```cmd
:: Configure system to boot directly into Safe Mode with Networking on next restart:
bcdedit /set {default} safeboot network

:: To revert back to normal boot:
bcdedit /deletevalue {default} safeboot
```

---

## Tips & Tricks

- **Analyze minidump without WinDbg:** Use NirSoft BlueScreenView or `windbg.exe -z C:\Windows\Minidump\*.dmp` and execute `!analyze -v` to pinpoint the offending `.sys` driver instantly.
- **Fast Startup Gotcha:** Disable "Fast Startup" in Control Panel Power Options on troubleshooting machines — Fast Startup causes corrupted hibernation files (`hiberfil.sys`) that mimic hardware failure.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
