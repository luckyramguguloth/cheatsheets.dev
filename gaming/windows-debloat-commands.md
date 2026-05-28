# Windows Gaming Debloat Cheatsheet

> PowerShell commands, registry tweaks, and service configurations for optimizing Windows for gaming.
> Last verified: May 2026 | Version: Windows 10 & 11

---

## Quick Reference

| Action | PowerShell Command (Run as Admin) |
|---|---|
| Remove all stock bloatware | `Get-AppxPackage -AllUsers | Where-Object {$_.Name -notlike "*store*"} | Remove-AppxPackage` |
| Disable Xbox Game Bar | `Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "AppCaptureEnabled" -Value 0` |
| Enable Game Mode | `Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "AutoGameModeEnabled" -Value 1` |
| Disable Cortana | `Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Value 0` |
| Flush DNS Cache | `ipconfig /flushdns` |

---

## Cleaning Pre-Installed Windows Bloat

Run PowerShell as Administrator to completely remove telemetry and pre-installed advertising packages:
```powershell
# Remove pre-installed Xbox and Game services (if not using Game Pass)
Get-AppxPackage *xboxapp* | Remove-AppxPackage
Get-AppxPackage *xboxspeech* | Remove-AppxPackage

# Remove standard sponsored apps (Spotify, Candy Crush, etc.)
Get-AppxPackage *spotify* | Remove-AppxPackage
Get-AppxPackage *solitairecollection* | Remove-AppxPackage
```

---

## Power Plan Optimization

```powershell
# Unhide and enable the "Ultimate Performance" Power Plan
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
```
*Note: Go to Control Panel > Power Options to select the newly created plan.*

---

## Tips & Tricks

- **Timer Resolution:** Windows default timer resolution is 15.6ms. Tools like ISLC (Intelligent Standby List Cleaner) can lower this to 0.5ms, significantly reducing input lag in esports games.
- **Clean GPU Drivers:** Never upgrade GPU drivers on top of old ones. Use DDU (Display Driver Uninstaller) in Windows Safe Mode to perform a completely clean driver installation.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
