# Cybersecurity Incident Response Cheatsheet

> Triage playbooks, host isolation, process memory inspection, persistence hunting, lateral movement detection, and chain of custody.
> Last verified: May 2026 | Version: SANS Incident Handler / MITRE ATT&CK Matrix

---

## Quick Reference: 6-Step Incident Response Lifecycle

```
[1. Preparation] ──> [2. Identification] ──> [3. Containment]
                                                    │
                                                    ▼
[6. Lessons Learned] <── [5. Recovery] <── [4. Eradication]
```

---

## Rapid Host Triage & Volatile Data Collection (Linux)

```bash
# 1. Record current timestamp & uptime
date -u; uptime

# 2. Check logged-in users & active TTYs
w
who -u
last -n 20

# 3. Check network sockets connected to external IPs
ss -tupn state established

# 4. Check processes running from memory or unlinked paths
ls -l /proc/*/exe | grep "(deleted)"
ls -la /dev/shm /tmp /var/tmp

# 5. Check sudoers and unauthorized SSH authorized_keys
cat /etc/sudoers /etc/sudoers.d/*
grep -rn "ssh-" /home/*/.ssh/authorized_keys /root/.ssh/authorized_keys
```

---

## Windows Incident Response Triage (PowerShell)

```powershell
# 1. Find suspicious processes running outside System32
Get-Process | Select-Object Id, Name, Path, Company | Where-Object { $_.Path -notlike "*C:\Windows\System32*" -and $_.Path -notlike "*C:\Program Files*" }

# 2. Check active network connections with process owners
Get-NetTCPConnection -State Established | Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, OwningProcess | Sort-Object RemoteAddress

# 3. Inspect scheduled tasks created recently
Get-ScheduledTask | Get-ScheduledTaskInfo | Where-Object { $_.LastRunTime -gt (Get-Date).AddDays(-3) }

# 4. Inspect run keys in Registry for persistence
Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run"
Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
```

---

## Lateral Movement & Attack Vector Hunting

```bash
# Inspect authentication logs for brute force or credential stuffing
# Debian / Ubuntu:
grep -i "failed password" /var/log/auth.log | awk '{print $(NF-3)}' | sort | uniq -c | sort -nr | head -20

# RHEL / CentOS:
grep -i "failed password" /var/log/secure | awk '{print $(NF-3)}' | sort | uniq -c | sort -nr | head -20

# Search for web shell activity in web server access logs
grep -E -i "(eval|base64_decode|passthru|shell_exec|system\()" /var/log/nginx/access.log
```

---

## Tips & Tricks

- **Chain of Custody:** Document who collected every artifact, the exact UTC time, serial numbers of drives, and immediate cryptographic hashes (`sha256sum`).
- **Never install new analysis tools on the infected machine:** Run portable binaries from an external read-only USB drive or pull disk images onto an isolated analysis workstation.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
