# KVM, QEMU & Proxmox Virtualization Cheatsheet

> Production guide for virsh, QEMU image manipulation, Proxmox VE (PVE) administration, and VM emergency rescue.
> Last verified: May 2026 | Version: QEMU 8.x / Proxmox VE 8.x

---

## Quick Reference

| Task | Command |
|---|---|
| List running VMs (KVM) | `virsh list` |
| List all VMs including stopped | `virsh list --all` |
| Start / Stop VM | `virsh start <VM>` / `virsh shutdown <VM>` |
| Force stop / reset VM | `virsh destroy <VM>` / `virsh reset <VM>` |
| Connect to VM serial console | `virsh console <VM>` |
| Edit VM XML hardware configuration | `virsh edit <VM>` |
| Proxmox cluster status | `pvecm status` |
| Proxmox VM start / stop | `qm start <VMID>` / `qm stop <VMID>` |

---

## QEMU Disk Image (qemu-img) Manipulation

```bash
# Create 100GB QCOW2 sparse disk with compression support
qemu-img create -f qcow2 /var/lib/libvirt/images/ubuntu.qcow2 100G

# Inspect virtual size vs actual physical disk usage
qemu-img info /var/lib/libvirt/images/ubuntu.qcow2

# Resize virtual disk (+50GB)
qemu-img resize /var/lib/libvirt/images/ubuntu.qcow2 +50G

# Convert raw disk or VMware VMDK to QCOW2
qemu-img convert -p -f vmdk -O qcow2 disk.vmdk disk.qcow2

# Create snapshot
qemu-img snapshot -c snapshot_before_upgrade disk.qcow2
```

---

## Emergency VM Rescue: Mounting a Corrupted VM Disk on Host

When a guest VM refuses to boot and fails to enter recovery:
```bash
# 1. Enable network block device kernel module
sudo modprobe nbd max_part=8

# 2. Connect VM image to NBD device
sudo qemu-nbd --connect=/dev/nbd0 /var/lib/libvirt/images/broken_vm.qcow2

# 3. Check partitions exposed on host
lsblk /dev/nbd0

# 4. Mount guest root filesystem to host rescue directory
sudo mkdir -p /mnt/vm_rescue
sudo mount /dev/nbd0p1 /mnt/vm_rescue

# 5. Fix guest files (e.g. /mnt/vm_rescue/etc/fstab or GRUB configs)
# Once fixed, unmount and disconnect:
sudo umount /mnt/vm_rescue
sudo qemu-nbd --disconnect /dev/nbd0
```

---

## Proxmox VE Command Line Tools (`qm` and `pvecm`)

```bash
# Clone VM template
qm clone 9000 105 --name web-production-01 --full

# Monitor guest agent status
qm guest cmd 105 ping

# Recover Proxmox cluster quorum when single node survives in 2-node failure
pvecm expected 1

# Unlock locked VM (stuck during backup or task failure)
qm unlock 105
```

---

## Troubleshooting & Crash Recovery

### 1. `virsh console` Hangs on "Connected to domain"
- **Cause:** Guest operating system does not have a TTY serial console configured.
- **Fix (Inside Guest):**
  ```bash
  sudo systemctl enable --now serial-getty@ttyS0.service
  ```

### 2. Proxmox Task Error: `VM is locked (backup)`
- **Recovery:**
  ```bash
  sudo qm unlock <VMID>
  ```

---

## Tips & Tricks

- **VirtIO drivers:** Always configure network and disk controllers as `virtio` (VirtIO SCSI / VirtIO Net) instead of IDE/e1000 for up to 500% throughput boost.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
