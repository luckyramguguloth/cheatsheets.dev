# Linux Process Management Cheatsheet

> Tools and commands for monitoring, controlling, and debugging Linux processes.
> Last verified: May 2026 | Version: procps-ng 4.x

---

## Quick Reference

| Command | Description |
|---|---|
| `ps aux` | Show all processes |
| `top` | Interactive process monitor |
| `htop` | Enhanced interactive monitor |
| `kill -9 PID` | Force-kill a process |
| `kill -15 PID` | Gracefully terminate a process |
| `nice -n 10 cmd` | Run command with lower priority |
| `renice -n 5 PID` | Change running process priority |
| `nohup cmd &` | Run command immune to hangups |
| `strace -p PID` | Trace system calls of a process |
| `lsof -p PID` | List files open by a process |

---

## ps — Process Status

### Basic ps Usage

```bash
# Show all processes (BSD syntax — most common)
ps aux

# Show all processes (UNIX syntax)
ps -ef

# Show processes with full command line
ps auxww
ps -efww

# Show process tree
ps auxf
ps -ef --forest

# Show a specific process by PID
ps -p 1234
ps -p 1234 -o pid,ppid,user,cmd

# Show processes for a specific user
ps -u username
ps aux | grep username

# Show processes by name
ps -C nginx
pgrep -a nginx

# Show processes with specific columns
ps -eo pid,ppid,user,pcpu,pmem,comm,args

# Custom columns sorted by CPU usage
ps -eo pid,user,pcpu,pmem,comm --sort=-pcpu | head -20

# Custom columns sorted by memory usage
ps -eo pid,user,pcpu,pmem,comm --sort=-pmem | head -20

# Show thread count per process
ps -eo pid,comm,thcount --sort=-thcount | head -20
```

### Useful ps Columns

```bash
# Common output format specifiers for -o:
# pid     — Process ID
# ppid    — Parent Process ID
# pgid    — Process group ID
# sid     — Session ID
# user    — Username
# uid     — User ID
# pcpu    — CPU percentage
# pmem    — Memory percentage
# vsz     — Virtual memory size (KB)
# rss     — Resident Set Size (physical memory, KB)
# stat    — Process state (R=running, S=sleeping, Z=zombie, D=disk wait)
# start   — Start time
# time    — CPU time used
# comm    — Command name (no args)
# args    — Full command with arguments
# ni      — Nice value
# pri     — Priority
# lwp     — Thread ID

# Show zombie processes
ps aux | awk '$8 == "Z"'

# Show processes in disk wait (uninterruptible sleep)
ps aux | awk '$8 ~ /D/'
```

---

## top — Interactive Monitor

```bash
# Launch top
top

# Top with specific PID
top -p 1234

# Top showing a specific user's processes
top -u username

# Top updating every 0.5 seconds
top -d 0.5

# Top in batch mode (output for scripts)
top -b -n 1               # One iteration
top -b -n 1 | head -20   # First 20 lines

# Sort by memory instead of CPU
top -o %MEM

# Top interactive commands (while running):
# k    — Kill a process (prompts for PID and signal)
# r    — Renice a process
# P    — Sort by CPU usage (default)
# M    — Sort by memory usage
# N    — Sort by PID
# T    — Sort by time
# 1    — Show individual CPU cores
# m    — Toggle memory info display
# c    — Toggle full command line
# f    — Add/remove fields
# q    — Quit
# h    — Help
# u    — Filter by username
# i    — Toggle idle processes
```

---

## htop — Enhanced Monitor

```bash
# Install htop
sudo apt install htop       # Debian/Ubuntu
sudo dnf install htop       # Fedora/RHEL

# Launch htop
htop

# Launch for specific user
htop -u username

# Launch with specific PID highlighted
htop -p 1234

# htop interactive commands:
# F1/h  — Help
# F2    — Setup/configure
# F3    — Search processes
# F4    — Filter processes
# F5    — Tree view toggle
# F6    — Sort by column
# F7    — Lower nice value (increase priority)
# F8    — Higher nice value (decrease priority)
# F9    — Kill process (choose signal)
# F10/q — Quit
# Space — Tag process
# k     — Kill tagged processes
# u     — Filter by user
# t     — Tree view toggle
# H     — Hide/show user threads
# I     — Invert sort
```

---

## btop — Modern Monitor

```bash
# Install btop
sudo apt install btop

# Launch btop
btop

# btop is a modern replacement for top/htop with:
# - Better visual layout with graphs
# - Real-time CPU, memory, disk, network stats
# - Mouse support
# - Process filtering and management
```

---

## Signals

### Common Signals

```bash
# Signal numbers and names
# 1  SIGHUP   — Reload configuration / hangup
# 2  SIGINT   — Interrupt (Ctrl+C)
# 3  SIGQUIT  — Quit with core dump
# 9  SIGKILL  — Force kill (cannot be caught or ignored)
# 15 SIGTERM  — Graceful termination (default kill signal)
# 18 SIGCONT  — Continue a stopped process
# 19 SIGSTOP  — Stop a process (cannot be caught)
# 20 SIGTSTP  — Stop from terminal (Ctrl+Z, can be caught)

# List all signals
kill -l

# Kill by PID (sends SIGTERM by default)
kill 1234

# Force kill (SIGKILL — immediate, no cleanup)
kill -9 1234
kill -SIGKILL 1234

# Graceful termination
kill -15 1234
kill -SIGTERM 1234

# Reload configuration (HUP)
kill -1 1234
kill -HUP 1234

# Stop (pause) a process
kill -STOP 1234

# Continue a stopped process
kill -CONT 1234

# Kill by process name
killall nginx             # Kill all processes named nginx
pkill nginx               # Same, but uses pattern matching
pkill -9 nginx
pkill -u username         # Kill all processes by user

# Send signal to all processes matching pattern
pkill -HUP -f "myapp.*config"   # Reload all myapp instances
```

### pgrep — Find PIDs by Name

```bash
# Find PID by name
pgrep nginx

# Find PIDs and show names
pgrep -a nginx

# Find PID and show full command
pgrep -af "python.*myapp"

# Find PIDs for a specific user
pgrep -u username

# Count matching processes
pgrep -c nginx
```

---

## nice & renice — Process Priority

```bash
# Nice values range from -20 (highest priority) to 19 (lowest priority)
# Default nice value is 0
# Negative nice values require root

# Run a command with lower priority (nice 10)
nice -n 10 rsync -av /source/ /destination/

# Run with even lower priority (nice 19 = least priority)
nice -n 19 make -j8

# Run with higher priority (requires root)
sudo nice -n -10 time-critical-script.sh

# Change the nice value of a running process
renice -n 5 -p 1234           # Set nice to 5 for PID 1234
renice -n 10 -u username      # Set nice to 10 for all user processes
sudo renice -n -5 -p 1234     # Increase priority (root required for negative)

# Set CPU scheduler priority (real-time)
sudo chrt -r -p 50 1234       # Set FIFO real-time priority 50
sudo chrt -o -p 0 1234        # Reset to normal scheduler

# ionice — I/O priority
ionice -c2 -n7 rsync -av /source/ /dest/   # Best effort, lowest I/O priority
ionice -c3 updatedb                         # Idle class (only when disk free)
```

---

## nohup & Background Jobs

```bash
# Run a command immune to hangup (SIGHUP)
nohup ./myapp &

# nohup with output to file
nohup ./myapp > /var/log/myapp.log 2>&1 &

# Run in background
./myapp &

# List background jobs
jobs

# Bring background job to foreground
fg %1           # Job number 1
fg %nginx       # By name

# Send running job to background (first Ctrl+Z, then bg)
# Ctrl+Z         — Suspend to background
bg %1           # Resume in background

# Check background job status
jobs -l         # Show PIDs too

# Disown a job (won't be killed when shell exits)
nohup ./app & disown
./app & disown %1
```

---

## screen & tmux Basics

### screen

```bash
# Start a new screen session
screen

# Start a named screen session
screen -S mysession

# List screen sessions
screen -ls

# Detach from current session (keep running)
# Ctrl+A, then D

# Reattach to a session
screen -r mysession
screen -r 12345.mysession

# Kill a session
screen -X -S mysession quit

# Create a new window in screen
# Ctrl+A, C

# Switch to next window
# Ctrl+A, N

# Switch to previous window
# Ctrl+A, P

# Split horizontally
# Ctrl+A, S

# Split vertically
# Ctrl+A, |
```

### tmux

```bash
# Start a new tmux session
tmux

# Start a named tmux session
tmux new -s mysession

# List sessions
tmux ls

# Detach from session
# Ctrl+B, then D

# Reattach to a session
tmux attach -t mysession

# Kill a session
tmux kill-session -t mysession

# New window
# Ctrl+B, C

# Next/previous window
# Ctrl+B, N / Ctrl+B, P

# Split pane horizontally
# Ctrl+B, "

# Split pane vertically
# Ctrl+B, %

# Switch panes
# Ctrl+B, Arrow keys

# Resize pane
# Ctrl+B, then hold Ctrl + Arrow keys

# List all keybindings
# Ctrl+B, ?
```

---

## /proc Filesystem

```bash
# /proc is a virtual filesystem exposing kernel and process info

# Show process info for PID 1234
ls /proc/1234/

# Process status
cat /proc/1234/status

# Process command line (null-separated, \0 between args)
cat /proc/1234/cmdline | tr '\0' ' '

# Open file descriptors for process
ls -la /proc/1234/fd

# Memory map of process
cat /proc/1234/maps

# CPU and memory stats for process
cat /proc/1234/stat
cat /proc/1234/statm      # Memory in pages

# Environment variables of process
cat /proc/1234/environ | tr '\0' '\n'

# Current working directory
ls -la /proc/1234/cwd

# Executable path
ls -la /proc/1234/exe

# System-wide info
cat /proc/cpuinfo          # CPU info
cat /proc/meminfo          # Memory info
cat /proc/version          # Kernel version
cat /proc/uptime           # System uptime
cat /proc/loadavg          # Load average
cat /proc/net/tcp          # TCP connections
cat /proc/sys/vm/swappiness  # Swappiness setting
```

---

## strace — System Call Tracer

```bash
# Trace system calls of a running process
sudo strace -p 1234

# Trace with timestamps
sudo strace -t -p 1234

# Trace with relative timestamps (time between calls)
sudo strace -r -p 1234

# Count and summarize system calls (useful for profiling)
sudo strace -c -p 1234

# Trace specific system calls only
sudo strace -e trace=open,read,write -p 1234
sudo strace -e trace=network -p 1234    # Network calls only
sudo strace -e trace=file -p 1234       # File-related calls

# Launch and trace a new process
strace ls /tmp

# Trace with output to file
strace -o strace.log -p 1234

# Follow child processes (fork/exec)
strace -f -p 1234

# Show string content (not just pointers)
strace -s 500 -p 1234     # Show up to 500 chars of strings

# Practical: why is a process stuck?
sudo strace -p 1234 2>&1 | grep -v EAGAIN | head -20
```

---

## lsof — List Open Files

```bash
# List all open files
sudo lsof

# List open files for a specific process
sudo lsof -p 1234

# List open files for a specific user
sudo lsof -u username

# List open network connections
sudo lsof -i

# List open TCP connections
sudo lsof -i TCP

# List processes using a specific port
sudo lsof -i :80
sudo lsof -i :8080

# List processes using a specific file
sudo lsof /var/log/nginx/error.log

# List processes using a specific directory
sudo lsof +D /var/log/

# Find what process is using a port
sudo lsof -i :3000 -t   # Show only PIDs
sudo kill $(sudo lsof -i :3000 -t)  # Kill process on port 3000

# Show network connections with port numbers (numeric)
sudo lsof -i -n -P

# List deleted files still held open (causing disk space not to free)
sudo lsof | grep deleted
```

---

## pstree — Process Tree

```bash
# Show process tree
pstree

# Show with PIDs
pstree -p

# Show for a specific user
pstree username

# Show for a specific PID
pstree 1234

# Show with command args
pstree -a

# Highlight process path to PID
pstree -h -p 1234
```

---

## ulimit — Resource Limits

```bash
# Show all current limits
ulimit -a

# Show hard limits
ulimit -aH

# Common limits:
ulimit -n          # Max open files (nofile)
ulimit -u          # Max user processes (nproc)
ulimit -v          # Max virtual memory
ulimit -s          # Stack size
ulimit -c          # Core file size

# Set limit for current shell session
ulimit -n 65535    # Increase open file limit
ulimit -c unlimited  # Allow core dumps

# Set limits in /etc/security/limits.conf (permanent)
# Format: <user/group> <type> <limit> <value>
# * soft nofile 65535
# * hard nofile 65535
# myapp soft nproc 1000
# myapp hard nproc 2000
# @developers soft core unlimited

# Set limits via systemd (for services)
# In unit file [Service] section:
# LimitNOFILE=65535
# LimitNPROC=1000

# Check limits for a running process
cat /proc/1234/limits
```

---

## systemd-cgls & cgroups

```bash
# Show cgroup hierarchy with processes
systemd-cgls

# Show cgroup for a specific service
systemd-cgls /system.slice/nginx.service

# Show resource usage by cgroup
systemd-cgtop

# Show memory usage per cgroup
cat /sys/fs/cgroup/memory/system.slice/nginx.service/memory.usage_in_bytes

# Set CPU/memory limits on a service (transient)
sudo systemctl set-property nginx.service CPUQuota=50%
sudo systemctl set-property nginx.service MemoryMax=512M

# Show cgroup properties for a service
sudo systemctl show nginx.service | grep -i "cpu\|memory\|limit"
```

---

## Tips & Tricks

- `ps aux --sort=-%cpu | head -11` gives a quick non-interactive top sorted by CPU (useful in scripts)
- `kill -9` should be a last resort — SIGTERM allows processes to clean up (close files, flush buffers, remove sockets)
- Use `pkill -f` to match against the full command line, not just process name — much more specific
- Check zombie processes with `ps aux | awk '$8=="Z"'`; zombies are usually cleared when their parent is restarted
- `lsof -i :PORT -t | xargs kill` is the fastest way to kill whatever is using a port
- `/proc/PID/fd/` counts show exact open file descriptor count — useful for diagnosing "too many open files" errors
- `strace -c` (count mode) profiles system call patterns without flooding output — great first step in debugging
- `nohup cmd > out.log 2>&1 & echo $!` captures the PID for later — save it to a PID file for management
- `watch -n 1 "ps aux --sort=-%mem | head -15"` gives a refreshing process view without htop installed
- Process priority with `nice` affects only CPU scheduling; use `ionice` for I/O-bound processes

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
