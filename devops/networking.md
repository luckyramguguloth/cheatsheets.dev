# Linux Networking Cheatsheet

> Essential Linux networking tools for diagnostics, configuration, and troubleshooting.
> Last verified: May 2026 | Version: iproute2 6.x, net-tools

---

## Quick Reference

| Command | Description |
|---|---|
| `ip addr show` | Show IP addresses |
| `ip route show` | Show routing table |
| `ss -tulpn` | Show open ports and services |
| `ping -c4 8.8.8.8` | Test connectivity |
| `traceroute google.com` | Trace packet path |
| `dig google.com` | DNS lookup |
| `nmap -sV 192.168.1.1` | Service/port scan |
| `tcpdump -i eth0` | Capture packets |
| `curl -I https://example.com` | Fetch HTTP headers |
| `nc -zv host 80` | Test TCP port connectivity |

---

## ip Command (iproute2)

### IP Addresses

```bash
# Show all network interfaces and IP addresses
ip addr show
ip a                          # Short form

# Show a specific interface
ip addr show eth0

# Add an IP address to an interface
sudo ip addr add 192.168.1.100/24 dev eth0

# Remove an IP address
sudo ip addr del 192.168.1.100/24 dev eth0

# Show only IPv4 addresses
ip -4 addr show

# Show only IPv6 addresses
ip -6 addr show

# Show statistics with addresses
ip -s addr show
```

### Network Links (Interfaces)

```bash
# List all network interfaces
ip link show
ip l

# Bring an interface up
sudo ip link set eth0 up

# Bring an interface down
sudo ip link set eth0 down

# Set MTU on an interface
sudo ip link set eth0 mtu 9000

# Set MAC address (interface must be down)
sudo ip link set eth0 address 02:42:ac:11:00:01

# Show interface statistics (RX/TX bytes, errors)
ip -s link show eth0

# Add a VLAN interface
sudo ip link add link eth0 name eth0.100 type vlan id 100

# Add a bridge interface
sudo ip link add name br0 type bridge
sudo ip link set eth0 master br0
```

### Routing

```bash
# Show routing table
ip route show
ip r

# Show route to a specific destination
ip route get 8.8.8.8

# Add a static route
sudo ip route add 10.0.0.0/8 via 192.168.1.1

# Add a default gateway
sudo ip route add default via 192.168.1.1

# Delete a route
sudo ip route del 10.0.0.0/8

# Add a route via a specific interface
sudo ip route add 10.0.0.0/8 dev eth0

# Flush the routing cache
sudo ip route flush cache

# Show IPv6 routes
ip -6 route show
```

### Neighbors (ARP/NDP)

```bash
# Show ARP/neighbor cache
ip neigh show
ip n

# Add a static ARP entry
sudo ip neigh add 192.168.1.1 lladdr 00:1a:2b:3c:4d:5e dev eth0

# Delete an ARP entry
sudo ip neigh del 192.168.1.1 dev eth0

# Flush neighbor cache
sudo ip neigh flush dev eth0
```

---

## ss — Socket Statistics

```bash
# Show all listening TCP and UDP sockets with processes
ss -tulpn

# Show all established TCP connections
ss -t state established

# Show all sockets (connected and listening)
ss -a

# Show listening sockets only
ss -l

# Show TCP sockets
ss -t

# Show UDP sockets
ss -u

# Show Unix sockets
ss -x

# Show sockets with process info (requires root for other users)
ss -p

# Show numeric addresses (don't resolve hostnames)
ss -n

# Summary statistics
ss -s

# Filter by port
ss -tlpn sport = :80
ss -tlpn dport = :443

# Show sockets for a specific process
ss -tp | grep nginx

# Show connections to a specific host
ss -tn dst 8.8.8.8
```

---

## netstat (Legacy, use ss)

```bash
# Show all listening ports with processes (numeric)
netstat -tulpn

# Show all active connections
netstat -an

# Show routing table
netstat -r

# Show network interface statistics
netstat -i

# Show statistics by protocol
netstat -s
```

---

## ping & traceroute

```bash
# Basic ping (4 packets)
ping -c 4 google.com

# Ping with specific interval (0.2s)
ping -i 0.2 -c 20 8.8.8.8

# Set packet size
ping -s 1472 8.8.8.8         # Max size for 1500 MTU path

# Flood ping (requires root)
sudo ping -f -c 1000 192.168.1.1

# Ping IPv6
ping6 -c 4 2001:4860:4860::8888

# Traceroute (uses UDP by default)
traceroute google.com

# Traceroute using ICMP (like Windows tracert)
traceroute -I google.com

# Traceroute using TCP (bypass firewalls)
traceroute -T -p 443 google.com

# mtr — combined ping + traceroute
mtr google.com

# mtr in report mode (non-interactive)
mtr --report -c 10 google.com

# mtr with TCP
mtr --tcp --port 443 google.com
```

---

## DNS Tools

### dig

```bash
# Basic DNS lookup (A record)
dig google.com

# Short answer only
dig +short google.com

# Lookup specific record types
dig google.com A
dig google.com AAAA          # IPv6
dig google.com MX            # Mail servers
dig google.com TXT           # Text records (SPF, DKIM)
dig google.com NS            # Name servers
dig google.com SOA           # Start of Authority
dig google.com CNAME         # Canonical name
dig google.com ANY           # All records

# Query a specific DNS server
dig @8.8.8.8 google.com
dig @1.1.1.1 google.com +short

# Reverse DNS lookup (PTR record)
dig -x 8.8.8.8
dig -x 8.8.8.8 +short

# Trace DNS resolution path
dig +trace google.com

# DNSSEC verification
dig +dnssec google.com

# Batch lookups from file
dig -f domains.txt +short
```

### nslookup & host

```bash
# Simple lookup with nslookup
nslookup google.com

# Use specific DNS server
nslookup google.com 8.8.8.8

# Reverse lookup
nslookup 8.8.8.8

# host command
host google.com
host google.com 1.1.1.1    # Use specific DNS server
host -t MX google.com      # Specific record type
host -v google.com         # Verbose

# Check /etc/resolv.conf for configured DNS servers
cat /etc/resolv.conf

# Check /etc/nsswitch.conf for name resolution order
cat /etc/nsswitch.conf
```

---

## nmap — Port Scanning

```bash
# Scan a host (ping scan first, then port scan)
nmap 192.168.1.1

# Scan specific ports
nmap -p 80,443,8080 192.168.1.1

# Scan port range
nmap -p 1-1000 192.168.1.1

# Scan all 65535 ports
nmap -p- 192.168.1.1

# Version detection (service/version)
nmap -sV 192.168.1.1

# OS detection (requires root)
sudo nmap -O 192.168.1.1

# Aggressive scan (OS, version, scripts, traceroute)
sudo nmap -A 192.168.1.1

# Stealth SYN scan (requires root)
sudo nmap -sS 192.168.1.1

# UDP scan (requires root, slow)
sudo nmap -sU -p 53,123,161 192.168.1.1

# Scan a subnet
nmap 192.168.1.0/24

# Ping scan (host discovery only, no port scan)
nmap -sn 192.168.1.0/24

# Skip ping, scan even if host seems down
nmap -Pn 192.168.1.1

# Save output to file
nmap -oN scan.txt 192.168.1.1
nmap -oX scan.xml 192.168.1.1    # XML output
```

---

## tcpdump — Packet Capture

```bash
# Capture on all interfaces
sudo tcpdump -i any

# Capture on specific interface
sudo tcpdump -i eth0

# Capture with resolved names disabled (faster)
sudo tcpdump -i eth0 -n

# Verbose output
sudo tcpdump -i eth0 -v
sudo tcpdump -i eth0 -vvv     # Extra verbose

# Capture to a file (pcap format, open in Wireshark)
sudo tcpdump -i eth0 -w capture.pcap

# Read from a capture file
tcpdump -r capture.pcap

# Filter by host
sudo tcpdump -i eth0 host 192.168.1.1

# Filter by port
sudo tcpdump -i eth0 port 80
sudo tcpdump -i eth0 port 80 or port 443

# Filter by protocol
sudo tcpdump -i eth0 icmp
sudo tcpdump -i eth0 tcp
sudo tcpdump -i eth0 udp

# Filter by source or destination
sudo tcpdump -i eth0 src 192.168.1.1
sudo tcpdump -i eth0 dst 8.8.8.8

# Complex filter (BPF syntax)
sudo tcpdump -i eth0 'tcp port 80 and host 192.168.1.1'

# Show packet contents in hex and ASCII
sudo tcpdump -i eth0 -XX port 80

# Limit capture to N packets
sudo tcpdump -i eth0 -c 100

# Capture HTTP requests (look for GET/POST)
sudo tcpdump -i eth0 -A -s 0 'tcp port 80' | grep -E 'GET|POST|Host'
```

---

## nc (netcat) — Network Swiss Army Knife

```bash
# Test if a TCP port is open
nc -zv 192.168.1.1 80
nc -zv google.com 443

# Test multiple ports
nc -zv 192.168.1.1 80 443 8080

# Test a range of ports
nc -zv 192.168.1.1 20-25

# Test UDP port
nc -zuv 192.168.1.1 53

# Set connection timeout
nc -zv -w3 192.168.1.1 80

# Listen on a port (simple server)
nc -l -p 8080

# Connect to a listening server
nc 192.168.1.1 8080

# Transfer a file over network
# On receiver:
nc -l -p 9999 > received_file.txt
# On sender:
nc 192.168.1.1 9999 < file_to_send.txt

# Simple HTTP request
echo -e "GET / HTTP/1.0\r\nHost: google.com\r\n\r\n" | nc google.com 80

# Chat between two machines
# Machine A: nc -l -p 1234
# Machine B: nc 192.168.1.10 1234
```

---

## curl & wget

### curl

```bash
# Basic GET request
curl https://example.com

# Show response headers only
curl -I https://example.com

# Show both headers and body
curl -i https://example.com

# Follow redirects
curl -L https://example.com

# Download a file
curl -O https://example.com/file.zip
curl -o myfile.zip https://example.com/file.zip

# Send POST request with JSON
curl -X POST https://api.example.com/data \
  -H "Content-Type: application/json" \
  -d '{"key": "value"}'

# POST with form data
curl -X POST https://example.com/form \
  -d "username=user&password=pass"

# Add authentication header
curl -H "Authorization: Bearer TOKEN" https://api.example.com

# Basic auth
curl -u username:password https://api.example.com

# Verbose output (shows TLS handshake, headers)
curl -v https://example.com

# Test connection speed
curl -o /dev/null -w "%{time_total}\n" https://example.com

# Upload a file (multipart form)
curl -F "file=@/path/to/file.txt" https://example.com/upload

# Use a proxy
curl -x http://proxy:3128 https://example.com

# Ignore SSL certificate errors (insecure)
curl -k https://self-signed.example.com
```

### wget

```bash
# Download a file
wget https://example.com/file.zip

# Download with a custom output filename
wget -O myfile.zip https://example.com/file.zip

# Download in the background
wget -b https://example.com/largefile.iso

# Recursive website download
wget -r --no-parent https://example.com/docs/

# Resume an interrupted download
wget -c https://example.com/largefile.iso

# Download with rate limiting
wget --limit-rate=1m https://example.com/file.zip

# Download multiple files from a list
wget -i urls.txt

# Mirror a website
wget --mirror --convert-links --page-requisites https://example.com
```

---

## iptables Basics

```bash
# List current rules
sudo iptables -L -v -n

# Allow incoming SSH
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Allow incoming HTTP/HTTPS
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Drop all other incoming traffic
sudo iptables -A INPUT -j DROP

# See full iptables cheatsheet: iptables.md
```

---

## Network Namespaces

```bash
# List network namespaces
ip netns list

# Create a namespace
sudo ip netns add myns

# Delete a namespace
sudo ip netns del myns

# Run a command inside a namespace
sudo ip netns exec myns ip addr show

# Get a shell inside a namespace
sudo ip netns exec myns bash

# Create a veth pair for namespace communication
sudo ip link add veth0 type veth peer name veth1
sudo ip link set veth1 netns myns

# Configure the namespace-side interface
sudo ip netns exec myns ip addr add 10.0.0.2/24 dev veth1
sudo ip netns exec myns ip link set veth1 up
sudo ip addr add 10.0.0.1/24 dev veth0
sudo ip link set veth0 up
```

---

## Common Troubleshooting

```bash
# Check if a host is reachable
ping -c 3 8.8.8.8

# Check DNS resolution
dig +short google.com @8.8.8.8

# Check if a port is open (local)
ss -tlpn | grep :80

# Check if a port is open (remote)
nc -zv 192.168.1.1 80
nmap -p 80 192.168.1.1

# Trace the path to a host
traceroute 8.8.8.8
mtr --report 8.8.8.8

# Check default gateway
ip route show | grep default
ip route get 8.8.8.8

# Check interface is up and has IP
ip addr show eth0

# Check for duplicate IPs (ARP conflict)
arping -D -c 3 -I eth0 192.168.1.100

# Check MTU issues (fragment-free ping)
ping -c 3 -M do -s 1472 8.8.8.8

# Capture traffic to debug
sudo tcpdump -i eth0 -n host 192.168.1.1

# Check if DNS is working
cat /etc/resolv.conf
resolvectl status
systemd-resolve --status
```

---

## Tips & Tricks

- `ip` replaces `ifconfig`, `route`, `arp`, and `netstat` — prefer it on modern systems
- Use `ss -tulpn | grep LISTEN` to see exactly what's listening and on what process
- `mtr` is superior to both `ping` and `traceroute` for diagnosing network paths — install it first on new servers
- `curl -w "%{time_namelookup} %{time_connect} %{time_starttransfer} %{time_total}"` gives detailed timing breakdown of HTTP requests
- `nc -zv host 1-65535 2>&1 | grep succeeded` scans all ports (slow but useful without nmap)
- `/etc/hosts` takes precedence over DNS — check it when a hostname resolves unexpectedly
- Use `resolvectl query domain.com` on systemd-resolved systems to see full DNS resolution details
- `tcpdump port not 22` captures everything except SSH, preventing flooding your own session
- `iperf3` is the best tool for measuring actual bandwidth between two hosts
- On systemd systems, `networkctl` shows managed interfaces and their status

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
