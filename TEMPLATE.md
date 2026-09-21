# [Tool Name] Cheatsheet

> One sentence describing what this tool does and who it's for.
> Last verified: May 2026 | Version: X.X

---

## Quick Reference

> The 10–15 commands people search for most. Keep descriptions ≤ 8 words.

| Command | Description |
|---|---|
| `tool --version` | Show installed version |
| `tool --help` | Show help and usage |
| `tool init` | Initialize a new project |
| `tool start` | Start the tool or service |
| `tool stop` | Stop the tool or service |
| `tool status` | Show current status |
| `tool list` | List all items |
| `tool add <name>` | Add a new item |
| `tool remove <name>` | Remove an item |
| `tool config` | Show configuration |
| `tool logs` | View logs |
| `tool update` | Update to latest version |

---

## Installation

### Linux / macOS

```bash
# Install via package manager (Homebrew example)
brew install toolname

# Install via apt (Debian/Ubuntu)
sudo apt update && sudo apt install toolname

# Install via curl/sh script
curl -fsSL https://install.tool.sh | sh

# Verify installation
tool --version
```

### Windows

```powershell
# Install via Winget
winget install ToolName.ToolName

# Install via Chocolatey
choco install toolname

# Install via Scoop
scoop install toolname

# Verify installation
tool --version
```

### From Source

```bash
# Clone and build from source
git clone https://github.com/org/toolname
cd toolname
make build
sudo make install
```

---

## Getting Started

### First-Time Setup

```bash
# Initialize tool in current directory
tool init

# Configure your identity / credentials
tool config set user.name "Your Name"
tool config set user.email "you@example.com"

# Verify configuration
tool config list
```

**Configuration file location:** `~/.toolname/config` (Linux/macOS) or `%APPDATA%\toolname\config` (Windows)

### Basic Workflow

```bash
# Step 1: Create a new project or resource
tool new my-project

# Step 2: Move into the project directory
cd my-project

# Step 3: Start working (tool-specific action)
tool start

# Step 4: Check that everything is running
tool status

# Step 5: Stop when done
tool stop
```

---

## Core Feature 1 — [e.g., Managing Items]

### Creating Items

```bash
# Create a new item with default settings
tool create my-item

# Create with a specific type or template
tool create my-item --type template-name

# Create with custom options
tool create my-item --option1 value1 --option2 value2

# Create and immediately start
tool create my-item --start
```

### Listing and Inspecting Items

```bash
# List all items
tool list

# List with detailed output
tool list --verbose

# List in JSON format (useful for scripting)
tool list --format json

# Inspect a specific item
tool inspect my-item

# Show item logs
tool logs my-item

# Follow logs in real time
tool logs my-item --follow
```

### Modifying Items

```bash
# Update an item's configuration
tool update my-item --option value

# Restart an item
tool restart my-item

# Scale an item (if applicable)
tool scale my-item --replicas 3

# Rename an item
tool rename my-item new-name
```

### Removing Items

```bash
# Remove a stopped item
tool remove my-item

# Force remove a running item
tool remove my-item --force

# Remove multiple items at once
tool remove item1 item2 item3

# Remove all items matching a filter
tool remove --filter status=stopped
```

---

## Core Feature 2 — [e.g., Networking / Connections]

### Connecting Items

```bash
# Connect item A to item B
tool connect item-a item-b

# Connect with a specific alias
tool connect item-a item-b --alias myalias

# List connections
tool network list

# Disconnect items
tool disconnect item-a item-b
```

### Port Mapping

```bash
# Map host port 8080 to container port 80
tool run --port 8080:80 my-item

# Map multiple ports
tool run --port 8080:80 --port 443:443 my-item

# Map to a specific host interface
tool run --port 127.0.0.1:8080:80 my-item
```

---

## Core Feature 3 — [e.g., Configuration]

### Configuration File

```yaml
# ~/.toolname/config.yml — example configuration file

# General settings
general:
  log_level: info        # debug, info, warn, error
  output_format: text    # text, json, yaml
  color: auto            # auto, always, never

# Connection settings
connection:
  host: localhost
  port: 5432
  timeout: 30s

# Feature flags
features:
  experimental: false
  telemetry: false       # disable anonymous usage stats
```

### Environment Variables

```bash
# Override config via environment variables
export TOOL_LOG_LEVEL=debug
export TOOL_HOST=my-server.local
export TOOL_PORT=9090
export TOOL_TOKEN=your-api-token-here

# Run with environment variable set inline
TOOL_LOG_LEVEL=debug tool start

# View all recognized environment variables
tool env list
```

### Profiles

```bash
# Create a named profile
tool config profile create production

# Switch to a profile
tool config profile use production

# List all profiles
tool config profile list

# Delete a profile
tool config profile delete old-profile
```

---

## Core Feature 4 — [e.g., Plugins / Extensions]

### Managing Plugins

```bash
# List installed plugins
tool plugin list

# Install a plugin from the official registry
tool plugin install plugin-name

# Install a specific version
tool plugin install plugin-name@1.2.3

# Install from a URL
tool plugin install https://example.com/my-plugin.tar.gz

# Update all plugins
tool plugin update --all

# Remove a plugin
tool plugin remove plugin-name
```

### Creating a Plugin

```bash
# Scaffold a new plugin
tool plugin new my-plugin

# Directory structure created:
# my-plugin/
# ├── plugin.json     # manifest with name, version, description
# ├── main.sh         # entrypoint script
# └── README.md       # documentation

# Test the plugin locally
tool plugin test ./my-plugin

# Package for distribution
tool plugin pack ./my-plugin
```

---

## Advanced Usage

### Scripting and Automation

```bash
# Use JSON output for scripting
tool list --format json | jq '.[].name'

# Loop over all items
for item in $(tool list --quiet); do
  echo "Processing: $item"
  tool inspect "$item"
done

# Pipe commands
tool list --format json | jq -r '.[].id' | xargs tool remove

# Use in CI/CD — suppress interactive prompts
tool deploy --yes --no-tty

# Exit with non-zero status code on failure (for scripts)
tool run my-item || { echo "Failed!"; exit 1; }
```

### Debugging

```bash
# Run with verbose/debug output
tool --debug start

# Enable trace logging (maximum verbosity)
tool --log-level trace start

# Dry run — show what would happen without doing it
tool deploy --dry-run

# Validate a config file without applying it
tool config validate ./config.yml

# Check connectivity / health
tool health check

# Show version and build info
tool version --full
```

### Performance Tuning

```bash
# Limit CPU usage
tool run my-item --cpus 2.0

# Limit memory
tool run my-item --memory 512m

# Set resource constraints
tool run my-item --cpus 1.5 --memory 256m --memory-swap 512m

# View resource usage in real time
tool stats

# View resource usage for a specific item
tool stats my-item
```

---

## Common Workflows

### Workflow: Deploy to Production

```bash
# Pull latest changes
git pull origin main

# Build the artifact
tool build --env production --tag v1.2.3

# Run smoke tests
tool test --suite smoke

# Deploy with zero downtime
tool deploy --strategy rolling --replicas 3 --tag v1.2.3

# Verify deployment
tool status --verbose

# Roll back if something is wrong
tool rollback --to v1.2.2
```

### Workflow: Local Development

```bash
# Start all development dependencies
tool up --file docker-compose.dev.yml

# Watch for changes and auto-reload
tool run --watch ./src

# Open a shell inside the running environment
tool exec -it my-item /bin/bash

# Tear down everything
tool down --volumes
```

### Workflow: Backup and Restore

```bash
# Export/backup data
tool export my-item --output backup-$(date +%Y%m%d).tar.gz

# List backups
ls -lh backups/

# Restore from backup
tool import --file backup-20260528.tar.gz

# Verify restore was successful
tool verify my-item
```

---

## Error Reference

| Error | Meaning | Fix |
|---|---|---|
| `Error: permission denied` | Insufficient privileges | Run with `sudo` or fix file permissions |
| `Error: port already in use` | Port conflict on host | Change port or stop conflicting process |
| `Error: connection refused` | Service not running | Start the service first |
| `Error: image not found` | Missing dependency | Run `tool pull` or install missing component |
| `Error: config file not found` | Missing config | Run `tool init` to generate default config |
| `Error: timeout exceeded` | Network/resource issue | Increase timeout with `--timeout 60s` |
| `Error: quota exceeded` | Resource limit hit | Increase quota or free up resources |

---

## Tips & Tricks

- **Use shell aliases** for long commands you run often: `alias tl='tool list --verbose'`
- **JSON output + jq** is the most powerful combination for scripting: `tool list -o json | jq '.[] | select(.status=="running")'`
- **Tab completion** is available for most shells — run `tool completion bash >> ~/.bashrc` to install it.
- **Dry runs first** — always use `--dry-run` before destructive operations like delete or rollback.
- **Environment variables override config** — useful for CI/CD pipelines without modifying config files.
- **Log levels** — run with `--log-level debug` when something breaks; it shows the full request/response cycle.
- **Version pinning** — always pin tool versions in production scripts to avoid breaking changes: `tool@1.2.3`.

---

## Official Resources

- 📖 [Official Documentation](https://docs.toolname.io)
- 🐙 [GitHub Repository](https://github.com/org/toolname)
- 💬 [Community Forum / Discord](https://discord.gg/toolname)
- 🐛 [Issue Tracker](https://github.com/org/toolname/issues)
- 📦 [Plugin Registry](https://plugins.toolname.io)

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
