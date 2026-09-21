# eBPF & Linux Performance Profiling Cheatsheet

> Reference guide for bpftrace, BCC tools, perf subsystem, flamegraphs, and diagnosing kernel and CPU bottlenecks.
> Last verified: May 2026 | Version: Linux 6.x / BCC 0.30+ / bpftrace 0.20+

---

## Quick Reference

| Tool | Focus Area | Command Example |
|---|---|---|
| `perf top` | Real-time CPU function profiling | `perf top -F 99` |
| `perf record` | Record performance trace to `perf.data` | `perf record -F 99 -g -p <PID> -- sleep 30` |
| `perf report` | Interactive analysis of recorded profile | `perf report --stdio` |
| `execsnoop` | Trace newly spawned processes (BCC) | `sudo execsnoop-bpfcc` |
| `opensnoop` | Trace all file open syscalls (BCC) | `sudo opensnoop-bpfcc -T` |
| `biolatency` | Block I/O device latency histogram | `sudo biolatency-bpfcc -m` |
| `bpftrace` | Ad-hoc one-liner kernel instrumentation | `sudo bpftrace -e 'kprobe:sys_clone { @[comm] = count(); }'` |

---

## Generating On-CPU Flamegraphs

```bash
# 1. Record call stacks on all CPUs at 99Hz for 30 seconds
sudo perf record -F 99 -a -g -- sleep 30

# 2. Process stack samples
sudo perf script > out.perf

# 3. Collapse stacks (using FlameGraph scripts)
# git clone https://github.com/brendangregg/FlameGraph /opt/FlameGraph
/opt/FlameGraph/stackcollapse-perf.pl out.perf > out.folded

# 4. Generate interactive SVG flamegraph
/opt/FlameGraph/flamegraph.pl out.folded > flamegraph.svg
```

---

## Powerful bpftrace One-Liners

```bash
# Count system calls by process name
sudo bpftrace -e 'tracepoint:raw_syscalls:sys_enter { @[comm] = count(); }'

# Measure read latency histogram by process
sudo bpftrace -e 'kprobe:vfs_read { @start[tid] = nsecs; } kretprobe:vfs_read /@start[tid]/ { @ns[comm] = hist(nsecs - @start[tid]); delete(@start[tid]); }'

# Trace process kills (signals) with sender and receiver PIDs
sudo bpftrace -e 'tracepoint:syscalls:sys_enter_kill { printf("PID %d (%s) sent sig %d to PID %d\n", pid, comm, args->sig, args->pid); }'

# Measure socket accept queue latency
sudo bpftrace -e 'kprobe:tcp_v4_syn_recv_sock { @syn_time[arg0] = nsecs; }'
```

---

## BCC Performance Analysis Tools

```bash
# Profile off-CPU time (threads blocked on locks, I/O, sleep)
sudo offcputime-bpfcc -p $(pgrep mysqld) 10

# Detect disk I/O slow requests (> 10ms)
sudo biosnoop-bpfcc

# Track memory leaks per process
sudo memleak-bpfcc -p $(pgrep node) --combined-only
```

---

## Troubleshooting Performance Regressions

### 1. High System CPU (`%sys`) with Low User CPU (`%user`)
- **Diagnosis:** Excessive kernel context switching, page faults, lock contention, or network interrupt storms.
- **Investigation:**
  ```bash
  # Check top kernel functions consuming CPU
  sudo perf top -s comm,dso,sym
  
  # Check voluntary and involuntary context switches
  pidstat -w 1 5
  ```

### 2. High Disk I/O Wait (`%iowait`)
- **Investigation:**
  ```bash
  # Identify PID causing heavy I/O
  sudo iotop -o -b -n 3
  
  # Check I/O latency distribution per block device
  sudo biolatency-bpfcc 1 10
  ```

---

## Tips & Tricks

- **Sample at odd frequencies:** Use `-F 99` instead of `-F 100` in `perf record` to avoid sampling in lockstep with periodic timer interrupts.
- **eBPF verifier limits:** If bpftrace errors with `Verifier error: program too large`, break complex multi-probe scripts into dedicated BCC Python scripts.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
