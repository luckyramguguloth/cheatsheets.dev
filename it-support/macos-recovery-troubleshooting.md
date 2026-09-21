# macOS Recovery & Troubleshooting Cheatsheet

> Reference guide for Apple Silicon & Intel recovery mode, APFS volume repair, TCC permissions reset, NVRAM/SMC, and kernel panic diagnosis.
> Last verified: May 2026 | Version: macOS Sonoma 14.x / Sequoia 15.x

---

## Quick Reference: Recovery Access

| Platform | Key Combination on Power Up | Destination |
|---|---|---|
| **Apple Silicon (M1/M2/M3/M4)** | **Press & Hold Power Button** until "Loading startup options" | Startup Options & Recovery |
| **Intel Mac** | `Command (⌘) + R` | Standard Local Recovery Mode |
| **Intel Mac** | `Option (⌥) + Command + R` | Internet Recovery (Latest compatible macOS) |
| **Intel Mac Safe Mode** | Hold `Shift` during power up | Safe Boot (clears font/kernel caches) |
| **Apple Silicon Safe Mode** | Hold Power Button -> Select Volume -> Hold `Shift` | Safe Boot |

---

## Terminal Commands in macOS Recovery

Access via **Utilities** > **Terminal** in the Recovery menu bar:

```bash
# Reset forgotten Administrator password via GUI tool
resetpassword

# Repair APFS container and volumes
diskutil list
diskutil verifyVolume /dev/disk3s1
diskutil repairVolume /dev/disk3s1

# Force unmount stubborn APFS disk
diskutil unmountDisk force /dev/disk3

# Inspect boot policy & security level (Apple Silicon)
bputil -d
```

---

## TCC Privacy & Permissions Reset (`tccutil`)

When camera, microphone, screen recording, or disk access permissions become corrupted:
```bash
# Reset full disk access permissions for all applications
tccutil reset SystemPolicyAllFiles

# Reset camera access
tccutil reset Camera

# Reset screen recording permission
tccutil reset ScreenCapture

# Reset permissions for a specific app bundle ID
tccutil reset All com.google.Chrome
```

---

## Clearing System Caches & Diagnostic Logs

```bash
# Flush DNS Cache on macOS Sonoma/Sequoia
sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder

# Inspect recent kernel panic logs
ls -la /Library/Logs/DiagnosticReports/Kernel*.panic
cat /Library/Logs/DiagnosticReports/Kernel*.panic | grep -E "Kernel Extensions in backtrace|Panicked task"

# Reset network configuration interfaces
sudo rm /Library/Preferences/SystemConfiguration/NetworkInterfaces.plist
sudo rm /Library/Preferences/SystemConfiguration/preferences.plist
# (Reboot machine to regenerate default interfaces)
```

---

## Troubleshooting & Crash Recovery

### 1. Mac Stuck in Bootloop (Prohibitory Sign / Flashing Folder)
- **Diagnosis:** Corrupted bootloader, broken system seal, or failed APFS snapshot.
- **Recovery Protocol:**
  1. Boot into Recovery (`Command + R` or Hold Power).
  2. Run First Aid on all container child volumes from bottom to top in Disk Utility.
  3. Reinstall macOS without erasing data (system files are refreshed while `/Users/` remains untouched).

### 2. DFU Mode Revive / Restore (Apple Silicon)
When an Apple Silicon Mac will not power on or displays an exclamation mark in a circle:
- Connect the Mac to a second Mac using a USB-C charging cable in the designated DFU port.
- Open **Apple Configurator** on the second Mac.
- Select **Actions** > **Advanced** > **Revive Device** (reinstalls recoveryOS and firmware without wiping user data).

---

## Tips & Tricks

- **Target Disk Mode / Share Disk:** On Apple Silicon in Recovery, select **Utilities** > **Share Disk** to mount the Mac's internal drive onto another Mac over Thunderbolt.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
