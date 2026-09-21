# Systemd Cheatsheet

> Linux init system and service manager for modern Linux distributions.
> Last verified: May 2026 | Version: systemd 255

---

## Quick Reference

| Command | Description |
|---|---|
| `systemctl start <unit>` | Start a unit |
| `systemctl stop <unit>` | Stop a unit |
| `systemctl restart <unit>` | Restart a unit |
| `systemctl enable <unit>` | Enable at boot |
| `systemctl disable <unit>` | Disable at boot |
| `systemctl status <unit>` | Show unit status |
| `journalctl -u <unit>` | Show unit logs |
| `journalctl -f` | Follow system journal |
| `systemd-analyze blame` | Show boot time by unit |
| `systemctl list-units` | List all active units |

---

## systemctl — Service Management

### Starting, Stopping, Restarting

```bash
# Start a service
sudo systemctl start nginx

# Stop a service
sudo systemctl stop nginx

# Restart a service (stop then start)
sudo systemctl restart nginx

# Reload configuration without restarting (if supported)
sudo systemctl reload nginx

# Reload config or restart if reload not supported
sudo systemctl reload-or-restart nginx

# Try to reload, restart only if running
sudo systemctl try-reload-or-restart nginx
```

### Enabling & Disabling

```bash
# Enable a service (start at boot)
sudo systemctl enable nginx

# Disable a service (don't start at boot)
sudo systemctl disable nginx

# Enable AND immediately start a service
sudo systemctl enable --now nginx

# Disable AND immediately stop a service
sudo systemctl disable --now nginx

# Mask a service (prevent it from being started at all)
sudo systemctl mask nginx

# Unmask a service
sudo systemctl unmask nginx
```

### Checking Status

```bash
# Show detailed status of a service
systemctl status nginx

# Check if a service is active (running)
systemctl is-active nginx

# Check if a service is enabled (starts at boot)
systemctl is-enabled nginx

# Check if a service has failed
systemctl is-failed nginx

# Show status of multiple services
systemctl status nginx mysql redis

# Quiet status check (for scripts — returns exit code)
systemctl is-active --quiet nginx && echo "Running" || echo "Not running"
```

---

## Listing Units

```bash
# List all active units
systemctl list-units

# List all units (active and inactive)
systemctl list-units --all

# List only failed units
systemctl list-units --state=failed

# List only services
systemctl list-units --type=service

# List all installed unit files
systemctl list-unit-files

# List only enabled unit files
systemctl list-unit-files --state=enabled

# List unit files of a specific type
systemctl list-unit-files --type=service

# List sockets
systemctl list-units --type=socket

# List timers
systemctl list-units --type=timer
```

---

## journalctl — Log Viewing

### Basic Log Commands

```bash
# Show all journal entries (full log)
journalctl

# Follow new log entries in real-time
journalctl -f

# Show logs since boot
journalctl -b

# Show logs from previous boot
journalctl -b -1

# Show logs from two boots ago
journalctl -b -2

# List available boots
journalctl --list-boots
```

### Filtering by Unit

```bash
# Show logs for a specific service
journalctl -u nginx

# Follow logs for a specific service
journalctl -f -u nginx

# Show logs for multiple units
journalctl -u nginx -u mysql

# Show kernel messages only
journalctl -k

# Show logs from a specific executable
journalctl /usr/sbin/nginx
```

### Filtering by Time

```bash
# Show logs since a specific time
journalctl --since "2026-05-20 10:00:00"

# Show logs until a specific time
journalctl --until "2026-05-20 12:00:00"

# Show logs between two times
journalctl --since "2026-05-20 10:00" --until "2026-05-20 11:00"

# Relative time shortcuts
journalctl --since "1 hour ago"
journalctl --since "yesterday"
journalctl --since "today"
journalctl --since "2 days ago"
```

### Filtering by Priority

```bash
# Show only error messages and above
journalctl -p err

# Priority levels: emerg, alert, crit, err, warning, notice, info, debug
journalctl -p warning

# Show debug and above (all)
journalctl -p debug

# Show errors for a specific service
journalctl -u nginx -p err
```

### Output Formatting

```bash
# Show last N lines
journalctl -n 50
journalctl -n 100 -u nginx

# Output as JSON (one object per line)
journalctl -o json

# Pretty JSON output
journalctl -o json-pretty

# Short output (default)
journalctl -o short

# Short with monotonic timestamps
journalctl -o short-monotonic

# Cat output (message only, no timestamps)
journalctl -o cat

# Verbose output (all fields)
journalctl -o verbose

# Export format (for archiving)
journalctl -o export
```

### Disk Usage & Maintenance

```bash
# Show how much disk the journal is using
journalctl --disk-usage

# Vacuum logs older than a time period
sudo journalctl --vacuum-time=2weeks
sudo journalctl --vacuum-time=30d

# Vacuum logs to a size limit
sudo journalctl --vacuum-size=500M

# Verify journal integrity
journalctl --verify
```

---

## Unit File Structure

### Service Unit File

```ini
# /etc/systemd/system/myapp.service
[Unit]
Description=My Application Service
Documentation=https://example.com/docs
After=network.target mysql.service
Requires=mysql.service              # Hard dependency
Wants=redis.service                 # Soft dependency (nice to have)

[Service]
Type=simple                         # simple, forking, oneshot, notify, idle
User=myapp                          # Run as this user
Group=myapp
WorkingDirectory=/opt/myapp
ExecStart=/opt/myapp/bin/myapp --config /etc/myapp/config.yml
ExecReload=/bin/kill -HUP $MAINPID # Command for reload
ExecStop=/bin/kill -TERM $MAINPID  # Custom stop command
Restart=always                      # always, on-failure, on-abnormal, no
RestartSec=5                        # Wait 5s before restart
StandardOutput=journal              # Log stdout to journal
StandardError=journal               # Log stderr to journal
Environment=NODE_ENV=production
EnvironmentFile=/etc/myapp/env      # Load env from file
LimitNOFILE=65535                   # Open file limit
TimeoutStartSec=30                  # Seconds before start times out
TimeoutStopSec=30                   # Seconds before stop times out

[Install]
WantedBy=multi-user.target          # Enable target (boot runlevel)
```

### Service Types

```bash
# Type=simple (default): ExecStart is the main process
# Type=forking: process forks, parent exits (old-style daemons)
# Type=oneshot: runs once and exits (scripts, cron-like)
# Type=notify: process signals ready via sd_notify()
# Type=dbus: process registers on D-Bus name
# Type=idle: like simple, but waits for all other jobs to finish
```

### Timer Unit File

```ini
# /etc/systemd/system/myapp-backup.timer
[Unit]
Description=Run myapp backup daily

[Timer]
OnCalendar=daily                    # Daily at midnight
OnCalendar=*-*-* 02:30:00          # Every day at 2:30 AM
OnCalendar=Mon,Tue *-*-* 04:00:00  # Mon and Tue at 4 AM
OnBootSec=15min                     # 15 min after boot
OnUnitActiveSec=1h                  # Every 1 hour after last run
RandomizedDelaySec=300              # Random delay up to 5 min
Persistent=true                     # Run missed timers on boot

[Install]
WantedBy=timers.target
```

```ini
# /etc/systemd/system/myapp-backup.service (paired with timer)
[Unit]
Description=Myapp Backup

[Service]
Type=oneshot
User=backup
ExecStart=/usr/local/bin/backup.sh
```

### Socket Unit File

```ini
# /etc/systemd/system/myapp.socket
[Unit]
Description=Myapp Socket Activation

[Socket]
ListenStream=8080               # TCP port
ListenStream=/run/myapp.sock    # Unix socket
Accept=no                       # Pass socket FD to service

[Install]
WantedBy=sockets.target
```

---

## Creating Custom Services

```bash
# Step 1: Create the unit file
sudo nano /etc/systemd/system/myapp.service

# Step 2: Reload systemd to recognize the new unit file
sudo systemctl daemon-reload

# Step 3: Enable and start the service
sudo systemctl enable --now myapp.service

# Step 4: Check it's running
systemctl status myapp.service

# Step 5: View its logs
journalctl -u myapp.service -f

# Edit an existing unit file
sudo systemctl edit --full myapp.service    # Edit the original unit file

# Create a drop-in override (preferred: doesn't replace original)
sudo systemctl edit myapp.service
# Creates /etc/systemd/system/myapp.service.d/override.conf
```

### Drop-in Override Example

```ini
# /etc/systemd/system/nginx.service.d/override.conf
[Service]
# Override just the memory limit without replacing the whole unit
MemoryMax=512M
CPUQuota=50%
```

---

## Targets (Runlevels)

```bash
# List all targets
systemctl list-units --type=target

# Get current default target
systemctl get-default

# Set default target
sudo systemctl set-default multi-user.target
sudo systemctl set-default graphical.target

# Switch target immediately (like changing runlevels)
sudo systemctl isolate multi-user.target
sudo systemctl isolate rescue.target

# Common targets:
# poweroff.target  = halt
# rescue.target    = single user mode (runlevel 1)
# multi-user.target = multi-user, no GUI (runlevel 3)
# graphical.target  = multi-user with GUI (runlevel 5)
# reboot.target    = reboot
# emergency.target  = emergency shell
```

---

## Boot Analysis

```bash
# Show total boot time breakdown
systemd-analyze

# Show time spent by each unit during boot
systemd-analyze blame

# Show boot time in a critical chain (slowest path)
systemd-analyze critical-chain

# Show critical chain for a specific unit
systemd-analyze critical-chain nginx.service

# Generate an SVG of the boot sequence
systemd-analyze plot > boot.svg

# Check unit file for errors
systemd-analyze verify /etc/systemd/system/myapp.service

# Show security assessment of a unit
systemd-analyze security myapp.service
```

---

## System Control Commands

```bash
# Reboot the system
sudo systemctl reboot

# Power off the system
sudo systemctl poweroff

# Halt (stop CPU without power off)
sudo systemctl halt

# Suspend to RAM
sudo systemctl suspend

# Hibernate (suspend to disk)
sudo systemctl hibernate

# Hybrid sleep
sudo systemctl hybrid-sleep

# Emergency mode (minimal, single user)
sudo systemctl emergency

# Rescue mode
sudo systemctl rescue
```

---

## User Services

```bash
# Run systemd in user mode (--user flag)
systemctl --user status
systemctl --user start myapp.service
systemctl --user enable myapp.service
journalctl --user -u myapp.service

# User unit files location
# ~/.config/systemd/user/

# Enable linger (user units start at boot, not login)
sudo loginctl enable-linger username
```

---

## Environment & Security

```bash
# Show environment for a service
systemctl show-environment

# Set environment variable for systemd
sudo systemctl set-environment MY_VAR=value

# Unset environment variable
sudo systemctl unset-environment MY_VAR

# Security hardening options in unit files (examples)
```

```ini
[Service]
NoNewPrivileges=yes         # Prevent privilege escalation
ProtectSystem=strict        # Make /usr, /boot, /etc read-only
ProtectHome=yes             # Make /home, /root inaccessible
PrivateTmp=yes              # Private /tmp directory
PrivateDevices=yes          # No device access
CapabilityBoundingSet=      # Drop all capabilities
AmbientCapabilities=        # No ambient capabilities
ReadOnlyPaths=/etc          # Specific read-only paths
ReadWritePaths=/var/lib/myapp  # Specific writable paths
```

---

## Tips & Tricks

- Use `systemctl edit <unit>` (without `--full`) to create a drop-in override instead of modifying the original unit file — this survives package updates
- `journalctl -xe` shows the end of the journal with explanations — great for diagnosing failed service startups
- `systemctl cat <unit>` shows the full content of a unit file including all drop-in overrides
- `systemctl daemon-reload` is required after ANY change to unit files — forgetting this is a common mistake
- `systemctl --failed` is the fastest way to see what's broken on a system
- `journalctl _COMM=nginx` filters by executable name, useful when the unit name is unknown
- Use `Restart=on-failure` with `RestartSec=5` for production services to auto-recover from crashes
- `WantedBy=` vs `RequiredBy=`: Wants is a soft dependency (failure is OK), Requires is hard (failure stops the target)
- `systemd-run --unit=myjob.service /path/to/script` runs a one-off command as a transient service
- Check `systemd-cgls` to view the full cgroup hierarchy including all processes

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
