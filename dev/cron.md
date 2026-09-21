# Cron Cheatsheet

> Reference guide for Linux crontab scheduling syntax, operators, and troubleshooting.
> Last verified: May 2026 | Version: Vixie Cron / Systemd-cron

---

## Quick Reference

### Crontab Syntax
```
* * * * *
│ │ │ │ │
│ │ │ │ └─── Day of Week (0 - 6) (Sunday=0 or 7)
│ │ │ └──────── Month (1 - 12)
│ │ └───────────── Day of Month (1 - 31)
│ └────────────────── Hour (0 - 23)
└───────────────────── Minute (0 - 59)
```

| Schedule Expression | Frequency |
|---|---|
| `* * * * *` | Every single minute |
| `*/5 * * * *` | Every 5 minutes |
| `0 * * * *` | Every hour (at minute 0) |
| `0 9 * * *` | Every day at 9:00 AM |
| `0 0 * * 1` | Every Monday at midnight |
| `0 0 1 1 *` | Yearly on January 1st at midnight |
| `@reboot` | Run once at system startup |

---

## Command Reference & Configuration

### Basic Commands
```bash
# Edit active crontab for current user
crontab -e

# List crontab contents for current user
crontab -l

# Remove current crontab
crontab -r

# Edit crontab for a specific user (requires sudo)
sudo crontab -u username -e
```

### Operators
- `*` : Match all values.
- `,` : Value list (e.g. `0,30 * * * *` runs on the hour and half-hour).
- `-` : Value range (e.g. `0 9-17 * * *` runs hourly from 9 AM to 5 PM).
- `/` : Step intervals (e.g. `*/15 * * * *` runs every 15 minutes).

---

## Tips & Tricks

- **Capture Output:** Cron doesn't capture standard output by default; it attempts to email it. Redirect output to logs: `0 9 * * * /path/to/script.sh >> /var/log/mycron.log 2>&1`.
- **Absolute Paths:** Cron executes in a limited shell environment with a minimal `PATH`. Always use absolute paths for both command binaries and file references (e.g., `/usr/bin/python3` instead of `python3`).

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
