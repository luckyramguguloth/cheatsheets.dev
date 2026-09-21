# High Availability & Clustering Cheatsheet

> Production guide for Keepalived Virtual IP (VIP), HAProxy layer 4/7 load balancing, Corosync/Pacemaker clustering, and split-brain recovery.
> Last verified: May 2026 | Version: HAProxy 2.9+ / Keepalived 2.2+ / Pacemaker 2.1+

---

## Quick Reference

| Component | Tool / Daemon | Primary Purpose |
|---|---|---|
| Virtual IP (VIP) Failover | Keepalived (VRRP) | Floating IP failover between active/passive nodes |
| L4/L7 Reverse Proxy & Load Balancer | HAProxy | SSL termination, TCP load balancing, health checking |
| Multi-Node Cluster Resource Manager | Corosync + Pacemaker | Fencing (STONITH), stateful service orchestration |
| Cluster Status Check | `crm_mon -1` / `pcs status` | Pacemaker cluster state overview |
| HAProxy Config Test | `haproxy -c -f /etc/haproxy/haproxy.cfg` | Validate config syntax before reloading |

---

## Keepalived VRRP Virtual IP Configuration

`/etc/keepalived/keepalived.conf` on Primary Node (Master):
```ini
vrrp_script check_haproxy {
    script "killall -0 haproxy"
    interval 2
    weight 2
}

vrrp_instance VI_1 {
    state MASTER
    interface eth0
    virtual_router_id 51
    priority 101
    advert_int 1

    authentication {
        auth_type PASS
        auth_pass SecretClusterPass789
    }

    virtual_ipaddress {
        192.168.1.100/24 dev eth0
    }

    track_script {
        check_haproxy
    }
}
```

Allow binding to floating IP before it's assigned locally:
```bash
echo "net.ipv4.ip_nonlocal_bind = 1" | sudo tee /etc/sysctl.d/99-vip.conf
sudo sysctl --system
```

---

## HAProxy High-Performance Layer 7 Reverse Proxy

`/etc/haproxy/haproxy.cfg`:
```haproxy
global
    log /dev/log local0
    maxconn 50000
    daemon

defaults
    log global
    mode http
    option httplog
    option dontlognull
    timeout connect 5000ms
    timeout client 50000ms
    timeout server 50000ms

frontend http_front
    bind 192.168.1.100:80
    bind 192.168.1.100:443 ssl crt /etc/ssl/certs/site.pem
    http-request redirect scheme https unless { ssl_fc }
    default_backend web_servers

backend web_servers
    balance roundrobin
    option httpchk GET /health
    http-check expect status 200
    default-server inter 3s fall 3 rise 2
    server web01 192.168.1.101:8080 check
    server web02 192.168.1.102:8080 check
    server web03 192.168.1.103:8080 check backup
```

---

## Pacemaker & Corosync High Availability Commands

```bash
# Check cluster state
sudo pcs status

# Put node into standby for maintenance (gracefully migrates resources)
sudo pcs node standby node2

# Bring node back to active cluster
sudo pcs node unstandby node2

# Re-enable resource after failure recovery
sudo pcs resource cleanup my_database_service
```

---

## Split-Brain Diagnosis & Recovery

### 1. Both Keepalived Nodes Claim the Virtual IP (IP Conflict)
- **Root Causes:** Firewall blocking VRRP protocol (IP protocol 112) or mismatched `virtual_router_id` or `auth_pass`.
- **Diagnosis:**
  ```bash
  # Check if VRRP packets are arriving on the network interface:
  sudo tcpdump -i eth0 proto 112
  ```
- **Recovery:** Allow VRRP traffic through firewall:
  ```bash
  # UFW / iptables
  sudo iptables -I INPUT -p vrrp -j ACCEPT
  sudo iptables -I INPUT -d 224.0.0.18 -j ACCEPT
  ```

### 2. Pacemaker Node Fencing Loop (STONITH Reboots)
- **Diagnosis:** Quorum loss caused nodes to repeatedly shoot each other.
- **Recovery:**
  ```bash
  # Temporarily disable STONITH to break reboot loop during maintenance
  sudo pcs property set stonith-enabled=false
  # Resolve network partition, then re-enable:
  sudo pcs property set stonith-enabled=true
  ```

---

## Tips & Tricks

- **Zero-downtime HAProxy reload:** Use `sudo systemctl reload haproxy` which initiates a graceful reload via seamless socket transfer (`-x /var/run/haproxy.sock`), maintaining existing active TCP streams.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
