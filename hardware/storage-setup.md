# Storage Setup & Management Cheatsheet

> Comparison matrix, formatting guides, partitioning commands, and SSD health metrics.
> Last verified: May 2026 | Version: NVMe & SATA Standard

---

## Storage Types Comparison

| Attribute | NVMe M.2 SSD | SATA 2.5" SSD | Mechanical HDD |
|---|---|---|---|
| **Max Read/Write** | 3500 - 14000 MB/s | 500 - 550 MB/s | 100 - 250 MB/s |
| **Connection Type** | PCIe Slot (direct) | SATA Data + Power Cables | SATA Data + Power Cables |
| **IOPS Performance** | Extremely High (1M+) | Medium (90k) | Extremely Low (< 200) |
| **Primary Use** | OS, high-end games, heavy apps | Secondary storage, older games | Archive, media library, backups |

---

## Windows Drive Partitioning (diskpart CLI)

If a new drive does not show up in Explorer, format it via Command Prompt (Admin):
```cmd
:: Launch diskpart shell
diskpart

:: List all physically connected drives
list disk

:: Select the newly added drive (verify via size, e.g. Disk 1)
select disk 1

:: Initialize disk as GPT (Modern Standard)
clean
convert gpt

:: Create partition and format as NTFS
create partition primary
format fs=ntfs quick label="Storage"
assign letter=D
exit
```

---

## Linux Storage Setup (fdisk & mkfs)

```bash
# List all drives and partitions
lsblk

# Partition drive /dev/sdb using GPT
sudo parted /dev/sdb mklabel gpt

# Create primary partition occupying the whole drive
sudo parted /dev/sdb mkpart primary ext4 0% 100%

# Format partition with EXT4 filesystem
sudo mkfs.ext4 /dev/sdb1

# Mount filesystem temporarily
sudo mount /dev/sdb1 /mnt
```

---

## Tips & Tricks

- **TRIM Support:** Ensure TRIM is enabled to maintain SSD speeds over time. Windows: `fsutil behavior query DisableDeleteNotify` (0 means enabled). Linux: run `fstrim -v /` weekly.
- **Drive Health:** Monitor SSD wear levels using `CrystalDiskInfo` (Windows) or `smartctl` (Linux). Keep at least 15% of your SSD storage empty to allow wear-leveling algorithms to work properly.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
