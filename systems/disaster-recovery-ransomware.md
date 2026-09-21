# Disaster Recovery & Ransomware Response Cheatsheet

> Incident response protocol, host network containment, immutable backups, forensic memory preservation, and bare-metal recovery runbooks.
> Last verified: May 2026 | Version: NIST SP 800-61 Rev 2 Standard

---

## Quick Reference: 5-Phase Response Sequence

```
[Phase 1: Containment] ──> [Phase 2: Evidence Preservation] ──> [Phase 3: Root Cause Triage]
           │                                                               │
           ▼                                                               ▼
   Sever Network / Keep RAM Alive                               Identify Initial Access Vector
                                                                           │
                                                                           ▼
                                                             [Phase 4: Clean Rebuild]
                                                                           │
                                                                           ▼
                                                             [Phase 5: Immutable Restore]
```

---

## Phase 1: Emergency Network Isolation

Do **NOT** reboot or power off the machine (powering off destroys RAM-resident decryption keys, volatile malware memory structures, and injects disk metadata timestamps).

```bash
# 1. Sever network connectivity instantly on Linux host
sudo ip link set dev eth0 down
sudo ip link set dev eth1 down

# 2. Or apply strict blackhole iptables firewall:
sudo iptables -F
sudo iptables -P INPUT DROP
sudo iptables -P OUTPUT DROP
sudo iptables -P FORWARD DROP
```

---

## Phase 2: Live Memory Preservation (Forensics)

```bash
# Capture physical RAM image using LiME (Linux Memory Extractor)
sudo insmod lime-$(uname -r).ko "path=/mnt/usb_forensic/memory_dump.lime format=lime"

# Preserve process listings, active sockets, and environmental variables
sudo ps auxf > /mnt/usb_forensic/ps_tree.txt
sudo ss -tulpn > /mnt/usb_forensic/sockets.txt
sudo lsof -Pn -i > /mnt/usb_forensic/network_files.txt
```

---

## Phase 3: Immutable Backup Verification & Restoration

Ransomware routinely seeks out online backup shares. Restoration MUST originate from air-gapped or immutable snapshots:

### ZFS Read-Only Snapshot Rollback
```bash
# List local snapshots before encryption occurred
zfs list -t snapshot tank/production

# Roll back dataset instantly to pre-incident snapshot
sudo zfs rollback -r tank/production@snapshot_2026_09_20_020000
```

### AWS S3 Object Lock (WORM - Write Once Read Many)
```bash
# Verify S3 backup objects were protected by Object Lock retention
aws s3api get-object-retention \
  --bucket production-backups-immutable \
  --key database-backup-2026-09-20.tar.gz
```

---

## Phase 4: Active Directory & Credential Invalidation

When domain controllers or admin accounts are suspected of compromise:
```powershell
# Reset Krbtgt account password TWICE to invalidate all active Kerberos tickets
# (Must wait between resets for AD replication across all domain controllers)
Set-ADUser -Identity "krbtgt" -ChangePasswordAtLogon $false
# Perform second reset after replication:
Reset-KdsRootKey
```

---

## Post-Incident Hardening Checklist

- [ ] Rebuild all operating systems from verified golden images (never trust an encrypted host).
- [ ] Rotate all root, administrator, service account, and API keys.
- [ ] Enforce Phishing-Resistant MFA (FIDO2 / WebAuthn) across all admin access points.
- [ ] Verify perimeter egress filtering prevents direct C2 communication.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
