# CUDA & NVIDIA GPU Troubleshooting Cheatsheet

> Emergency diagnostic flows, driver crash recovery, Xid error codes, thermal throttling, and NCCL multi-GPU troubleshooting.
> Last verified: May 2026 | Version: CUDA 12.x / Driver 550+

---

## Quick Reference

| Command | Action |
|---|---|
| `nvidia-smi` | Real-time GPU utilization, VRAM usage, temperature, and power |
| `nvidia-smi -l 1` | Loop update every 1 second |
| `nvidia-smi dmon -s u` | Monitor compute, memory, and PCIe link throughput |
| `nvidia-smi --query-gpu=timestamp,name,pci.bus_id,driver_version,temperature.gpu,utilization.gpu,utilization.memory,memory.total,memory.free,memory.used --format=csv` | Output GPU metrics to CSV |
| `nvidia-smi -pm 1` | Enable Persistence Mode (prevents driver unload latency) |
| `nvidia-smi -pl 300` | Set GPU power limit to 300 Watts |
| `dmesg -T \| grep -i NVRM` | Check kernel messages for NVIDIA hardware/driver Xid faults |

---

## NVIDIA Xid Error Code Reference

Xid messages in `dmesg -T | grep -i NVRM` indicate hardware or driver crashes:

| Xid Code | Cause | Recommended Action |
|---|---|---|
| **Xid 13** | Graphics Engine Exception | Driver crash or invalid memory access in shader/CUDA kernel |
| **Xid 31** | GPU memory page fault | User code out-of-bounds pointer or VRAM hardware error |
| **Xid 43** | GPU stopped processing | Compute engine timeout (TDR). Reboot GPU or reset |
| **Xid 45** | Preemptive purge / Bus error | PCIe slot power instability or loose hardware seating |
| **Xid 79** | GPU fell off the bus | Fatal thermal cutoff, power surge, or hardware failure |

---

## Emergency Recovery Workflows

### 1. GPU Soft Reset (Without Rebooting Server)
When a CUDA process hangs and locks the GPU in an unkillable zombie state:
```bash
# 1. Identify and kill all processes locking GPU 0
sudo fuser -v /dev/nvidia0
sudo kill -9 $(sudo fuser -v /dev/nvidia0 2>/dev/null | awk '{print $NF}')

# 2. Reset GPU 0 back to default state
sudo nvidia-smi --gpu-reset -i 0

# 3. Verify reset succeeded
nvidia-smi
```

### 2. GPU Fell Off the Bus Recovery
If `nvidia-smi` reports `Unable to determine the device handle for GPU`:
```bash
# 1. Check PCIe bus address of card
lspci | grep -i nvidia
# Output example: 01:00.0 3D controller: NVIDIA Corporation...

# 2. Remove and re-scan the PCIe bus
echo 1 | sudo tee /sys/bus/pci/devices/0000\:01\:00.0/remove
sleep 2
echo 1 | sudo tee /sys/bus/pci/rescan

# 3. Reload kernel drivers
sudo modprobe -r nvidia_uvm nvidia_drm nvidia_modeset nvidia
sudo modprobe nvidia
sudo modprobe nvidia_uvm
nvidia-smi
```

### 3. Thermal Throttling Diagnosis
```bash
# Check if thermal slowdown is active
nvidia-smi -q -d PERFORMANCE | grep -i "slowdown"

# Check clock throttle reasons
nvidia-smi -q -d CLOCK | grep -i "reasons"
```

---

## Tips & Tricks

- **Always enable persistence mode:** Run `sudo systemctl enable nvidia-persistenced` on servers so GPU initialization does not block application startup.
- **Compute mode:** Set GPU compute mode to exclusive if only one process should ever access it: `sudo nvidia-smi -c EXCLUSIVE_PROCESS`.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
