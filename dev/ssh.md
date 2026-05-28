# SSH Cheatsheet

> SSH (Secure Shell) — encrypted remote login, tunneling, and file transfer.
> Last verified: May 2026 | Version: OpenSSH 9.x

---

## Quick Reference

| Command | Description |
|---|---|
| `ssh user@host` | Connect to remote host |
| `ssh -p 2222 user@host` | Connect on custom port |
| `ssh-keygen -t ed25519` | Generate ED25519 key pair |
| `ssh-copy-id user@host` | Install public key on server |
| `ssh -L 8080:localhost:80 user@host` | Local port forward |
| `ssh -R 9090:localhost:3000 user@host` | Remote port forward |
| `ssh -D 1080 user@host` | SOCKS5 dynamic proxy |
| `scp file.txt user@host:/path/` | Copy file to remote |
| `sftp user@host` | Interactive SFTP session |
| `ssh -J jump@bastion user@target` | ProxyJump (bastion host) |

---

## Connecting

```bash
# Basic connection
ssh user@hostname
ssh user@192.168.1.100

# Custom port
ssh -p 2222 user@hostname

# Specify identity file (private key)
ssh -i ~/.ssh/my_key user@hostname

# Verbose output (debug connection issues)
ssh -v user@hostname
ssh -vv user@hostname    # more verbose
ssh -vvv user@hostname   # maximum verbosity

# Specify SSH config alias
ssh my-server            # uses ~/.ssh/config alias

# Run command without interactive shell
ssh user@hostname "ls -la /var/log"
ssh user@hostname "df -h && free -h"

# Run local script on remote host
ssh user@hostname 'bash -s' < local_script.sh

# Pass environment variable
ssh -o SendEnv=MY_VAR user@hostname

# Disable strict host key checking (for scripts, not production)
ssh -o StrictHostKeyChecking=no user@hostname

# Prevent adding to known_hosts
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no user@hostname

# Keep connection alive
ssh -o ServerAliveInterval=60 user@hostname
```

---

## Key Generation

```bash
# Generate ED25519 key (recommended, modern)
ssh-keygen -t ed25519 -C "your.email@example.com"

# Generate RSA key (4096-bit, wider compatibility)
ssh-keygen -t rsa -b 4096 -C "your.email@example.com"

# Generate ECDSA key
ssh-keygen -t ecdsa -b 521 -C "your.email@example.com"

# Specify output file
ssh-keygen -t ed25519 -f ~/.ssh/github_key -C "github"

# Generate with passphrase non-interactively
ssh-keygen -t ed25519 -N "my-passphrase" -f ~/.ssh/my_key

# Generate without passphrase (automation)
ssh-keygen -t ed25519 -N "" -f ~/.ssh/deploy_key

# Change passphrase on existing key
ssh-keygen -p -f ~/.ssh/id_ed25519

# Show public key fingerprint
ssh-keygen -l -f ~/.ssh/id_ed25519
ssh-keygen -l -E sha256 -f ~/.ssh/id_ed25519

# Show public key
cat ~/.ssh/id_ed25519.pub

# Generate from existing private key
ssh-keygen -y -f ~/.ssh/id_rsa > ~/.ssh/id_rsa.pub
```

---

## Installing Keys (ssh-copy-id)

```bash
# Copy default public key to remote host
ssh-copy-id user@hostname

# Specify key file
ssh-copy-id -i ~/.ssh/id_ed25519.pub user@hostname

# Copy on custom port
ssh-copy-id -p 2222 -i ~/.ssh/id_ed25519.pub user@hostname

# Manual method (if ssh-copy-id unavailable)
cat ~/.ssh/id_ed25519.pub | ssh user@hostname "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"

# Or paste the key manually
ssh user@hostname
mkdir -p ~/.ssh
echo "ssh-ed25519 AAAA... your@email.com" >> ~/.ssh/authorized_keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys

# From Windows
type C:\Users\you\.ssh\id_ed25519.pub | ssh user@hostname "cat >> ~/.ssh/authorized_keys"
```

---

## SSH Config File (`~/.ssh/config`)

```bash
# ~/.ssh/config — define aliases and options per host

# Global defaults
Host *
    ServerAliveInterval 60
    ServerAliveCountMax 3
    AddKeysToAgent yes
    IdentityFile ~/.ssh/id_ed25519

# Simple alias
Host myserver
    HostName 192.168.1.100
    User alice
    Port 22
    IdentityFile ~/.ssh/my_key

# Bastion/Jump host
Host bastion
    HostName bastion.example.com
    User ops
    IdentityFile ~/.ssh/bastion_key

Host prod-app
    HostName 10.0.1.50
    User deploy
    ProxyJump bastion
    IdentityFile ~/.ssh/prod_key

# ProxyJump with multiple hops
Host deep-server
    HostName 10.0.2.100
    User admin
    ProxyJump bastion,prod-app

# GitHub
Host github.com
    User git
    IdentityFile ~/.ssh/github_ed25519
    AddKeysToAgent yes

# Multiple GitHub accounts
Host github-personal
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_personal

Host github-work
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_work

# Wildcard for dev servers
Host dev-*
    User developer
    IdentityFile ~/.ssh/dev_key
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null

# Check config syntax
ssh -G myserver
```

### Config Options Reference

| Option | Description |
|---|---|
| `HostName` | Real hostname or IP |
| `User` | Login username |
| `Port` | SSH port (default 22) |
| `IdentityFile` | Private key path |
| `ProxyJump` | Jump through host(s) |
| `ServerAliveInterval` | Keepalive interval (secs) |
| `ServerAliveCountMax` | Max keepalive failures |
| `ForwardAgent` | Forward SSH agent |
| `StrictHostKeyChecking` | yes/no/accept-new |
| `AddKeysToAgent` | Auto-add to agent |
| `Compression` | Enable compression |
| `ControlMaster auto` | Connection multiplexing |
| `ControlPath` | Socket for multiplexing |
| `ControlPersist 10m` | Keep master alive 10 min |

---

## SSH Agent

```bash
# Start SSH agent
eval "$(ssh-agent -s)"

# Add default key
ssh-add

# Add specific key
ssh-add ~/.ssh/id_ed25519

# Add with passphrase caching (macOS)
ssh-add --apple-use-keychain ~/.ssh/id_ed25519

# List loaded keys
ssh-add -l
ssh-add -L   # shows full public keys

# Remove key from agent
ssh-add -d ~/.ssh/id_ed25519

# Remove all keys
ssh-add -D

# Agent forwarding (forward agent to remote)
ssh -A user@hostname

# In config
Host myserver
    ForwardAgent yes
```

---

## Port Forwarding / Tunneling

### Local Port Forward

```bash
# Forward local port to remote destination (through SSH server)
# Access remote DB at localhost:5432
ssh -L 5432:database.internal:5432 user@ssh-server

# Access remote web app
ssh -L 8080:localhost:3000 user@remote-server

# Multiple forwards in one command
ssh -L 8080:localhost:80 -L 5432:db.internal:5432 user@server

# Background tunnel (no shell)
ssh -N -L 5432:localhost:5432 user@server

# Background + detach
ssh -fN -L 5432:localhost:5432 user@server    # -f: background
```

### Remote Port Forward

```bash
# Expose local port on the remote server
# Remote users connect to remote:9090 → local:3000
ssh -R 9090:localhost:3000 user@remote-server

# Expose local service to internet (via public server)
ssh -R 0.0.0.0:8080:localhost:3000 user@public-server

# Requires GatewayPorts yes in remote sshd_config
```

### Dynamic (SOCKS5) Proxy

```bash
# Create SOCKS5 proxy on port 1080
ssh -D 1080 user@server

# Background SOCKS proxy
ssh -fN -D 1080 user@server

# Use with curl
curl --socks5 127.0.0.1:1080 https://example.com

# Use with chromium
chromium --proxy-server="socks5://127.0.0.1:1080"
```

---

## ProxyJump (Bastion Host)

```bash
# Single jump host
ssh -J jumpuser@bastion targetuser@internal-host

# Multiple jump hosts
ssh -J user@hop1,user@hop2 user@target

# Using config (recommended)
Host internal
    HostName 10.0.1.50
    User deploy
    ProxyJump bastion.example.com

# Old method (ProxyCommand)
ssh -o ProxyCommand="ssh -W %h:%p user@bastion" user@internal
```

---

## SCP — File Transfer

```bash
# Copy file from local to remote
scp file.txt user@host:/remote/path/
scp file.txt user@host:~/

# Copy file from remote to local
scp user@host:/remote/file.txt ./local/

# Copy directory recursively
scp -r ./local-dir/ user@host:/remote/path/

# Custom port
scp -P 2222 file.txt user@host:/path/

# Specify identity file
scp -i ~/.ssh/my_key file.txt user@host:/path/

# Copy between two remote hosts (via local)
scp user1@host1:/path/file user2@host2:/path/

# Preserve file attributes (timestamps, mode)
scp -p file.txt user@host:/path/

# Limit bandwidth (Kbit/s)
scp -l 1000 large-file.zip user@host:/path/

# Verbose
scp -v file.txt user@host:/path/

# Multiple files
scp file1.txt file2.txt user@host:/path/
scp *.txt user@host:/path/
```

---

## SFTP — Interactive File Transfer

```bash
# Start SFTP session
sftp user@hostname

# SFTP on custom port
sftp -P 2222 user@hostname

# Batch mode (non-interactive)
sftp -b commands.txt user@hostname

# SFTP commands (inside session)
sftp> pwd                    # remote working directory
sftp> lpwd                   # local working directory
sftp> ls                     # list remote directory
sftp> lls                    # list local directory
sftp> cd /remote/path        # change remote directory
sftp> lcd /local/path        # change local directory
sftp> get remote-file.txt    # download file
sftp> get remote.txt local.txt  # download with new name
sftp> mget *.txt             # download multiple files
sftp> put local-file.txt     # upload file
sftp> mput *.txt             # upload multiple files
sftp> mkdir new-dir          # create remote directory
sftp> rm remote-file.txt     # delete remote file
sftp> rename old.txt new.txt # rename remote file
sftp> chmod 644 file.txt     # change permissions
sftp> exit                   # exit session
sftp> quit                   # exit session

# Non-interactive download
sftp -b - user@host <<EOF
get /remote/file.txt /local/file.txt
EOF
```

---

## Known Hosts Management

```bash
# View known_hosts file
cat ~/.ssh/known_hosts

# Remove a specific host entry (when key changed)
ssh-keygen -R hostname
ssh-keygen -R 192.168.1.100
ssh-keygen -R [hostname]:2222    # custom port

# Remove and re-add (after server reinstall)
ssh-keygen -R hostname && ssh user@hostname

# Scan and add host key manually
ssh-keyscan hostname >> ~/.ssh/known_hosts
ssh-keyscan -p 2222 hostname >> ~/.ssh/known_hosts
ssh-keyscan -t ed25519 hostname >> ~/.ssh/known_hosts

# Verify host fingerprint
ssh-keygen -l -f /etc/ssh/ssh_host_ed25519_key.pub  # run on server

# Hash known_hosts (privacy)
ssh-keygen -H

# Accept new keys automatically, reject changed (secure default)
ssh -o StrictHostKeyChecking=accept-new user@hostname
```

---

## SSH Server Hardening (sshd_config)

```bash
# /etc/ssh/sshd_config — key security settings

# Disable password authentication (keys only)
PasswordAuthentication no

# Disable root login
PermitRootLogin no
PermitRootLogin prohibit-password   # allow root with key only

# Change default port
Port 2222

# Restrict to specific users
AllowUsers alice bob
AllowGroups sshusers

# Disable empty passwords
PermitEmptyPasswords no

# Disable X11 forwarding (unless needed)
X11Forwarding no

# Disable agent forwarding (unless needed)
AllowAgentForwarding no

# Maximum auth attempts
MaxAuthTries 3

# Limit login grace time
LoginGraceTime 30

# Allow only strong key types
HostKeyAlgorithms ssh-ed25519,rsa-sha2-512,rsa-sha2-256
PubkeyAcceptedKeyTypes ssh-ed25519,rsa-sha2-512

# Idle session timeout
ClientAliveInterval 300
ClientAliveCountMax 2

# Use verbose logging
LogLevel VERBOSE

# Test config before restarting
sshd -t

# Reload SSH daemon
systemctl reload sshd
```

---

## Connection Multiplexing

```bash
# ~/.ssh/config — reuse connections for speed
Host myserver
    ControlMaster auto
    ControlPath ~/.ssh/control-%C
    ControlPersist 10m

# Now multiple connections reuse same socket
ssh myserver         # opens master
ssh myserver         # reuses existing
scp file myserver:   # reuses existing
```

---

## Escape Sequences

While connected, press `~` then:

| Sequence | Action |
|---|---|
| `~.` | Disconnect |
| `~^Z` | Suspend ssh to background |
| `~#` | List forwarded connections |
| `~&` | Background ssh (logout) |
| `~?` | Show help |
| `~~` | Send literal `~` |

---

## Tips & Tricks

- Use `ed25519` keys — smaller, faster, and more secure than RSA
- Always set a passphrase on private keys; use `ssh-agent` to cache it
- Use `~/.ssh/config` Host aliases — they save tons of typing
- `ssh -fN` creates background tunnels perfect for long-running proxies
- Connection multiplexing (`ControlMaster`) dramatically speeds up repeated connections
- Store server fingerprints in `known_hosts` — verify out-of-band first
- `ssh-keyscan` is useful for CI/CD pipelines to pre-populate `known_hosts`
- Never forward your agent (`-A`) to untrusted servers
- Use `ProxyJump` instead of the older `ProxyCommand` method
- `rsync -avz -e ssh` is better than `scp` for syncing directories
- `autossh` automatically restarts tunnels if they drop

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
