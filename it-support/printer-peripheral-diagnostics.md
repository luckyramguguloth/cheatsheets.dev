# Printer & Hardware Peripheral Diagnostics Cheatsheet

> Diagnostic flows for CUPS printing subsystem, Windows print spooler crash recovery, USB device handshakes, and network printer discovery.
> Last verified: May 2026 | Version: CUPS 2.4+ / Windows Spooler

---

## Quick Reference

| Task | Linux (CUPS) | Windows |
|---|---|---|
| Restart Print Service | `sudo systemctl restart cups` | `net stop spooler && net start spooler` |
| View Print Queue | `lpstat -o` | `Get-PrintJob -PrinterName "Office"` |
| Clear All Print Jobs | `cancel -a` | `del /Q /F C:\Windows\System32\spool\PRINTERS\*` |
| List Configured Printers | `lpstat -p -d` | `Get-Printer \| Format-Table Name, DriverName, PortName` |
| Enable / Start Printer | `cupsenable <printer>` | `Resume-PrintJob` |
| Inspect USB Devices | `lsusb -v` | `Get-PnpDevice -Class USB` |

---

## Windows Print Spooler Stuck Job & Crash Recovery

When a corrupted print job freezes the entire Windows print queue and causes `spoolsv.exe` to crash repeatedly:
```cmd
:: Run Admin Command Prompt:
net stop spooler

:: Delete all stuck temporary print buffer files (.SHD and .SPL)
del /Q /F /S "%systemroot%\System32\Spool\Printers\*.*"

:: Restart the Spooler Service
net start spooler
```

---

## Linux CUPS Print Server Troubleshooting

```bash
# Check CUPS daemon status and listening port 631
sudo systemctl status cups
sudo ss -tulpn | grep 631

# Enable detailed CUPS debug logging
sudo cupsctl --debug-logging

# Inspect CUPS error log for PostScript / PPD filtering errors
tail -f /var/log/cups/error_log

# Reset printer accepting state
cupsaccept office_laser_printer
cupsenable office_laser_printer
```

---

## USB Device & Peripheral Handshake Diagnostics

When a USB scanner, keyboard, or printer fails to register:
```bash
# Check real-time kernel USB hotplug events
sudo udevadm monitor --environment --kernel

# Check kernel messages for USB descriptor read errors (Code -110 / -71)
dmesg -T | grep -i usb | tail -n 30

# Reset USB root hub device without rebooting
echo "usb1" | sudo tee /sys/bus/usb/drivers/usb/unbind
sleep 1
echo "usb1" | sudo tee /sys/bus/usb/drivers/usb/bind
```

---

## Tips & Tricks

- **Port 9100 RAW Printing:** Test if a network printer is actually reachable on its hardware engine using raw socket telnet:
  ```bash
  nc -zv 192.168.1.200 9100
  ```
  If port 9100 connects, the network and hardware interface are functional; issues lie in the driver or PPD file.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
