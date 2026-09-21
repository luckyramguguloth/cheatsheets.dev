# iptables Cheatsheet

> Linux kernel packet filtering firewall for network traffic control.
> Last verified: May 2026 | Version: iptables 1.8.x

---

## Quick Reference

| Command | Description |
|---|---|
| `iptables -L -v -n` | List all rules (verbose, numeric) |
| `iptables -A INPUT -p tcp --dport 22 -j ACCEPT` | Allow SSH |
| `iptables -A INPUT -j DROP` | Drop all other input |
| `iptables -D INPUT 3` | Delete rule number 3 |
| `iptables -I INPUT 1 -j ACCEPT` | Insert rule at position 1 |
| `iptables -F` | Flush all rules |
| `iptables -P INPUT DROP` | Set default DROP policy |
| `iptables-save > rules.v4` | Save rules to file |
| `iptables-restore < rules.v4` | Restore rules from file |
| `iptables -t nat -L -n -v` | List NAT table rules |

---

## Core Concepts

### Tables

```
filter    — Default table. Controls packet acceptance (INPUT, OUTPUT, FORWARD)
nat       — Network address translation (PREROUTING, POSTROUTING, OUTPUT)
mangle    — Packet alteration/marking (all chains)
raw       — Connection tracking exemptions (PREROUTING, OUTPUT)
security  — Mandatory access control (SELinux) marking
```

### Chains

```
INPUT       — Packets destined for the local machine
OUTPUT      — Packets originating from the local machine
FORWARD     — Packets routed through the machine
PREROUTING  — Packets before routing decision (nat, mangle, raw)
POSTROUTING — Packets after routing decision (nat, mangle)
```

### Targets (Actions)

```
ACCEPT     — Allow the packet through
DROP       — Silently discard the packet (connection times out)
REJECT     — Discard and send ICMP error back to sender
LOG        — Log to syslog/kernel log without affecting flow
RETURN     — Return to parent chain
MASQUERADE — Dynamic SNAT (for interfaces with dynamic IPs)
SNAT       — Static source NAT
DNAT       — Destination NAT (port forwarding)
REDIRECT   — Redirect to local port
MARK       — Set netfilter mark on packet
```

---

## Listing Rules

```bash
# List all rules in filter table (default)
sudo iptables -L

# List with verbose stats (packet/byte counts)
sudo iptables -L -v

# List with numeric addresses (skip DNS resolution)
sudo iptables -L -n

# List with rule line numbers (needed for -D and -I)
sudo iptables -L --line-numbers

# All of the above combined (most useful for inspection)
sudo iptables -L -v -n --line-numbers

# List a specific chain only
sudo iptables -L INPUT -v -n --line-numbers
sudo iptables -L OUTPUT -v -n --line-numbers
sudo iptables -L FORWARD -v -n --line-numbers

# List rules for a specific table
sudo iptables -t nat -L -v -n
sudo iptables -t mangle -L -v -n
sudo iptables -t raw -L -v -n

# Show rules as iptables-restore format (exact commands)
sudo iptables -S
sudo iptables -S INPUT
sudo iptables -t nat -S
```

---

## Rule Management

### Adding Rules

```bash
# Append rule to end of chain (-A = append)
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Insert rule at beginning of chain (-I = insert)
sudo iptables -I INPUT -p tcp --dport 22 -j ACCEPT

# Insert at specific position (position 1 = first)
sudo iptables -I INPUT 3 -p tcp --dport 80 -j ACCEPT

# Delete a rule by number (use --line-numbers to find it)
sudo iptables -D INPUT 3

# Delete a rule by specification (exact match)
sudo iptables -D INPUT -p tcp --dport 22 -j ACCEPT

# Replace a rule at a specific position
sudo iptables -R INPUT 3 -p tcp --dport 8080 -j ACCEPT
```

### Flushing and Resetting

```bash
# Flush all rules in a chain
sudo iptables -F INPUT
sudo iptables -F OUTPUT
sudo iptables -F FORWARD

# Flush ALL rules in ALL chains (all tables)
sudo iptables -F

# Flush the nat table
sudo iptables -t nat -F

# Delete all user-defined chains
sudo iptables -X

# Reset packet and byte counters
sudo iptables -Z

# Full reset (flush, delete chains, reset counters)
sudo iptables -F
sudo iptables -X
sudo iptables -Z
sudo iptables -t nat -F
sudo iptables -t nat -X
sudo iptables -t mangle -F
sudo iptables -t mangle -X
```

### Default Policies

```bash
# Set default policy for a chain
sudo iptables -P INPUT DROP     # Default: drop all input
sudo iptables -P OUTPUT ACCEPT  # Default: allow all output
sudo iptables -P FORWARD DROP   # Default: drop forwarding

# View current policies
sudo iptables -L | grep policy
```

---

## Match Options

### Protocol & Port Matches

```bash
# Match by protocol
sudo iptables -A INPUT -p tcp -j ACCEPT
sudo iptables -A INPUT -p udp -j ACCEPT
sudo iptables -A INPUT -p icmp -j ACCEPT

# Match by destination port
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Match by source port
sudo iptables -A INPUT -p tcp --sport 1024:65535 -j ACCEPT

# Match port ranges
sudo iptables -A INPUT -p tcp --dport 8000:8100 -j ACCEPT

# Match multiple ports (multiport module)
sudo iptables -A INPUT -p tcp -m multiport --dports 80,443,8080,8443 -j ACCEPT
sudo iptables -A INPUT -p tcp -m multiport --sports 1024:65535 -j ACCEPT
```

### IP Address Matches

```bash
# Match by source IP
sudo iptables -A INPUT -s 192.168.1.100 -j ACCEPT

# Match by source subnet
sudo iptables -A INPUT -s 192.168.1.0/24 -j ACCEPT

# Match by destination IP
sudo iptables -A OUTPUT -d 10.0.0.5 -j ACCEPT

# Negate match (NOT from this IP)
sudo iptables -A INPUT ! -s 192.168.1.0/24 -j DROP

# Match by interface
sudo iptables -A INPUT -i eth0 -j ACCEPT   # Input interface
sudo iptables -A OUTPUT -o eth0 -j ACCEPT  # Output interface

# Match by MAC address
sudo iptables -A INPUT -m mac --mac-source 00:1a:2b:3c:4d:5e -j ACCEPT
```

### Connection State Matching

```bash
# Allow established and related connections (ESSENTIAL)
sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Allow only new connections
sudo iptables -A INPUT -m state --state NEW -j ACCEPT

# Block invalid packets
sudo iptables -A INPUT -m state --state INVALID -j DROP

# Connection states:
# NEW         — First packet of a new connection
# ESTABLISHED — Part of an established connection
# RELATED     — Related to an established connection (e.g., FTP data)
# INVALID     — Does not match any known connection
```

### Rate Limiting

```bash
# Limit SSH connection attempts (anti-brute-force)
sudo iptables -A INPUT -p tcp --dport 22 -m state --state NEW \
  -m limit --limit 3/min --limit-burst 6 -j ACCEPT

# Log and drop packets exceeding rate
sudo iptables -A INPUT -p tcp --dport 22 -m state --state NEW \
  -j LOG --log-prefix "SSH_BRUTE_FORCE: "
sudo iptables -A INPUT -p tcp --dport 22 -m state --state NEW -j DROP

# Limit ICMP (ping) requests
sudo iptables -A INPUT -p icmp --icmp-type echo-request \
  -m limit --limit 1/s --limit-burst 4 -j ACCEPT

# Recent module for more sophisticated rate limiting
sudo iptables -A INPUT -p tcp --dport 22 -m recent --set --name SSH
sudo iptables -A INPUT -p tcp --dport 22 -m recent --update \
  --seconds 60 --hitcount 4 --name SSH -j DROP
```

---

## LOG Target

```bash
# Log dropped packets with a prefix
sudo iptables -A INPUT -j LOG --log-prefix "IPTABLES_DROP: " --log-level 4

# Log with IP options
sudo iptables -A INPUT -j LOG --log-prefix "INPUT: " --log-ip-options

# Log specific traffic
sudo iptables -A INPUT -p tcp --dport 23 -j LOG \
  --log-prefix "TELNET_ATTEMPT: " --log-level warning

# View iptables logs
sudo journalctl -k | grep IPTABLES
sudo dmesg | grep IPTABLES
sudo tail -f /var/log/kern.log | grep IPTABLES
```

---

## NAT

### Masquerade (Dynamic SNAT)

```bash
# Enable IP forwarding (required for NAT)
echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
# Persistent: add net.ipv4.ip_forward = 1 to /etc/sysctl.conf

# MASQUERADE (for dynamic IPs, e.g., PPPoE, DHCP)
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# Allow forwarded traffic
sudo iptables -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT
```

### SNAT (Static Source NAT)

```bash
# SNAT with a static IP (more efficient than MASQUERADE for static IPs)
sudo iptables -t nat -A POSTROUTING -o eth0 \
  -s 192.168.1.0/24 -j SNAT --to-source 203.0.113.1

# SNAT with IP range
sudo iptables -t nat -A POSTROUTING -o eth0 \
  -j SNAT --to-source 203.0.113.1-203.0.113.3
```

### DNAT (Port Forwarding)

```bash
# Forward external port 80 to internal host
sudo iptables -t nat -A PREROUTING -i eth0 \
  -p tcp --dport 80 -j DNAT --to-destination 192.168.1.10:80

# Forward external port 2222 to internal SSH
sudo iptables -t nat -A PREROUTING -i eth0 \
  -p tcp --dport 2222 -j DNAT --to-destination 192.168.1.10:22

# Allow the forwarded traffic
sudo iptables -A FORWARD -p tcp -d 192.168.1.10 --dport 80 \
  -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

# Redirect local port (REDIRECT target)
sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8080
```

---

## Saving & Restoring Rules

```bash
# Save current rules to a file (Debian/Ubuntu)
sudo iptables-save > /etc/iptables/rules.v4
sudo ip6tables-save > /etc/iptables/rules.v6

# Restore rules from file
sudo iptables-restore < /etc/iptables/rules.v4

# Save with iptables-persistent (auto-restores on boot)
sudo apt install iptables-persistent
sudo netfilter-persistent save    # Save current rules
sudo netfilter-persistent reload  # Reload from file

# RHEL/CentOS/Fedora (using firewalld or iptables service)
sudo service iptables save        # Saves to /etc/sysconfig/iptables
sudo systemctl enable iptables    # Enable at boot

# Save NAT table
sudo iptables-save -t nat > nat-rules.v4
```

---

## Common Firewall Patterns

### Basic Server Firewall

```bash
#!/bin/bash
# Basic secure server firewall

# Flush existing rules
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X

# Default policies
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Allow loopback
iptables -A INPUT -i lo -j ACCEPT

# Allow established and related connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Drop invalid packets
iptables -A INPUT -m state --state INVALID -j DROP

# Allow ICMP (ping)
iptables -A INPUT -p icmp --icmp-type echo-request -m limit \
  --limit 1/s --limit-burst 4 -j ACCEPT

# Allow SSH (rate limited)
iptables -A INPUT -p tcp --dport 22 -m state --state NEW \
  -m limit --limit 3/min --limit-burst 6 -j ACCEPT

# Allow HTTP and HTTPS
iptables -A INPUT -p tcp -m multiport --dports 80,443 \
  -m state --state NEW -j ACCEPT

# Log and drop everything else
iptables -A INPUT -j LOG --log-prefix "DROPPED: " --log-level 4
iptables -A INPUT -j DROP

# Save rules
iptables-save > /etc/iptables/rules.v4
```

### Allow Only Specific IPs

```bash
# Allow from trusted IP range only
sudo iptables -A INPUT -s 10.0.0.0/8 -j ACCEPT
sudo iptables -A INPUT -j DROP

# Whitelist approach for a service
sudo iptables -A INPUT -p tcp --dport 3306 -s 192.168.1.0/24 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 3306 -j DROP
```

### Block Specific IP/Country

```bash
# Block a specific IP
sudo iptables -A INPUT -s 1.2.3.4 -j DROP

# Block and log
sudo iptables -A INPUT -s 1.2.3.4 \
  -j LOG --log-prefix "BLOCKED_IP: "
sudo iptables -A INPUT -s 1.2.3.4 -j DROP

# Block a subnet
sudo iptables -A INPUT -s 1.2.3.0/24 -j DROP
```

---

## nftables — Modern Replacement

```bash
# nftables is the replacement for iptables in modern kernels
# Check if nftables is in use
sudo nft list ruleset

# iptables-to-nftables migration
iptables-save | iptables-restore-translate -f /etc/iptables/rules.v4

# Basic nftables equivalent of iptables filter table
sudo nft add table inet filter
sudo nft add chain inet filter input { type filter hook input priority 0 \; policy drop \; }
sudo nft add chain inet filter forward { type filter hook forward priority 0 \; policy drop \; }
sudo nft add chain inet filter output { type filter hook output priority 0 \; policy accept \; }

# Allow SSH in nftables
sudo nft add rule inet filter input tcp dport 22 ct state new accept

# List nftables rules
sudo nft list table inet filter
```

---

## Tips & Tricks

- Always add `iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT` before DROP policies to avoid locking yourself out
- Use `iptables -I INPUT 1 -j ACCEPT` to temporarily allow all traffic while you fix rules, then remove it with `iptables -D INPUT 1`
- Test rules before saving — a wrong DROP rule on a remote server will lock you out; consider a cron job: `cron: */5 * * * * iptables -F` to auto-flush if you get disconnected
- `REJECT` is friendlier than `DROP` on internal networks (faster failure detection); `DROP` is better against external attackers (no info leakage)
- The `conntrack` module (`--ctstate`) is preferred over `state` (`--state`) on modern kernels
- `iptables-legacy` vs `iptables-nft`: on modern Debian/Ubuntu, `iptables` may be backed by nftables; check with `iptables --version`
- Use `ipset` for efficiently matching large lists of IPs (e.g., country IP ranges) instead of thousands of individual rules
- Rules are evaluated top-to-bottom; first match wins — order matters critically
- `nftables` is the modern successor; new deployments should prefer it; `firewalld` (RHEL) and `ufw` (Ubuntu) are user-friendly wrappers

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
