# Linux Disk Management Cheatsheet

> Tools and commands for partitioning, formatting, mounting, LVM, RAID, and disk health.
> Last verified: May 2026 | Version: util-linux 2.39, LVM2 2.03

---

## Quick Reference

| Command | Description |
|---|---|
| `lsblk` | List block devices in tree view |
| `df -h` | Show filesystem disk usage |
| `du -sh /path` | Show directory disk usage |
| `fdisk -l` | List partition tables |
| `blkid` | Show device UUIDs and types |
| `mkfs.ext4 /dev/sdb1` | Format partition as ext4 |
| `mount /dev/sdb1 /mnt` | Mount a device |
| `lvextend -L +10G /dev/vg/lv` | Extend a logical volume |
| `smartctl -a /dev/sda` | Show drive health info |
| `rsync -avz src/ dest/` | Sync files with progress |

---

## Listing Devices & Disks

```bash
# List block devices in tree view (most useful overview)
lsblk

# List with filesystem type and UUID
lsblk -f

# List with all columns
lsblk -a

# List with size in bytes
lsblk -b

# List with device type and major/minor numbers
lsblk -d

# Show UUID and filesystem type for all devices
sudo blkid

# Show info for a specific device
sudo blkid /dev/sdb1

# List all disks with their partition tables
sudo fdisk -l

# List partitions of a specific disk
sudo fdisk -l /dev/sda

# Show disk geometry and info
sudo hdparm -I /dev/sda
```

---

## Partitioning

### fdisk (MBR/GPT — interactive)

```bash
# Launch fdisk for a disk
sudo fdisk /dev/sdb

# Common fdisk interactive commands:
# p — Print partition table
# n — New partition
# d — Delete partition
# t — Change partition type
# a — Toggle bootable flag
# w — Write changes and exit
# q — Quit without saving

# Non-interactive: print partition table and exit
sudo fdisk -l /dev/sdb

# Create a new partition table and partition (scripted)
echo -e "g\nn\n\n\n\nw" | sudo fdisk /dev/sdb
# g = new GPT table, n = new partition, defaults, w = write
```

### gdisk (GPT)

```bash
# Launch gdisk for GPT partitioning
sudo gdisk /dev/sdb

# Common gdisk interactive commands:
# p — Print partition table
# n — New partition
# d — Delete partition
# t — Change partition type
# i — Show partition info
# w — Write changes
# q — Quit without saving
# ? — Help

# Partition type codes in gdisk:
# 8300 — Linux filesystem
# 8200 — Linux swap
# ef00 — EFI System Partition
# fd00 — Linux RAID
# 8e00 — Linux LVM
```

### parted (Scripted/Advanced)

```bash
# Launch interactive parted
sudo parted /dev/sdb

# Common parted commands:
# print — Show partition table
# mklabel gpt — Create GPT partition table
# mklabel msdos — Create MBR partition table
# mkpart primary ext4 0% 100% — Create a partition
# rm 1 — Remove partition 1
# resizepart 1 50GB — Resize partition 1 to 50GB
# name 1 "MyData" — Name a GPT partition

# Non-interactive (scripted) parted
sudo parted /dev/sdb --script mklabel gpt
sudo parted /dev/sdb --script mkpart primary ext4 0% 100%
sudo parted /dev/sdb --script print
```

---

## Formatting Filesystems

```bash
# Format as ext4 (most common Linux filesystem)
sudo mkfs.ext4 /dev/sdb1

# Format as ext4 with a label
sudo mkfs.ext4 -L "DataDisk" /dev/sdb1

# Format as XFS (high performance, used by RHEL default)
sudo mkfs.xfs /dev/sdb1

# Format as Btrfs (modern, snapshots, compression)
sudo mkfs.btrfs /dev/sdb1

# Format as FAT32 (compatibility with Windows/USB)
sudo mkfs.vfat -F 32 /dev/sdb1

# Format as NTFS (requires ntfs-3g package)
sudo mkfs.ntfs /dev/sdb1

# Create a swap partition
sudo mkswap /dev/sdb2

# Enable the swap
sudo swapon /dev/sdb2

# Disable swap
sudo swapoff /dev/sdb2

# Show active swap
swapon --show
```

---

## Mounting & Unmounting

```bash
# Mount a device to a directory
sudo mount /dev/sdb1 /mnt/data

# Mount with specific filesystem type
sudo mount -t ext4 /dev/sdb1 /mnt/data

# Mount with options
sudo mount -o ro /dev/sdb1 /mnt/data         # Read-only
sudo mount -o noexec,nosuid /dev/sdb1 /mnt   # Security options
sudo mount -o remount,rw /mnt/data            # Remount read-write

# Mount by UUID (safer than device name)
sudo mount UUID=1234-5678 /mnt/data

# Mount by label
sudo mount LABEL=DataDisk /mnt/data

# List all mounted filesystems
mount
mount | column -t                     # Formatted

# Show disk usage of all mounted filesystems
df -h

# Show inodes usage
df -i

# Unmount a filesystem
sudo umount /mnt/data
sudo umount /dev/sdb1                  # Either works

# Force unmount (use carefully)
sudo umount -f /mnt/data

# Lazy unmount (unmounts when not busy)
sudo umount -l /mnt/data

# Find what's using a mount point (if umount fails)
sudo lsof +D /mnt/data
sudo fuser -vm /mnt/data
```

### /etc/fstab

```bash
# /etc/fstab format:
# <device>  <mountpoint>  <fstype>  <options>  <dump>  <pass>

# Examples:
UUID=abc123-def456  /mnt/data  ext4  defaults  0  2
LABEL=DataDisk      /data      xfs   defaults  0  2
/dev/sdb1           /backup    ext4  ro,noexec  0  0
/dev/sdb2           none       swap  sw         0  0

# Common mount options:
# defaults  — rw, suid, dev, exec, auto, nouser, async
# ro        — Read-only
# rw        — Read-write
# noexec    — Prevent execution of binaries
# nosuid    — Ignore suid/sgid bits
# noatime   — Don't update access time (performance)
# relatime  — Update access time only if newer than mtime
# auto      — Mount at boot with mount -a
# nofail    — Don't fail boot if device is missing
# user      — Allow regular users to mount

# Test fstab without rebooting
sudo mount -a

# Validate fstab syntax
sudo findmnt --verify
```

---

## Disk & Directory Usage

```bash
# Show disk usage in human-readable format
df -h

# Show disk usage for specific filesystem
df -h /home

# Show disk usage with filesystem type
df -hT

# Show directory size
du -sh /var/log

# Show subdirectory sizes, sorted
du -h --max-depth=1 /var | sort -rh

# Find top 10 largest directories
du -h / 2>/dev/null | sort -rh | head -10

# Find top 10 largest files
find / -type f -printf '%s %p\n' 2>/dev/null | sort -rn | head -10

# Find files larger than 1GB
find / -type f -size +1G 2>/dev/null

# Show directory tree with sizes (ncdu is better)
ncdu /           # Install: apt install ncdu

# Check inodes (useful when "disk full" but df shows space)
df -i
```

---

## LVM (Logical Volume Manager)

### Physical Volumes (PV)

```bash
# Initialize a disk/partition for LVM
sudo pvcreate /dev/sdb
sudo pvcreate /dev/sdb1

# Show physical volumes
sudo pvdisplay
sudo pvs                   # Brief output

# Show PV details
sudo pvdisplay /dev/sdb

# Remove a physical volume
sudo pvremove /dev/sdb
```

### Volume Groups (VG)

```bash
# Create a volume group
sudo vgcreate my_vg /dev/sdb

# Create VG spanning multiple disks
sudo vgcreate my_vg /dev/sdb /dev/sdc

# Show volume groups
sudo vgdisplay
sudo vgs

# Add a disk to an existing VG
sudo vgextend my_vg /dev/sdc

# Remove a disk from VG (must be empty)
sudo vgreduce my_vg /dev/sdc

# Rename a volume group
sudo vgrename old_vg new_vg

# Remove a volume group
sudo vgremove my_vg
```

### Logical Volumes (LV)

```bash
# Create a logical volume
sudo lvcreate -L 20G -n my_lv my_vg

# Create using percentage of free space
sudo lvcreate -l 100%FREE -n my_lv my_vg
sudo lvcreate -l 50%VG -n my_lv my_vg

# Show logical volumes
sudo lvdisplay
sudo lvs

# Extend a logical volume (add space)
sudo lvextend -L +10G /dev/my_vg/my_lv
sudo lvextend -l +100%FREE /dev/my_vg/my_lv  # Use all free space

# Extend and resize filesystem in one step (ext4)
sudo lvextend -L +10G -r /dev/my_vg/my_lv    # -r = resize filesystem

# Resize ext4 filesystem after extending
sudo resize2fs /dev/my_vg/my_lv

# Resize XFS filesystem (XFS can only grow, not shrink)
sudo xfs_growfs /mount/point

# Reduce a logical volume (DANGEROUS — backup first!)
# Must shrink filesystem first, then reduce LV
sudo umount /mnt/data
sudo e2fsck -f /dev/my_vg/my_lv
sudo resize2fs /dev/my_vg/my_lv 15G
sudo lvreduce -L 15G /dev/my_vg/my_lv
sudo mount /dev/my_vg/my_lv /mnt/data

# Create a snapshot (point-in-time copy)
sudo lvcreate -L 5G -s -n my_lv_snap /dev/my_vg/my_lv

# Remove a logical volume
sudo lvremove /dev/my_vg/my_lv

# Rename a logical volume
sudo lvrename my_vg old_lv new_lv
```

---

## RAID (mdadm)

```bash
# Create RAID 1 (mirror, 2 disks)
sudo mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb /dev/sdc

# Create RAID 5 (striping + parity, 3+ disks)
sudo mdadm --create /dev/md0 --level=5 --raid-devices=3 /dev/sdb /dev/sdc /dev/sdd

# Create RAID 10 (mirror + stripe, 4 disks)
sudo mdadm --create /dev/md0 --level=10 --raid-devices=4 /dev/sdb /dev/sdc /dev/sdd /dev/sde

# View RAID array status
cat /proc/mdstat
sudo mdadm --detail /dev/md0

# Add a spare disk to RAID
sudo mdadm /dev/md0 --add /dev/sde

# Remove a failed disk from RAID
sudo mdadm /dev/md0 --remove /dev/sdb

# Mark a disk as failed (for testing)
sudo mdadm /dev/md0 --fail /dev/sdb

# Stop and remove a RAID array
sudo mdadm --stop /dev/md0

# Save RAID configuration
sudo mdadm --detail --scan >> /etc/mdadm/mdadm.conf
sudo update-initramfs -u  # Update initramfs to include RAID config
```

---

## Disk Health (smartctl)

```bash
# Show full SMART info for a drive
sudo smartctl -a /dev/sda

# Show summary health status
sudo smartctl -H /dev/sda

# Show SMART attributes (key stats)
sudo smartctl -A /dev/sda

# Run short self-test
sudo smartctl -t short /dev/sda

# Run long self-test (may take hours)
sudo smartctl -t long /dev/sda

# Check test results
sudo smartctl -l selftest /dev/sda

# Enable SMART monitoring on a drive
sudo smartctl -s on /dev/sda

# For NVMe drives
sudo smartctl -a /dev/nvme0n1

# Key SMART attributes to watch:
# 5   — Reallocated_Sector_Ct (bad sectors)
# 187 — Reported_Uncorrect
# 196 — Reallocation_Event_Count
# 197 — Current_Pending_Sector (unstable sectors)
# 198 — Offline_Uncorrectable
# 190/194 — Temperature
```

---

## dd — Disk Cloning & Imaging

```bash
# Clone an entire disk (sda → sdb)
sudo dd if=/dev/sda of=/dev/sdb bs=4M status=progress

# Create a disk image
sudo dd if=/dev/sda of=/backup/disk.img bs=4M status=progress

# Restore a disk image
sudo dd if=/backup/disk.img of=/dev/sdb bs=4M status=progress

# Create compressed disk image
sudo dd if=/dev/sda bs=4M | gzip > /backup/disk.img.gz

# Create an image of a specific partition
sudo dd if=/dev/sda1 of=/backup/partition.img bs=4M status=progress

# Wipe a drive (write zeros)
sudo dd if=/dev/zero of=/dev/sdb bs=4M status=progress

# Wipe a drive (write random data — more secure)
sudo dd if=/dev/urandom of=/dev/sdb bs=4M status=progress

# Test disk write speed
sudo dd if=/dev/zero of=/tmp/testfile bs=1G count=1 oflag=dsync

# Test disk read speed
sudo dd if=/tmp/testfile of=/dev/null bs=1G count=1
```

---

## rsync — Backup & Sync

```bash
# Basic sync (source to destination)
rsync -av /source/ /destination/

# Sync with compression (good for remote)
rsync -avz /source/ user@remote:/destination/

# Sync over SSH with progress bar
rsync -avz --progress /source/ user@remote:/destination/

# Delete files in destination not in source (mirror)
rsync -av --delete /source/ /destination/

# Dry run (preview without making changes)
rsync -av --dry-run /source/ /destination/

# Exclude files/directories
rsync -av --exclude='*.log' --exclude='temp/' /source/ /destination/

# Bandwidth limit (100KB/s)
rsync -avz --bwlimit=100 /source/ user@remote:/destination/

# Resume interrupted transfer
rsync -avz --partial --progress /source/ user@remote:/destination/

# Sync with hard links (backup rotation)
rsync -av --link-dest=/backup/yesterday/ /source/ /backup/today/
```

---

## Tips & Tricks

- Always use UUIDs in `/etc/fstab` instead of device names like `/dev/sdb1` — device names can change after reboot
- `lsblk -f` is the fastest way to see what filesystems and UUIDs are on a system
- Before extending an LV, always check `vgs` to confirm free space in the VG
- For NVMe drives, use `/dev/nvme0n1` (namespace 1) for disk operations, not `/dev/nvme0`
- `ncdu` is far superior to `du` for interactive disk usage exploration — install it first
- After running `lvextend`, you must also run `resize2fs` (ext4) or `xfs_growfs` (xfs) — the LV and FS are separate things
- SMART values: any non-zero value for attributes 5, 187, 196, 197, or 198 warrants immediate attention
- `dd` is unforgiving — double-check `if=` and `of=` order; a reversed swap will destroy your source disk
- Use `rsync` instead of `cp` for large transfers — it's resumable, shows progress, and supports remote
- The `nofail` mount option in fstab prevents the system from hanging at boot if a non-essential drive is missing

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
