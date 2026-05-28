# Linux Commands Cheatsheet

> Essential Linux command-line reference for files, text, network, and system management.
> Last verified: May 2026 | Version: GNU coreutils / Linux kernel 6.x

---

## Quick Reference

| Command | Description |
|---|---|
| `ls -la` | List files with permissions |
| `find . -name "*.log"` | Find files by name |
| `grep -r "pattern" .` | Search text recursively |
| `chmod 755 file` | Set file permissions |
| `chown user:group file` | Change file owner |
| `ps aux` | List running processes |
| `df -h` | Disk usage (human-readable) |
| `du -sh dir/` | Directory size |
| `free -h` | Memory usage |
| `tail -f /var/log/syslog` | Follow log file |

---

## File System Navigation

```bash
# Current directory
pwd

# List files
ls                        # basic
ls -l                     # long format (permissions, size, date)
ls -la                    # include hidden files
ls -lh                    # human-readable sizes
ls -lt                    # sort by modification time (newest first)
ls -lS                    # sort by size (largest first)
ls -R                     # recursive listing
ls -1                     # one file per line
ls --color=auto           # colorized output

# Change directory
cd /path/to/dir
cd ~                      # home directory
cd -                      # previous directory
cd ..                     # parent directory
cd ../..                  # two levels up

# Create directories
mkdir new-dir
mkdir -p path/to/new/dir  # create parents too
mkdir -m 755 new-dir      # with permissions

# Remove
rm file.txt
rm -f file.txt            # force (no prompt)
rm -r dir/                # remove directory recursively
rm -rf dir/               # force recursive (dangerous!)
rmdir empty-dir           # remove empty directory only

# Copy
cp source.txt dest.txt
cp -r src-dir/ dest-dir/  # copy directory
cp -p source dest         # preserve attributes
cp -u source dest         # copy only if newer
cp -v source dest         # verbose

# Move / Rename
mv old.txt new.txt
mv file.txt /path/to/dir/
mv -i source dest         # prompt before overwrite
mv -n source dest         # don't overwrite existing

# Links
ln -s /path/to/target link-name    # symbolic (soft) link
ln /path/to/target hard-link-name  # hard link
readlink -f symlink                 # resolve symlink path
```

---

## File Operations

```bash
# View file contents
cat file.txt                      # print entire file
cat -n file.txt                   # with line numbers
cat file1 file2 > combined.txt    # concatenate

# Pager views
less file.txt                     # scroll (q to quit, /search)
more file.txt                     # scroll forward only

# Head / Tail
head file.txt                     # first 10 lines
head -n 20 file.txt               # first 20 lines
tail file.txt                     # last 10 lines
tail -n 20 file.txt               # last 20 lines
tail -f /var/log/syslog           # follow file (real-time)
tail -F /var/log/app.log          # follow with retry on rotate

# File info
file mystery-file                 # detect file type
stat file.txt                     # detailed file metadata
wc -l file.txt                    # line count
wc -w file.txt                    # word count
wc -c file.txt                    # byte count
du -sh file.txt                   # file size

# Create files
touch newfile.txt                 # create empty / update timestamp
touch -t 202601011200 file.txt    # set specific timestamp
echo "content" > file.txt         # overwrite with content
echo "content" >> file.txt        # append content
printf "line1\nline2\n" > file.txt

# Redirect I/O
command > output.txt              # redirect stdout (overwrite)
command >> output.txt             # redirect stdout (append)
command 2> error.txt              # redirect stderr
command 2>&1                      # redirect stderr to stdout
command &> all.txt                # redirect both to file
command < input.txt               # redirect stdin
command 2>/dev/null               # suppress errors
```

---

## Find

```bash
# Find by name
find . -name "*.log"              # in current dir and below
find /var -name "error.log"       # absolute path
find . -iname "*.LOG"             # case-insensitive
find . -name "*.py" -not -name "*test*"  # exclude pattern

# Find by type
find . -type f                    # files only
find . -type d                    # directories only
find . -type l                    # symbolic links only

# Find by size
find . -size +100M                # larger than 100MB
find . -size -1k                  # smaller than 1KB
find . -size +1M -size -100M      # between 1-100MB

# Find by time
find . -mtime -7                  # modified in last 7 days
find . -mtime +30                 # modified more than 30 days ago
find . -newer reference.txt       # newer than reference file
find . -atime -1                  # accessed in last 24 hours

# Find by permission
find . -perm 644                  # exact permissions
find . -perm -u+x                 # user-executable
find . -perm /o+w                 # other-writable

# Find and execute
find . -name "*.tmp" -delete                          # delete matches
find . -name "*.log" -exec rm {} \;                  # run command on each
find . -name "*.py" -exec grep -l "import os" {} \;  # find python files using os
find . -type f -exec chmod 644 {} \;                 # fix permissions
find . -name "*.sh" -exec chmod +x {} +              # more efficient batch

# Find empty files/dirs
find . -empty -type f             # empty files
find . -empty -type d             # empty directories

# Exclude directories
find . -not -path "./.git/*" -name "*.md"
find . -prune -o -name "*.log" -print    # exclude pruned paths
```

---

## Locate

```bash
# Quick file search (uses database index)
locate filename
locate "*.conf"

# Update the database
sudo updatedb

# Case-insensitive
locate -i filename

# Limit results
locate -n 10 filename

# Count matches
locate -c filename

# Show existing files only
locate -e filename
```

---

## Text Processing

### grep

```bash
# Basic grep
grep "pattern" file.txt
grep -i "pattern" file.txt        # case-insensitive
grep -v "pattern" file.txt        # invert match (lines NOT matching)
grep -r "pattern" directory/      # recursive search
grep -l "pattern" *.txt           # show filenames only
grep -n "pattern" file.txt        # show line numbers
grep -c "pattern" file.txt        # count matching lines
grep -w "word" file.txt           # match whole word
grep -x "exact line" file.txt     # match whole line

# Extended regex
grep -E "pattern1|pattern2" file.txt
grep -E "^start|end$" file.txt

# Context
grep -A 3 "pattern" file.txt      # 3 lines after match
grep -B 3 "pattern" file.txt      # 3 lines before match
grep -C 3 "pattern" file.txt      # 3 lines around match

# Fixed string (no regex)
grep -F "literal.string" file.txt

# Multiple patterns
grep -e "pattern1" -e "pattern2" file.txt

# Recursive with file filter
grep -r --include="*.py" "import" .
grep -r --exclude="*.log" "error" .
grep -r --exclude-dir=".git" "TODO" .
```

### sed

```bash
# Substitute (replace)
sed 's/old/new/' file.txt         # first occurrence per line
sed 's/old/new/g' file.txt        # all occurrences
sed 's/old/new/gi' file.txt       # case-insensitive, all
sed -i 's/old/new/g' file.txt     # in-place edit

# Print specific lines
sed -n '5p' file.txt              # line 5 only
sed -n '1,10p' file.txt           # lines 1-10
sed -n '/start/,/end/p' file.txt  # between patterns

# Delete lines
sed '3d' file.txt                 # delete line 3
sed '/pattern/d' file.txt         # delete matching lines
sed '1,5d' file.txt               # delete lines 1-5

# Insert / append
sed '2i\New line before' file.txt  # insert before line 2
sed '2a\New line after' file.txt   # append after line 2

# Multiple operations
sed -e 's/foo/bar/' -e 's/baz/qux/' file.txt
```

### awk

```bash
# Print specific field (whitespace delimiter)
awk '{print $1}' file.txt         # first field
awk '{print $1, $3}' file.txt     # first and third fields
awk '{print NR, $0}' file.txt     # line number, entire line

# Custom delimiter
awk -F: '{print $1}' /etc/passwd  # colon-delimited
awk -F',' '{print $2}' data.csv   # CSV

# Pattern matching
awk '/pattern/ {print}' file.txt
awk '$3 > 100 {print $1, $3}' file.txt

# Sum a column
awk '{sum += $2} END {print sum}' file.txt

# Count lines
awk 'END {print NR}' file.txt

# Print header and filtered rows
awk 'NR==1 || /pattern/' file.txt
```

### sort & uniq

```bash
# Sort
sort file.txt                     # alphabetical
sort -r file.txt                  # reverse
sort -n file.txt                  # numerical
sort -k2 file.txt                 # sort by 2nd field
sort -t: -k3 -n /etc/passwd       # sort by 3rd colon-field numerically
sort -u file.txt                  # sort and remove duplicates

# Unique
uniq file.txt                     # remove consecutive duplicates (sort first!)
uniq -c file.txt                  # count occurrences
uniq -d file.txt                  # show only duplicates
uniq -u file.txt                  # show only unique lines

# Common pattern: sort then uniq
sort file.txt | uniq -c | sort -rn   # frequency count, sorted
```

### cut, tr, xargs

```bash
# cut — extract fields
cut -d: -f1 /etc/passwd           # first field, colon delimiter
cut -d, -f2,4 data.csv            # fields 2 and 4
cut -c1-10 file.txt               # characters 1-10

# tr — translate/delete characters
tr 'a-z' 'A-Z' < file.txt        # lowercase to uppercase
tr -d '\r' < windows.txt          # remove carriage returns
tr -s ' ' < file.txt              # squeeze multiple spaces

# xargs — build commands from stdin
find . -name "*.log" | xargs rm
find . -name "*.txt" | xargs grep "pattern"
echo "file1 file2" | xargs -n1 touch     # one arg per command
cat urls.txt | xargs -P4 -I{} curl {}    # parallel with 4 workers

# wc
wc -l file.txt                    # line count
wc -w file.txt                    # word count
wc -c file.txt                    # character/byte count
wc file.txt                       # all three
```

---

## Process Management

```bash
# List processes
ps aux                            # all processes, all users
ps aux | grep nginx               # filter by name
ps -ef                            # full format listing
ps -p 1234                        # specific PID
pgrep nginx                       # get PIDs by name
pidof nginx                       # get PID of program

# Interactive process managers
top                               # dynamic process list
htop                              # improved top (if installed)
atop                              # advanced resource monitor

# Kill processes
kill PID                          # send SIGTERM (graceful)
kill -9 PID                       # send SIGKILL (force)
kill -15 PID                      # send SIGTERM explicitly
killall nginx                     # kill by name
pkill -f "python script.py"       # kill by full command match
kill -HUP PID                     # reload (SIGHUP)

# Background / foreground
command &                         # run in background
jobs                              # list background jobs
fg %1                             # bring job 1 to foreground
bg %1                             # send job 1 to background
nohup command &                   # persist after logout
disown %1                         # detach from shell

# Process priority
nice -n 10 command                # start with lower priority
renice 10 -p PID                  # change running process priority
ionice -c 3 command               # idle I/O priority
```

---

## Disk & Storage

```bash
# Disk usage
df -h                             # filesystem usage (human-readable)
df -H                             # SI units (1000 not 1024)
df -T                             # show filesystem type
df -i                             # inode usage

# Directory/file sizes
du -sh dir/                       # summary of directory
du -sh *                          # all items in current dir
du -h --max-depth=1 /var          # one level deep
du -ah /path | sort -rh | head    # largest files/dirs

# Block devices
lsblk                             # list block devices
lsblk -f                          # with filesystems
fdisk -l                          # partition table (root)
blkid                             # block device attributes

# Mount
mount /dev/sdb1 /mnt/usb          # mount device
umount /mnt/usb                    # unmount
mount -a                           # mount all in /etc/fstab
cat /proc/mounts                   # currently mounted

# Disk health
smartctl -a /dev/sda              # SMART status (requires smartmontools)
```

---

## Network Commands

```bash
# IP addresses
ip addr show                      # list all interfaces
ip addr show eth0                 # specific interface
ip a                              # shorthand
ifconfig                          # legacy (may need net-tools)

# Routing
ip route show                     # routing table
ip route add 10.0.0.0/8 via 192.168.1.1   # add route
ip route del 10.0.0.0/8          # delete route
route -n                          # legacy routing table

# Ping
ping hostname                     # continuous ping
ping -c 4 hostname                # 4 packets only
ping -i 0.5 hostname              # 0.5 second interval
ping6 ::1                         # IPv6 ping

# DNS
nslookup example.com              # DNS lookup
dig example.com                   # detailed DNS lookup
dig example.com MX                # MX records
dig @8.8.8.8 example.com         # query specific DNS server
host example.com                  # simple lookup
cat /etc/resolv.conf              # DNS config

# Port scanning and connections
ss -tulpn                         # listening ports (modern)
ss -an                            # all connections
netstat -tulpn                    # legacy listening ports
netstat -an | grep ESTABLISHED    # active connections
lsof -i :80                       # what's using port 80
lsof -i TCP                       # all TCP connections
nmap -sV localhost                 # scan local ports with versions
nc -zv hostname 80                # test if port is open
telnet hostname 80                # legacy port test

# Firewall
ufw status                        # UFW firewall status
ufw allow 80/tcp                  # allow port
ufw deny 22                       # deny port
iptables -L -n -v                 # iptables rules
firewall-cmd --list-all           # firewalld (RHEL/CentOS)

# Transfer
curl -O https://example.com/file  # download file
wget https://example.com/file     # download file
wget -r https://example.com       # recursive download

# Bandwidth monitoring
iftop                             # interface traffic monitor
nethogs                           # per-process bandwidth
```

---

## System Information

```bash
# OS info
uname -a                          # kernel and system info
uname -r                          # kernel version
cat /etc/os-release               # OS distribution info
hostnamectl                       # hostname and OS details
lsb_release -a                    # LSB release info

# Hardware info
lscpu                             # CPU info
lsmem                             # memory info
lspci                             # PCI devices
lsusb                             # USB devices
dmidecode -t system               # DMI/SMBIOS info (root)
inxi -Fxz                         # comprehensive hardware info

# Memory
free -h                           # RAM and swap usage
cat /proc/meminfo                 # detailed memory info
vmstat 1 5                        # memory stats every 1s (5 times)

# System resources
uptime                            # uptime and load average
w                                 # who is logged in, what they're doing
who                               # logged-in users
last                              # login history
dmesg | tail                      # kernel messages
journalctl -xe                    # systemd logs
journalctl -u nginx               # logs for specific service
journalctl -f                     # follow logs
journalctl --since "1 hour ago"   # time-filtered logs
```

---

## Package Managers

### apt (Debian/Ubuntu)

```bash
apt update                        # update package list
apt upgrade                       # upgrade all packages
apt install nginx                 # install package
apt remove nginx                  # remove package
apt purge nginx                   # remove + config files
apt autoremove                    # remove unused dependencies
apt search nginx                  # search packages
apt show nginx                    # show package details
apt list --installed              # list installed packages
dpkg -l                           # list installed (dpkg)
dpkg -l | grep nginx              # check specific package
```

### yum / dnf (RHEL/CentOS/Fedora)

```bash
dnf update                        # update all packages
dnf install nginx                 # install package
dnf remove nginx                  # remove package
dnf search nginx                  # search
dnf info nginx                    # package details
dnf list installed                # list installed
dnf autoremove                    # remove orphans
dnf clean all                     # clean cache

# Legacy yum (RHEL 7 and earlier)
yum install nginx
yum update
yum remove nginx
```

### pacman (Arch Linux)

```bash
pacman -Syu                       # sync and upgrade all
pacman -S nginx                   # install package
pacman -R nginx                   # remove package
pacman -Rs nginx                  # remove with dependencies
pacman -Ss nginx                  # search packages
pacman -Qi nginx                  # package info (installed)
pacman -Si nginx                  # package info (online)
pacman -Q                         # list installed packages
pacman -Qe                        # explicitly installed
pacman -Qdt                       # orphaned packages
```

---

## Compression & Archives

```bash
# tar
tar -czf archive.tar.gz dir/      # create gzip archive
tar -cjf archive.tar.bz2 dir/     # create bzip2 archive
tar -cJf archive.tar.xz dir/      # create xz archive
tar -xzf archive.tar.gz           # extract gzip
tar -xzf archive.tar.gz -C /dest  # extract to directory
tar -tzf archive.tar.gz           # list contents
tar -czf - dir/ | ssh user@host 'cat > archive.tar.gz'  # pipe over SSH

# zip
zip archive.zip file1 file2       # create zip
zip -r archive.zip dir/           # recursive
unzip archive.zip                 # extract
unzip -l archive.zip              # list contents
unzip archive.zip -d /dest        # extract to directory

# gzip / bzip2 / xz (single files)
gzip file.txt                     # compress (replaces file)
gzip -d file.txt.gz               # decompress
gunzip file.txt.gz                # decompress
bzip2 file.txt
bunzip2 file.txt.bz2
xz file.txt
unxz file.txt.xz
```

---

## Tips & Tricks

- Use `!!` to repeat last command; `!$` for last argument of previous command
- `Ctrl+R` for reverse history search
- `Ctrl+L` to clear screen (same as `clear`)
- Use `&&` to chain commands (run if previous succeeds)
- Use `||` as fallback (run if previous fails)
- `command ; command` — run sequentially regardless of exit code
- Pipe `|` chains stdout of one command to stdin of next
- `command > file 2>&1` captures both stdout and stderr
- Use `tee` to write to file and stdout simultaneously: `command | tee output.txt`
- `which command` shows the executable path; `type command` shows all aliases/functions
- `man command` shows the manual; `command --help` for quick help
- Append `alias ll='ls -lah'` to `~/.bashrc` for permanent shortcuts
- Use `history | grep keyword` to find past commands

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
