# Data Recovery & Digital Forensics Cheatsheet

> Bit-stream disk imaging, raw partition recovery, photorec carving, TestDisk partition table rebuild, and filesystem rescue.
> Last verified: May 2026 | Version: TestDisk 7.2+ / ddrescue 1.27+

---

## Quick Reference

| Tool | Focus | Command Example |
|---|---|---|
| `ddrescue` | Fault-tolerant drive cloning (ignores bad sectors) | `sudo ddrescue -d -r 3 /dev/sdb disk.img mapfile` |
| `testdisk` | Rebuild corrupted partition tables (GPT/MBR) | `sudo testdisk /dev/sdb` |
| `photorec` | Signature-based file carving from raw blocks | `sudo photorec /dev/sdb` |
| `fls` | SleuthKit inode and deleted file lister | `fls -r -d -p disk.img` |
| `icat` | Extract file by inode number (SleuthKit) | `icat disk.img 14052 > recovered.pdf` |
| `sha256sum` | Verify cryptographic hash of forensic image | `sha256sum disk.img` |

---

## Bit-Stream Disk Cloning with GNU ddrescue

Never attempt recovery directly on a failing, clicking, or dying physical hard drive. Always image it first:

```bash
# Phase 1: Fast copy without retrying bad sectors (copies maximum good data first)
sudo ddrescue -n -b 4096 /dev/sdb /mnt/backup/damaged_drive.img /mnt/backup/recovery.map

# Phase 2: Direct access retry pass on bad sectors (3 retries per bad block)
sudo ddrescue -d -r 3 -b 4096 /dev/sdb /mnt/backup/damaged_drive.img /mnt/backup/recovery.map
```

---

## TestDisk Partition Table Rebuild (Interactive Recovery)

When a partition disappears and shows up as "RAW" or "Unallocated":
```bash
sudo testdisk /mnt/backup/damaged_drive.img

# Workflow inside TestDisk:
# 1. Select Proceed -> Choose Partition Table Type (Intel for MBR, EFI GPT for modern disks).
# 2. Select Analyse -> Quick Search.
# 3. TestDisk scans backup superblock/headers and displays missing partitions.
# 4. Press 'P' to list files inside partition to verify contents.
# 5. Press 'Write' to re-flash the valid partition table back to disk.
```

---

## Mounting Forensic Images Safely as Read-Only

```bash
# 1. Mount raw image via loop device with partition scan
sudo losetup -Pf --show /mnt/backup/damaged_drive.img
# Output: /dev/loop0

# 2. Mount partition in strict read-only mode (prevents journal changes)
sudo mount -o ro,noload /dev/loop0p1 /mnt/forensic_inspect
```

---

## Troubleshooting & Emergency Recovery

### 1. `mount: Structure needs cleaning` (Corrupted ext4 Superblock)
- **Recovery:** Locate backup superblocks and mount using backup:
  ```bash
  # Locate backup superblocks
  sudo mke2fs -n /dev/sdb1
  
  # Run fsck using alternative superblock (e.g. block 32768)
  sudo fsck.ext4 -b 32768 /dev/sdb1
  ```

### 2. Accidental File Deletion on NTFS (Windows)
- **Action:** Stop all writes to partition immediately. Run PhotoRec or TestDisk, select the unallocated space, and carve files by header signatures.

---

## Tips & Tricks

- **Write blockers:** Always use hardware write blockers or mount disk with `blockdev --setro /dev/sdb` before connecting suspect storage to forensic workstations.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
