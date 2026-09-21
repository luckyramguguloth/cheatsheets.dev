# Linux Security Hardening & Compliance Cheatsheet

> Reference guide for SELinux, AppArmor, auditd rule tuning, SSH hardening, CIS benchmarks, and intrusion compromise triage.
> Last verified: May 2026 | Version: OpenSSL 3.x / Linux 6.x

---

## Quick Reference

| Action | Command / Parameter | Purpose |
|---|---|---|
| Check SELinux Status | `sestatus` | Verify enforcing, permissive, or disabled |
| Check AppArmor Status | `sudo aa-status` | List loaded profiles and enforcement mode |
| Tail Audit Logs | `sudo ausearch -m avc -ts recent` | Inspect SELinux security violations |
| Generate SELinux Policy | `ausearch -c 'nginx' --raw \| audit2allow -M my_nginx` | Create custom policy module from log denial |
| Check Listening Ports & PIDs | `sudo ss -tulpn` | Audit listening services and bind addresses |
| Audit SUID Root Binaries | `find / -perm -4000 -type f -exec ls -ld {} + 2>/dev/null` | Find privilege escalation attack surface |

---

## SSH Server Hardening Configuration

`/etc/ssh/sshd_config.d/99-hardened.conf`:
```ini
# Disable root password login
PermitRootLogin prohibit-password

# Enforce public key authentication only
PasswordAuthentication no
KbdInteractiveAuthentication no

# Restrict authentication attempts
MaxAuthTries 3
LoginGraceTime 30

# Modern cryptographic algorithms only (Drop SHA-1 / diffie-hellman)
KexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group16-sha512
Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com
MACs hmac-sha2-512-etm@openssh.com

# Disable X11 and agent forwarding unless required
X11Forwarding no
AllowAgentForwarding no
```

Test and reload without losing current session:
```bash
sudo sshd -t && sudo systemctl reload sshd
```

---

## SELinux Troubleshooting & Policy Generation

```bash
# Put SELinux into Permissive mode temporarily for diagnostics
sudo setenforce 0

# Restore correct file security contexts across directory
sudo restorecon -Rv /var/www/html/

# Allow service to connect to network sockets (common Nginx/PHP issue)
sudo setsebool -P httpd_can_network_connect 1

# Generate and install custom allow module from denials
sudo ausearch -m avc -ts recent | audit2allow -M my_custom_service
sudo semodule -i my_custom_service.pp

# Switch back to Enforcing mode
sudo setenforce 1
```

---

## Linux Audit Subsystem (`auditd`) Rules

Add to `/etc/audit/rules.d/audit.rules`:
```ini
# Monitor changes to user accounts and groups
-w /etc/passwd -p wa -k identity
-w /etc/shadow -p wa -k identity
-w /etc/group -p wa -k identity

# Monitor changes to sudoers configuration
-w /etc/sudoers -p wa -k sudoers_changes
-w /etc/sudoers.d/ -p wa -k sudoers_changes

# Monitor execution of privilege escalation syscalls (setuid/setgid)
-a always,exit -F arch=b64 -S setuid -S setgid -k priv_escalation
```

Load audit rules:
```bash
sudo augenrules --load
```

---

## Emergency Post-Compromise Triage Workflow

If unauthorized access or malware execution is suspected:
```bash
# 1. Isolate machine immediately from LAN/WAN (keep machine powered on for memory analysis)
sudo iptables -P INPUT DROP
sudo iptables -P OUTPUT DROP
sudo iptables -P FORWARD DROP

# 2. Check active established socket connections
sudo ss -tanp state established

# 3. Dump deleted binaries still running in RAM
ls -l /proc/*/exe | grep "(deleted)"

# 4. Check crontab and systemd persistence mechanisms
sudo crontab -l
sudo ls -la /etc/cron* /var/spool/cron/crontabs
sudo systemctl list-unit-files --state=enabled
```

---

## Tips & Tricks

- **Never set `SELINUX=disabled`:** Disabling SELinux in `/etc/selinux/config` breaks filesystem labels upon re-enabling, requiring a slow `autorelabel` boot. Use `SELINUX=permissive` instead.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
