# Ceph Distributed Storage Cheatsheet

> Reference guide for Ceph clusters, OSDs, MONs, CRUSH maps, placement groups (PGs), and disaster recovery during cluster degradation.
> Last verified: May 2026 | Version: Ceph Reef / Squid

---

## Quick Reference

| Task | Command |
|---|---|
| Check Ceph Cluster Health | `ceph health detail` |
| View Cluster Real-time Status | `ceph -s` / `ceph -w` |
| View OSD Status Tree | `ceph osd tree` |
| View Placement Group (PG) States | `ceph pg stat` / `ceph pg dump_stuck` |
| View Pool Utilization | `ceph df` |
| Benchmark Pool Write Throughput | `rados bench -p pool_name 30 write` |

---

## Placement Group (PG) State Diagnostics

PG states in `ceph health detail` explain cluster degradation:

| PG State | Meaning | Action |
|---|---|---|
| **active+clean** | Normal healthy operating state | None |
| **active+degraded** | OSD down; replica missing but accessible | Wait for backfill or replace failed OSD |
| **peering** | OSDs synchronizing state machine | Normal during failover; investigate if stuck > 5 min |
| **undersized** | Fewer replicas exist than pool min_size | Check disk space and offline OSDs |
| **incomplete** | Missing critical peering logs (Data at risk) | Emergency peering recovery |

---

## Emergency OSD Replacement Workflow

```bash
# 1. Identify failing OSD (e.g. osd.14)
ceph osd tree | grep -E "down|out"

# 2. Mark OSD out to begin automatic rebalancing
ceph osd out osd.14

# 3. Stop OSD service on host
sudo systemctl stop ceph-osd@14

# 4. Safely destroy and remove OSD from CRUSH map
ceph osd purge 14 --yes-i-really-mean-it

# 5. Zap physical disk and add new OSD
sudo ceph-volume lvm zap /dev/nvme2n1 --destroy
sudo ceph-volume lvm create --data /dev/nvme2n1
```

---

## Disaster Recovery: Stuck Placement Groups & Cluster Block

### 1. Recovery Blocks Due to Read-Only Safety Threshold (`nearfull` / `full`)
When cluster hits `mon_osd_full_ratio` (default 95%), writes block completely:
```bash
# Temporarily raise full ratio to permit emergency cleanup
ceph osd set-full-ratio 0.97
ceph osd set-nearfull-ratio 0.93

# Delete unneeded images or snapshots to free space
rbd snap rm pool_name/image@old_snap

# Return safety threshold to default immediately after cleanup:
ceph osd set-full-ratio 0.95
```

### 2. OSD Flapping (Crashing repeatedly)
- **Fix:** Pause rebalancing while investigating:
  ```bash
  ceph osd set noout
  ceph osd set nodown
  # ... debug core dumps ...
  # When stabilized:
  ceph osd unset noout
  ceph osd unset nodown
  ```

---

## Tips & Tricks

- **Monitor real-time events:** Run `ceph -w` in a dedicated tmux pane during hardware maintenance to watch live placement group peering and backfilling events.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
