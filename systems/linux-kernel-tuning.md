# Linux Kernel Tuning Cheatsheet

> Production guide for sysctl optimization, network buffer scaling, memory dirty page ratios, hugepages, and kernel panic recovery.
> Last verified: May 2026 | Version: Linux Kernel 6.x / Enterprise Linux

---

## Quick Reference

| Parameter / Command | Recommended Production Value | Purpose |
|---|---|---|
| `sysctl -p /etc/sysctl.d/99-custom.conf` | — | Reload and apply sysctl settings without reboot |
| `fs.file-max` | `2097152` | Maximum system-wide file descriptors |
| `vm.swappiness` | `10` | Reduce swap usage while keeping OOM prevention |
| `net.core.somaxconn` | `65535` | Maximum socket listen backlog queue |
| `net.ipv4.tcp_max_syn_backlog` | `32768` | SYN queue backlog (mitigates SYN floods) |
| `vm.dirty_ratio` | `15` | Percentage of memory dirty pages before writeback |
| `vm.dirty_background_ratio` | `5` | Background pdflush trigger ratio |
| `sysctl -a \| grep net.ipv4` | — | View all active IPv4 network sysctl parameters |

---

## High-Throughput Network & Socket Tuning

Add to `/etc/sysctl.d/99-networking.conf`:
```ini
# Maximum socket receive/send buffer size across all protocols
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.core.rmem_default = 262144
net.core.wmem_default = 262144

# TCP window size autotuning: min, default, max (bytes)
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 65536 16777216

# Connection state table size
net.netfilter.nf_conntrack_max = 1048576

# Reuse TIME_WAIT sockets for outgoing connections safely
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 15

# Enable BBR congestion control algorithm
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
```

Apply immediately:
```bash
sudo sysctl --system
```

---

## Virtual Memory & Page Cache Tuning

Add to `/etc/sysctl.d/99-memory.conf`:
```ini
# Prevent large latency spikes on heavy disk writes
vm.dirty_background_ratio = 5
vm.dirty_ratio = 10

# Discourage swapping processes unless under extreme memory pressure
vm.swappiness = 10

# Control memory overcommit (2 = Don't overcommit, strict limit)
# vm.overcommit_memory = 2
# vm.overcommit_ratio = 80

# Increase VMA allocation limits for databases (Elasticsearch, MongoDB)
vm.max_map_count = 262144
```

---

## Transparent Huge Pages (THP) Management

Databases (PostgreSQL, Redis, MySQL) suffer latency spikes with THP active:
```bash
# Check current status
cat /sys/kernel/mm/transparent_hugepage/enabled
# Output: [always] madvise never

# Disable at runtime:
echo never | sudo tee /sys/kernel/mm/transparent_hugepage/enabled
echo never | sudo tee /sys/kernel/mm/transparent_hugepage/defrag
```

---

## Troubleshooting & Crash Recovery

### 1. `TCP: request_sock_TCP: Possible SYN flooding on port 80. Dropping request.`
- **Diagnosis:** SYN backlog full due to connection spike or DoS.
- **Immediate Recovery:**
  ```bash
  sudo sysctl -w net.ipv4.tcp_syncookies=1
  sudo sysctl -w net.ipv4.tcp_max_syn_backlog=65535
  sudo sysctl -w net.core.somaxconn=65535
  ```

### 2. Kernel Panic on Out of Memory (OOM)
- **Automatic Reboot on Panic:** Prevent servers from remaining permanently dead in a frozen state:
  ```ini
  # Reboot automatically 10 seconds after kernel panic
  kernel.panic = 10
  kernel.panic_on_oops = 1
  ```
- **Inspect OOM killer logs:**
  ```bash
  dmesg -T | grep -E -i "oom|out of memory|killed process"
  ```

---

## Tips & Tricks

- **Verify BBR is active:** Run `sysctl net.ipv4.tcp_congestion_control` and `lsmod | grep bbr` to confirm Google BBR congestion control is active.
- **Persistent limits:** Always configure `/etc/security/limits.d/99-nofile.conf` alongside `fs.file-max` so userspace processes can actually open high socket counts:
  ```
  * soft nofile 65535
  * hard nofile 65535
  ```

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
