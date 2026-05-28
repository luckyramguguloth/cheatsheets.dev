# Bash Cheatsheet

> Unix shell and scripting language for command-line automation.
> Last verified: May 2026 | Version: Bash 5.2

---

## Quick Reference

| Command | Description |
|---|---|
| `pwd` | Print working directory |
| `ls -la` | List files with details |
| `cd -` | Switch to previous directory |
| `cp -r src/ dst/` | Copy directory recursively |
| `mv file.txt dir/` | Move or rename file |
| `rm -rf dir/` | Delete directory forcefully |
| `find . -name "*.log"` | Find files by name |
| `grep -r "pattern" .` | Search text recursively |
| `chmod +x script.sh` | Make file executable |
| `cat file | sort | uniq` | Sort and deduplicate lines |
| `tail -f file.log` | Follow file output live |
| `ps aux | grep nginx` | Find running processes |
| `kill -9 <pid>` | Force kill a process |
| `df -h` | Disk usage (human readable) |
| `du -sh *` | Size of items in current dir |
| `curl -O <url>` | Download a file |
| `tar -xzf file.tar.gz` | Extract gzip tarball |
| `echo $?` | Show last exit code |
| `!!` | Repeat last command |
| `Ctrl+R` | Reverse search command history |

---

## Navigation

```bash
# Print current directory
pwd

# Change directory
cd /path/to/dir
cd ~                    # home directory
cd -                    # previous directory
cd ..                   # parent directory
cd ../..                # two levels up

# List files
ls                      # basic
ls -l                   # long format
ls -la                  # include hidden files
ls -lh                  # human-readable sizes
ls -lt                  # sort by modification time
ls -lS                  # sort by file size
ls *.txt                # glob filter

# Directory shortcuts
dirs                    # show directory stack
pushd /path             # push to stack and cd
popd                    # pop from stack and cd
```

---

## File Operations

```bash
# Create files
touch file.txt
touch file1.txt file2.txt
> file.txt              # create empty or truncate

# Copy files
cp file.txt copy.txt
cp -r src/ dst/         # recursive (directories)
cp -p file.txt dst/     # preserve permissions/timestamps
cp -u src/ dst/         # only if source is newer

# Move/rename
mv file.txt renamed.txt
mv file.txt /other/dir/
mv -i file.txt dst/     # prompt before overwrite

# Delete
rm file.txt
rm -f file.txt          # force (no prompt)
rm -r directory/        # recursive
rm -rf directory/       # force recursive (careful!)

# Create directories
mkdir newdir
mkdir -p path/to/nested/dir   # create parents if needed

# Remove empty directory
rmdir emptydir

# Symbolic links
ln -s target linkname
ls -la                  # see -> target in output
unlink linkname         # remove symlink

# File permissions
chmod 755 file.sh       # rwxr-xr-x
chmod +x script.sh      # add execute bit
chmod -w file.txt       # remove write bit
chmod u+x,g-w file      # user add exec, group remove write
chown user:group file   # change owner
chown -R user:group dir # recursive
```

---

## Viewing Files

```bash
# View file content
cat file.txt
cat -n file.txt         # with line numbers
less file.txt           # paginated (q to quit)
more file.txt           # older paginator

# View parts of a file
head file.txt           # first 10 lines
head -n 20 file.txt     # first 20 lines
tail file.txt           # last 10 lines
tail -n 50 file.txt     # last 50 lines
tail -f file.log        # follow file in real-time
tail -F file.log        # follow even if file rotates

# Line count, word count, byte count
wc file.txt             # lines words bytes
wc -l file.txt          # lines only
wc -w file.txt          # words only

# Compare files
diff file1.txt file2.txt
diff -u file1.txt file2.txt    # unified format
diff -r dir1/ dir2/            # compare directories
```

---

## Text Processing

### grep

```bash
# Search for pattern in file
grep "error" file.log
grep -i "error" file.log         # case insensitive
grep -n "error" file.log         # show line numbers
grep -r "TODO" ./src             # recursive search
grep -l "pattern" *.txt          # show only filenames
grep -c "error" file.log         # count matches
grep -v "debug" file.log         # invert (exclude matches)
grep -E "error|warn" file.log    # extended regex (OR)
grep -A 3 "error" file.log       # 3 lines after match
grep -B 2 "error" file.log       # 2 lines before match
grep -C 2 "error" file.log       # 2 lines before AND after
```

### sed

```bash
# Replace text in file (print result)
sed 's/old/new/' file.txt        # first occurrence per line
sed 's/old/new/g' file.txt       # all occurrences
sed 's/old/new/gi' file.txt      # case insensitive + all

# Edit file in place
sed -i 's/old/new/g' file.txt
sed -i.bak 's/old/new/g' file.txt   # with backup

# Delete lines
sed '/pattern/d' file.txt        # delete matching lines
sed '2,5d' file.txt              # delete lines 2-5
sed '$d' file.txt                # delete last line

# Print specific lines
sed -n '5,10p' file.txt          # print lines 5-10
sed -n '/start/,/end/p' file.txt # print between patterns
```

### awk

```bash
# Print specific columns
awk '{print $1}' file.txt        # first column
awk '{print $1, $3}' file.txt    # columns 1 and 3
awk '{print NR": "$0}' file.txt  # prefix with line number

# Filter rows
awk '/pattern/ {print}' file.txt
awk '$3 > 100 {print $1}' file.txt   # numeric filter

# Field separator
awk -F: '{print $1}' /etc/passwd     # colon-separated
awk -F, '{print $2}' data.csv        # CSV

# Sum a column
awk '{sum += $1} END {print sum}' file.txt

# Print with formatting
awk '{printf "%-20s %s\n", $1, $2}' file.txt
```

### sort & uniq

```bash
sort file.txt               # alphabetical sort
sort -r file.txt            # reverse
sort -n file.txt            # numeric sort
sort -k2 file.txt           # sort by 2nd column
sort -t, -k2 file.csv       # CSV, sort by 2nd field
sort -u file.txt            # sort and remove duplicates

uniq file.txt               # remove adjacent duplicates
uniq -c file.txt            # count occurrences
uniq -d file.txt            # only show duplicates
uniq -u file.txt            # only unique lines

# Common pattern: sort | uniq -c | sort -rn
# (most frequent items first)
cat file.txt | sort | uniq -c | sort -rn
```

### cut & paste

```bash
cut -d: -f1 /etc/passwd     # first field, colon delimiter
cut -d, -f2,4 file.csv      # fields 2 and 4
cut -c1-10 file.txt         # first 10 characters

paste file1.txt file2.txt   # merge files side by side
paste -d, file1 file2       # with comma delimiter
```

---

## Variables

```bash
# Assign variables (no spaces around =)
name="Alice"
count=42
pi=3.14

# Use variables
echo $name
echo ${name}            # curly braces (safer)
echo "Hello, ${name}!"

# Default values
echo ${var:-"default"}           # use default if unset
echo ${var:="default"}           # set and use default if unset
echo ${var:?"error message"}     # error if unset

# String manipulation
str="Hello, World"
echo ${#str}            # length: 13
echo ${str:0:5}         # substring: Hello
echo ${str/World/Bash}  # replace first: Hello, Bash
echo ${str//o/0}        # replace all: Hell0, W0rld
echo ${str^^}           # uppercase: HELLO, WORLD
echo ${str,,}           # lowercase: hello, world

# Arithmetic
result=$((10 + 5 * 2))
echo $result             # 20
((count++))              # increment
((count += 5))           # add 5

# Command substitution
files=$(ls *.txt)
today=$(date +%Y-%m-%d)
echo "Today is $today"

# Read-only variables
readonly PI=3.14159

# Unset variable
unset name

# Environment variables
export MY_VAR="value"    # make available to child processes
echo $HOME $USER $PATH $SHELL $PWD
printenv                 # list all environment variables
```

---

## Arrays

```bash
# Declare and initialize
fruits=("apple" "banana" "cherry")
declare -a nums=(1 2 3 4 5)

# Access elements
echo ${fruits[0]}        # apple (0-indexed)
echo ${fruits[-1]}       # last element: cherry
echo ${fruits[@]}        # all elements
echo ${#fruits[@]}       # array length: 3

# Modify array
fruits[1]="blueberry"    # replace element
fruits+=("date")         # append element

# Slice
echo ${fruits[@]:1:2}    # elements 1 and 2

# Iterate
for fruit in "${fruits[@]}"; do
    echo "$fruit"
done

# Associative array (dictionary)
declare -A person
person["name"]="Alice"
person["age"]=30
echo ${person["name"]}
echo ${!person[@]}       # all keys
echo ${person[@]}        # all values

# Delete element
unset fruits[1]
unset fruits             # delete whole array
```

---

## Conditionals

```bash
# Basic if-else
if [ condition ]; then
    echo "true"
elif [ other ]; then
    echo "other"
else
    echo "false"
fi

# File tests
if [ -f file.txt ]; then echo "is a file"; fi
if [ -d /path ]; then echo "is a directory"; fi
if [ -e file ]; then echo "exists"; fi
if [ -r file ]; then echo "readable"; fi
if [ -w file ]; then echo "writable"; fi
if [ -x file ]; then echo "executable"; fi
if [ -s file ]; then echo "non-empty"; fi
if [ -L link ]; then echo "is symlink"; fi

# String tests
if [ -z "$str" ]; then echo "empty"; fi
if [ -n "$str" ]; then echo "non-empty"; fi
if [ "$a" = "$b" ]; then echo "equal"; fi
if [ "$a" != "$b" ]; then echo "not equal"; fi

# Numeric comparisons
if [ $a -eq $b ]; then echo "equal"; fi
if [ $a -ne $b ]; then echo "not equal"; fi
if [ $a -lt $b ]; then echo "less than"; fi
if [ $a -le $b ]; then echo "less or equal"; fi
if [ $a -gt $b ]; then echo "greater than"; fi
if [ $a -ge $b ]; then echo "greater or equal"; fi

# Modern [[ ]] (Bash only, more features)
if [[ "$str" == *"sub"* ]]; then echo "contains"; fi
if [[ "$str" =~ ^[0-9]+$ ]]; then echo "is integer"; fi
if [[ -f file && -r file ]]; then echo "readable file"; fi
if [[ $a -gt 0 || $b -gt 0 ]]; then echo "one positive"; fi

# One-liners
[ -f file.txt ] && echo "exists" || echo "missing"
command && echo "success" || echo "failed"
```

---

## Loops

```bash
# For loop over list
for item in a b c d; do
    echo "$item"
done

# For loop over array
for file in *.txt; do
    echo "Processing $file"
done

# C-style for loop
for ((i=0; i<10; i++)); do
    echo "$i"
done

# For loop with range
for i in {1..10}; do
    echo "$i"
done

for i in {0..20..2}; do    # 0 to 20, step 2
    echo "$i"
done

# While loop
count=0
while [ $count -lt 10 ]; do
    echo "$count"
    ((count++))
done

# Read file line by line
while IFS= read -r line; do
    echo "$line"
done < file.txt

# Until loop
until [ $count -ge 10 ]; do
    ((count++))
done

# Loop control
for i in {1..10}; do
    [ $i -eq 5 ] && continue    # skip 5
    [ $i -eq 8 ] && break       # stop at 8
    echo "$i"
done

# Infinite loop
while true; do
    echo "running..."
    sleep 1
done
```

---

## Functions

```bash
# Define a function
greet() {
    echo "Hello, $1!"
}

# Call function
greet "Alice"

# Function with local variables
calculate() {
    local a=$1
    local b=$2
    local result=$((a + b))
    echo $result
}

# Capture return value
sum=$(calculate 3 4)
echo "Sum is $sum"

# Return status code
check_file() {
    if [ -f "$1" ]; then
        return 0    # success
    else
        return 1    # failure
    fi
}

check_file "myfile.txt" && echo "exists" || echo "missing"

# Functions with all arguments
print_all() {
    echo "All args: $@"
    echo "Count: $#"
    echo "First: $1"
}
```

---

## Pipes & Redirections

```bash
# Redirect output
command > file.txt        # overwrite
command >> file.txt       # append
command 2> errors.txt     # stderr only
command &> all.txt        # stdout + stderr
command > file 2>&1       # stdout + stderr (POSIX)
command 2>/dev/null       # discard stderr

# Redirect input
command < input.txt

# Pipes
ls | grep ".txt"
cat file | sort | uniq | wc -l
ps aux | grep nginx | awk '{print $2}'

# Pipe stderr
command 2>&1 | grep "error"

# tee (pipe AND save to file)
command | tee output.txt
command | tee -a output.txt    # append

# Process substitution
diff <(sort file1) <(sort file2)
while read line; do echo $line; done < <(command)

# Here document
cat <<EOF
Line 1
Line 2
EOF

# Here string
grep "pattern" <<< "some string to search"
```

---

## Process Management

```bash
# List processes
ps aux                   # all processes (BSD style)
ps -ef                   # all processes (UNIX style)
ps aux | grep nginx

# Real-time process monitor
top
htop                     # enhanced (if installed)

# Find process ID
pgrep nginx
pidof nginx

# Kill processes
kill PID                 # send SIGTERM (graceful)
kill -9 PID             # send SIGKILL (force)
kill -HUP PID           # reload config
killall nginx           # kill by name
pkill -f "python script" # kill by pattern

# Background/foreground
command &               # run in background
jobs                    # list background jobs
fg %1                   # bring job 1 to foreground
bg %1                   # resume job 1 in background
Ctrl+Z                  # suspend foreground process

# nohup (keep running after logout)
nohup command &
nohup command > output.log 2>&1 &

# Check resource usage
lsof -p PID             # files opened by process
strace -p PID           # system calls (Linux)

# Sleep
sleep 5                 # wait 5 seconds
sleep 0.5               # wait 500ms
```

---

## Job Control & History

```bash
# History
history                  # show all history
history 20               # last 20 commands
!42                      # run command #42
!!                       # run last command
!grep                    # run last grep command
!$                       # last argument of last command
!*                       # all arguments of last command

# Reverse search
Ctrl+R                   # reverse history search
Ctrl+R again             # cycle through matches
Ctrl+G                   # cancel search

# History manipulation
HISTSIZE=10000           # set history size
HISTFILESIZE=20000       # file size
HISTCONTROL=ignoredups   # ignore duplicate entries
history -c               # clear history
history -w               # write to file

# Keyboard shortcuts
Ctrl+A                   # move to beginning of line
Ctrl+E                   # move to end of line
Ctrl+K                   # cut from cursor to end
Ctrl+U                   # cut from start to cursor
Ctrl+W                   # cut last word
Ctrl+Y                   # paste (yank) cut text
Ctrl+L                   # clear screen
Alt+F                    # move forward one word
Alt+B                    # move back one word
```

---

## Script Essentials

```bash
#!/usr/bin/env bash
# Always use this shebang line

# Strict mode (recommended for scripts)
set -euo pipefail
# -e: exit on error
# -u: treat unset variables as errors
# -o pipefail: pipe fails if any command fails

# Script arguments
echo "Script name: $0"
echo "First arg: $1"
echo "All args: $@"
echo "Arg count: $#"
echo "Exit status of last command: $?"
echo "PID of current script: $$"

# Error handling
trap 'echo "Error on line $LINENO"' ERR
trap 'cleanup' EXIT

cleanup() {
    echo "Cleaning up..."
    rm -f /tmp/tempfile
}

# Debug mode
set -x     # print each command before executing
set +x     # turn off debug

# Check if script has required argument
if [ $# -lt 1 ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

# Check if command exists
if ! command -v docker &>/dev/null; then
    echo "Docker is not installed"
    exit 1
fi
```

---

## Tips & Tricks

- Use `set -euo pipefail` at the top of every script to catch errors early.
- Quote variables: `"$var"` not `$var` — prevents word splitting and glob expansion.
- Use `$(command)` over backticks `` `command` `` — it nests and is more readable.
- `ctrl+R` then type to search history; press `ctrl+R` again to cycle matches.
- `!!:gs/old/new` — run last command with substitution.
- `mkdir -p && cd $_` — `$_` expands to the last argument of the previous command.
- Use `readlink -f $0` inside a script to get the script's own directory.
- `command -v program` returns 0 if installed — preferred over `which`.
- `2>/dev/null` silences error output; `>/dev/null 2>&1` silences everything.
- `exec > >(tee -a logfile.log) 2>&1` — log all script output to a file.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
