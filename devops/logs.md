# Log Management Cheatsheet

> Reference guide for system and application logging in Linux environments (systemd, journalctl, rsyslog, nginx, docker).
> Last verified: May 2026 | Version: Linux Core

---

## Quick Reference

| Action | Command |
|---|---|
| View active kernel logs | `dmesg -w` |
| Tail application systemd log | `journalctl -u app.service -f` |
| View logs since 1 hour ago | `journalctl --since "1 hour ago"` |
| Show system daemon log files | `tail -f /var/log/syslog` |
| Tail Docker container logs | `docker logs -f --tail 100 container_id` |
| Force log rotation now | `logrotate -f /etc/logrotate.conf` |

---

## Systemd Journal Management (journalctl)

### View & Tail Log Outputs
```bash
# View all system logs (starts from oldest)
journalctl

# Tail all system logs in real-time (new entries first)
journalctl -f

# View logs for specific service (e.g. nginx)
journalctl -u nginx.service

# View kernel ring buffer messages
journalctl -k
```

### Time-Based Filtering
```bash
# View logs since a specific time
journalctl --since "2026-05-28 00:00:00"

# View logs within a relative time window
journalctl --since "30 min ago" --until "5 min ago"

# View logs for today only
journalctl --since today
```

---

## Docker Container Logging

```bash
# Tail logs with timestamps
docker logs -f -t container_name

# View logs since a specific date
docker logs --since "2026-05-28T09:00:00" container_name

# Inspect logging driver configuration
docker info --format '{{.LoggingDriver}}'
```

---

## Tips & Tricks

- **Log Rotation:** Keep your disks from filling up by setting up custom retention rules inside `/etc/logrotate.d/` for your application logs.
- **Check Disk Space:** To see how much disk space is consumed by journal logs, run: `journalctl --disk-usage`. Clean up old logs with: `journalctl --vacuum-time=7d`.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
