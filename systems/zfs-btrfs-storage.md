# ZFS & Btrfs Advanced Storage Cheatsheet

> Production guide for ZFS storage pools, datasets, Btrfs subvolumes, snapshots, scrub operations, and degraded disk array recovery.
> Last verified: May 2026 | Version: OpenZFS 2.2+ / Btrfs 6.8+

---

## Quick Reference

| Action | ZFS Command | Btrfs Command |
|---|---|---|
| List pools / filesystems | `zpool list` / `zfs list` | `btrfs filesystem show` |
| Detailed status / health | `zpool status -v` | `btrfs device stats /mnt` |
| Run data scrub | `zpool scrub tank` | `btrfs scrub start /mnt` |
| Check scrub progress | `zpool status tank` | `btrfs scrub status /mnt` |
| Create snapshot | `zfs snapshot tank/data@backup_1` | `btrfs subvolume snapshot /mnt /mnt/snap_1` |
| Send snapshot stream | `zfs send tank/data@snap \| ssh srv zfs recv backup/data` | `btrfs send /mnt/snap \| ssh srv btrfs receive /backup` |

---

## ZFS Production Pool Creation & Dataset Configuration

```bash
# Create RAIDZ2 pool (equivalent to RAID 6, tolerates 2 drive failures)
sudo zpool create -f -o ashift=12 -O compression=zstd -O atime=off -O xattr=sa tank raidz2 \
  /dev/disk/by-id/nvme-drive1 \
  /dev/disk/by-id/nvme-drive2 \
  /dev/disk/by-id/nvme-drive3 \
  /dev/disk/by-id/nvme-drive4 \
  /dev/disk/by-id/nvme-drive5 \
  /dev/disk/by-id/nvme-drive6

# Add SLOG (ZFS Intent Log write cache on fast optane/NVMe)
sudo zpool add tank log /dev/disk/by-id/nvme-slog-part1

# Add L2ARC (Read cache)
sudo zpool add tank cache /dev/disk/by-id/nvme-l2arc

# Create dataset with quota and recordsize tuned for databases
sudo zfs create -o recordsize=16k -o quota=500G tank/postgres_data
```

---

## Emergency Degraded Pool Recovery (Replacing a Dead Disk in ZFS)

```bash
# 1. Identify failing or FAULTED disk in pool
zpool status -v tank

# 2. Offline the failed drive
sudo zpool offline tank /dev/disk/by-id/nvme-old-dead-drive

# 3. Physically swap drive and get new disk ID
ls -l /dev/disk/by-id/

# 4. Replace old disk with new disk in pool
sudo zpool replace tank /dev/disk/by-id/nvme-old-dead-drive /dev/disk/by-id/nvme-new-drive

# 5. Monitor resilvering progress until state returns to ONLINE
watch -n 2 zpool status tank
```

---

## Btrfs Subvolumes, Snapshots & Balance

```bash
# Create subvolume
sudo btrfs subvolume create /mnt/data/@userdata

# Balance metadata to reclaim unallocated chunk space
sudo btrfs balance start -dusage=50 -musage=50 /mnt/data

# Recover from read-only mount due to space exhaustion
sudo btrfs balance start -m /mnt/data
```

---

## Troubleshooting & Recovery

### 1. ZFS Pool Stuck in `SUSPENDED` or `UNAVAIL` State
- **Cause:** Disks disconnected simultaneously or underlying HBA bus crash.
- **Recovery:**
  ```bash
  # Clear transient I/O errors and trigger auto-reconnection
  sudo zpool clear tank
  
  # If import fails:
  sudo zpool import -f -F -o readonly=on tank
  ```

### 2. Btrfs Corruption After Dirty Shutdown
- **Recovery:**
  ```bash
  # Mount using emergency backup roots
  sudo mount -o recovery,ro /dev/sdb1 /mnt/rescue
  
  # As absolute last resort, repair filesystem tree:
  sudo btrfs check --repair /dev/sdb1
  ```

---

## Tips & Tricks

- **Always use `ashift=12`:** Never create a ZFS pool with default `ashift=9` (512-byte blocks). 4K sector drives with `ashift=9` suffer disastrous 80%+ write performance drops.
- **Automated scrubs:** Set up weekly automated zpool scrubs via systemd timers: `systemctl enable --now zfs-scrub-weekly@tank.timer`.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
