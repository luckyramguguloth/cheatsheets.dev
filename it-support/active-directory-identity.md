# Active Directory & Identity Troubleshooting Cheatsheet

> Production guide for Domain Controller replication, Kerberos authentication errors, tombstone recovery, LDAP queries, and locked account triage.
> Last verified: May 2026 | Version: Windows Server 2022 / 2025 / Active Directory

---

## Quick Reference: Core AD CLI Tools

| Tool / Command | Context | Purpose |
|---|---|---|
| `dcdiag /v` | Admin CMD | Comprehensive Domain Controller health audit |
| `repadmin /replsummary` | Admin CMD | Active Directory replication status summary across all DCs |
| `repadmin /showrepl * /errorsonly` | Admin CMD | Display only replication failures across the forest |
| `repadmin /syncall /AdeP` | Admin CMD | Force replication synchronization across all partitions |
| `klist purge` | User CMD | Clear cached Kerberos tickets on local client |
| `netdom query fsmo` | Admin CMD | Identify all 5 FSMO role holder Domain Controllers |
| `Get-ADUser -Identity "jdoe" -Properties *` | PowerShell | Detailed attribute inspection of AD user account |

---

## Diagnosing Kerberos & Authentication Failures

Common Kerberos failure codes in Windows Security Event Log (Event ID 4768 / 4771):

| Failure Code | Meaning | Fix Action |
|---|---|---|
| **0x6 (KDC_ERR_C_PRINCIPAL_UNKNOWN)** | Username does not exist in domain | Check spelling or domain suffix |
| **0x12 (KDC_ERR_CLIENT_REVOKED)** | Account disabled, locked, or expired | Unlock account via `Unlock-ADAccount` |
| **0x18 (KDC_ERR_PREAUTH_FAILED)** | Incorrect password entered | Verify user password or bad cached credential |
| **0x25 (KDC_ERR_PREAUTH_REQUIRED)** | Time synchronization skew (> 5 minutes) | Sync workstation time with DC via `w32tm` |

---

## Time Skew Recovery (Kerberos Relies on Time Synchronization)

```cmd
:: On Domain Controller (Configure authoritative NTP time source):
w32tm /config /manualpeerlist:"pool.ntp.org" /syncfromflags:manual /reliable:yes /update
net stop w32time && net start w32time
w32tm /resync /force

:: On Client Workstation (Resync clock with domain controller):
w32tm /config /syncfromflags:domhier /update
net stop w32time && net start w32time
w32tm /resync /nowait
```

---

## Account Lockout Triage (PowerShell)

```powershell
Import-Module ActiveDirectory

# 1. Identify which Domain Controller processed the bad password attempts
Get-ADUser -Identity "jdoe" -Properties AccountLockoutTime, LastBadPasswordAttempt, BadPwdCount, LockedOut

# 2. Unlock user account across domain
Unlock-ADAccount -Identity "jdoe"

# 3. Find source computer causing lockout loop (Event ID 4740 on PDC Emulator):
Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4740} -MaxEvents 5 | Format-List TimeCreated, Message
```

---

## Emergency FSMO Role Seizure

If a Domain Controller holding FSMO roles suffers fatal unrecoverable hardware failure:
```powershell
# Seize all roles to a healthy DC (e.g. DC01):
Move-ADDirectoryServerOperationMasterRole -Identity "DC01" -OperationMasterRole SchemaMaster, DomainNamingMaster, PDCEmulator, RIDMaster, InfrastructureMaster -Force
```
*Warning: Never bring the old failed DC back online once roles have been seized.*

---

## Tips & Tricks

- **DNS is 90% of AD failures:** If replication fails, check SRV records:
  ```cmd
  nslookup -type=srv _ldap._tcp.dc._msdcs.yourdomain.com
  ```
- **Inspect Kerberos Ticket:** Run `klist` on client PCs to check ticket expiration and encryption types (AES256 vs RC4).

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
