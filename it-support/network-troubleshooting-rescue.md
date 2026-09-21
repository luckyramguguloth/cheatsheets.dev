# Network Troubleshooting & Emergency Rescue Cheatsheet

> Diagnostic commands, packet captures, MTU mismatch diagnosis, DHCP exhaustion, DNS debugging, and routing recovery.
> Last verified: May 2026 | Version: Linux / Windows / Cross-Platform

---

## Quick Reference

| Task | Linux Command | Windows Command |
|---|---|---|
| Display IP & Interfaces | `ip -br a` | `ipconfig /all` |
| Display Routing Table | `ip route show` | `route print` |
| Test Path & Latency (MTR) | `mtr -rw 1.1.1.1` | `pathping 1.1.1.1` |
| View Active Listening Sockets | `ss -tulpn` | `netstat -ano \| findstr LISTENING` |
| Query DNS Record | `dig +trace example.com` | `nslookup -type=any example.com` |
| Packet Capture | `tcpdump -nnvv -i any port 53` | `pktmon start --etw -p 0` |
| Test Port Reachability | `nc -zv 192.168.1.1 443` | `Test-NetConnection -Port 443 192.168.1.1` |

---

## Diagnosing Packet Loss & High Latency (MTR / Traceroute)

```bash
# Run 100 packets per hop with report mode
mtr -r -c 100 8.8.8.8

# Interpret MTR output:
# Loss% on intermediate hops that disappears in later hops = ICMP rate limiting (Harmless).
# Loss% that persists through all subsequent hops = Real physical link congestion or fault.
```

---

## MTU Mismatch & Path MTU Discovery (PMTUD) Blackhole

Symptoms: Ping works, SSH connects, but HTTPS web pages or git pulls freeze indefinitely.
```bash
# Test exact MTU threshold using Don't Fragment (DF) bit ping
# Linux:
ping -M do -s 1472 -c 3 8.8.8.8
# (1472 payload + 28 bytes IP/ICMP header = 1500 MTU)

# Windows:
ping -f -l 1472 8.8.8.8

# If packets drop with "Frag needed and DF set":
# Lower MTU on interface temporarily:
sudo ip link set dev eth0 mtu 1400
```

---

## TCPDump Deep Packet Inspection One-Liners

```bash
# Capture DHCP traffic (Discover, Offer, Request, Ack)
sudo tcpdump -i any -nnve port 67 or port 68

# Capture DNS requests and responses with query name
sudo tcpdump -i any -nn "udp port 53" -s 0 -A

# Detect TCP Reset (RST) packets sent during sudden connection drops
sudo tcpdump -i any "tcp[tcpflags] & (tcp-rst) != 0"

# Write capture to pcap file for Wireshark inspection
sudo tcpdump -i eth0 -w /tmp/capture.pcap -C 50 -W 5
```

---

## Troubleshooting & Emergency Recovery

### 1. DHCP Pool Exhaustion (Rogue Devices / Lease Starvation)
- **Diagnosis:** New hosts assign APIPA (`169.254.x.x`) address.
- **Recovery:**
  - Reduce lease duration on router/DHCP server from 7 days to 4 hours.
  - Flush inactive leases on Linux ISC-DHCP / Kea:
    ```bash
    sudo systemctl restart isc-dhcp-server
    ```

### 2. DNS Poisoning or Corrupted Resolver Cache
```bash
# Linux (systemd-resolved):
sudo resolvectl flush-caches
sudo resolvectl statistics

# Windows:
ipconfig /flushdns
```

---

## Tips & Tricks

- **Test-NetConnection in PowerShell:** Use `Test-NetConnection -ComputerName api.github.com -Port 443 -TraceRoute` for an all-in-one DNS, TCP handshake, and hop latency diagnostic.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
