# grep, awk & sed Cheatsheet

> Linux text processing powertools for searching, transforming, and editing streams.
> Last verified: May 2026 | Version: GNU grep 3.x, gawk 5.x, sed 4.x

---

## Quick Reference

| Command | Description |
|---|---|
| `grep "pattern" file` | Search for pattern in file |
| `grep -r "pattern" dir/` | Recursive search in directory |
| `grep -E "a\|b"` | Extended regex (ERE) |
| `grep -v "pattern"` | Invert match (exclude) |
| `awk '{print $1}' file` | Print first field |
| `awk -F: '{print $1}' /etc/passwd` | Use `:` as delimiter |
| `sed 's/old/new/g' file` | Replace all occurrences |
| `sed -i 's/old/new/g' file` | In-place replace |
| `sed -n '5,10p' file` | Print lines 5–10 |
| `sed '/pattern/d' file` | Delete matching lines |

---

## grep

### Basic Searching

```bash
# Search for a pattern in a file
grep "error" /var/log/syslog

# Case-insensitive search
grep -i "error" /var/log/syslog

# Show line numbers
grep -n "error" /var/log/syslog

# Show only filenames that match (don't show lines)
grep -l "error" /var/log/*.log

# Show only filenames that DON'T match
grep -L "error" /var/log/*.log

# Count matching lines
grep -c "error" /var/log/syslog

# Invert match (show lines NOT matching)
grep -v "debug" /var/log/syslog

# Show context around match
grep -A 3 "error" log.txt     # 3 lines After
grep -B 3 "error" log.txt     # 3 lines Before
grep -C 3 "error" log.txt     # 3 lines Context (before and after)

# Only show the matching part (not the whole line)
grep -o "ERROR:[^$]*" log.txt
```

### Recursive Searching

```bash
# Search recursively in a directory
grep -r "TODO" ./src/

# Recursive, case insensitive
grep -ri "fixme" ./src/

# Recursive but exclude specific directories
grep -r "pattern" ./src/ --exclude-dir=node_modules
grep -r "pattern" ./src/ --exclude-dir={node_modules,.git,dist}

# Recursive, include only specific file types
grep -r "pattern" ./src/ --include="*.py"
grep -r "pattern" ./src/ --include="*.{js,ts}"

# Recursive, show filenames only
grep -rl "pattern" ./src/
```

### Regex Patterns

```bash
# Basic regex (BRE)
grep "^error" file       # Line starts with "error"
grep "error$" file       # Line ends with "error"
grep "err.r" file        # . matches any single character
grep "err*" file         # * matches zero or more of previous char
grep "[Ee]rror" file     # Character class [Ee]

# Extended regex (ERE) — use -E flag
grep -E "error|warning" file      # OR operator
grep -E "err(or)?" file           # Optional group
grep -E "[0-9]{1,3}" file         # 1-3 digits
grep -E "^(ERROR|WARN)" file      # Anchored OR

# Perl-compatible regex (PCRE) — use -P flag
grep -P "\d{4}-\d{2}-\d{2}" file  # Date pattern
grep -P "(?<=ID: )\d+" file       # Lookbehind assertion
grep -P "https?://\S+" file       # URLs
grep -P "\bword\b" file            # Word boundary

# Fixed string (no regex, faster for literal strings)
grep -F "1.2.3.4" access.log      # Literal dot, not regex
```

### Useful Patterns

```bash
# Find lines with IP addresses
grep -E "([0-9]{1,3}\.){3}[0-9]{1,3}" log.txt

# Find lines with email addresses
grep -E "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}" file.txt

# Find empty lines
grep "^$" file.txt

# Find non-empty lines
grep -v "^$" file.txt

# Find lines with only whitespace
grep "^\s*$" file.txt

# Count occurrences of a word (total, not lines)
grep -o "error" log.txt | wc -l

# Find files with a specific extension containing a pattern
grep -rl "console.log" . --include="*.js"

# Search compressed files
zgrep "pattern" file.gz
zcat file.gz | grep "pattern"
```

---

## awk

### Basic Structure

```bash
# awk 'condition { action }' file
# Runs action for each line where condition is true
# If no condition, action runs on every line

# Print the whole line
awk '{print}' file

# Print a specific field (whitespace-delimited by default)
awk '{print $1}' file          # First field
awk '{print $2}' file          # Second field
awk '{print $NF}' file         # Last field
awk '{print $(NF-1)}' file     # Second to last field

# Print multiple fields
awk '{print $1, $3}' file      # Fields 1 and 3, space-separated
awk '{print $1 " " $3}' file   # Same but explicit separator
awk '{print $1 ":" $3}' file   # With colon separator
```

### Field Separators

```bash
# Set field separator with -F
awk -F: '{print $1}' /etc/passwd           # Colon-separated
awk -F, '{print $2}' data.csv             # CSV
awk -F'\t' '{print $3}' data.tsv          # Tab-separated
awk -F'[,;]' '{print $1}' file            # Multiple separators (regex)

# Set separator in BEGIN block
awk 'BEGIN{FS=":"} {print $1}' /etc/passwd

# Set output field separator
awk -F: 'BEGIN{OFS=","} {print $1,$3}' /etc/passwd

# Set output record separator
awk 'BEGIN{ORS=","} {print $1}' file      # Join lines with comma
```

### Built-in Variables

```bash
# NR  — Number of Records (current line number, across all files)
# NF  — Number of Fields in current record
# FS  — Field Separator (default: whitespace)
# OFS — Output Field Separator (default: space)
# ORS — Output Record Separator (default: newline)
# RS  — Record Separator (default: newline)
# FNR — File record Number (line number within current file)
# FILENAME — Current filename

awk '{print NR, $0}' file          # Print line numbers
awk '{print NF, $0}' file          # Print field count per line
awk 'END{print NR}' file           # Count lines (like wc -l)
awk 'NR==5{print}' file            # Print only line 5
awk 'NR>=5 && NR<=10{print}' file  # Print lines 5-10
awk '{print FILENAME, $0}' a.txt b.txt  # Print filename with each line
```

### Patterns and Conditions

```bash
# Pattern: run action only on matching lines
awk '/error/{print}' log.txt               # Lines containing "error"
awk '!/error/{print}' log.txt              # Lines NOT containing "error"
awk '/^ERROR/{print NR, $0}' log.txt       # Lines starting with ERROR

# Comparison conditions
awk '$3 > 1000 {print}' data.txt           # Third field > 1000
awk '$1 == "admin" {print}' users.txt      # First field equals "admin"
awk 'NF > 3 {print}' file                  # Lines with more than 3 fields
awk 'length($0) > 80 {print}' file         # Lines longer than 80 chars

# Range pattern (from /start/ to /end/)
awk '/BEGIN/,/END/{print}' file
```

### BEGIN and END Blocks

```bash
# BEGIN runs before processing any input
# END runs after processing all input

awk 'BEGIN{print "=== Report ==="} {print} END{print "=== Done ==="}' file

# Count with BEGIN and END
awk 'BEGIN{count=0} /error/{count++} END{print "Errors:", count}' log.txt

# Sum a column
awk '{sum+=$3} END{print "Total:", sum}' sales.csv

# Average
awk '{sum+=$1; count++} END{printf "Average: %.2f\n", sum/count}' data.txt

# Print header and formatted output
awk -F: 'BEGIN{printf "%-20s %-10s\n","Username","UID"}
         {printf "%-20s %-10s\n",$1,$3}' /etc/passwd
```

### Common One-Liners

```bash
# Print lines that are duplicated (appear more than once)
awk 'seen[$0]++' file

# Print unique lines (deduplicate preserving order)
awk '!seen[$0]++' file

# Print every other line
awk 'NR%2==1' file                 # Odd lines
awk 'NR%2==0' file                 # Even lines

# Sum a specific column (column 3)
awk '{sum+=$3} END{print sum}' file

# Find max value in column 1
awk 'BEGIN{max=0} $1>max{max=$1} END{print max}' file

# Print lines where field 5 matches pattern
awk '$5 ~ /pattern/' file
awk '$5 !~ /pattern/' file         # Doesn't match

# Delete duplicate whitespace (normalize spacing)
awk '{$1=$1; print}' file

# Reverse the order of fields
awk '{for(i=NF;i>=1;i--) printf "%s%s",$i,(i>1?OFS:ORS)}' file

# Print specific columns from CSV
awk -F',' '{print $1","$4","$7}' data.csv

# Join two files on first field (like SQL JOIN)
awk -F: 'FNR==NR{a[$1]=$2; next} $1 in a{print $0, a[$1]}' file1 file2

# Calculate disk usage in human format
df -h | awk 'NR>1 {print $5, $6}' | sort -rn

# Extract IP addresses from access log and count
awk '{print $1}' access.log | sort | uniq -c | sort -rn | head -20

# Parse /etc/passwd and show username + home directory
awk -F: '$3 >= 1000 {print $1, $6}' /etc/passwd
```

---

## sed

### Substitution

```bash
# Replace first occurrence per line
sed 's/old/new/' file

# Replace ALL occurrences per line (g flag = global)
sed 's/old/new/g' file

# Case-insensitive replace (i flag)
sed 's/old/new/gi' file

# Replace only the Nth occurrence per line
sed 's/old/new/2' file     # Replace 2nd occurrence only

# In-place edit (modify file directly)
sed -i 's/old/new/g' file

# In-place edit with backup (creates file.bak)
sed -i.bak 's/old/new/g' file

# Use different delimiters (useful when pattern contains /)
sed 's|/usr/local|/opt|g' file
sed 's#http://old#http://new#g' file

# Reference matched text with & in replacement
sed 's/[0-9]*/[&]/g' file     # Wrap numbers in brackets

# Capture groups and backreferences
sed 's/\(first\) \(second\)/\2 \1/' file   # Swap two words (BRE)
sed -E 's/(first) (second)/\2 \1/' file    # Same with ERE (-E flag)
```

### Address Ranges (Line Selection)

```bash
# Apply to a specific line number
sed '5s/old/new/' file          # Line 5 only
sed '5,10s/old/new/g' file      # Lines 5 through 10

# Apply to pattern matches
sed '/pattern/s/old/new/g' file

# Apply to range of patterns
sed '/start/,/end/s/old/new/g' file

# Apply to everything EXCEPT a pattern (! = negate)
sed '/pattern/!s/old/new/g' file

# Apply to last line
sed '$s/old/new/' file

# Apply to all lines except first
sed '1!s/old/new/g' file
```

### Printing Lines

```bash
# Print only matching lines (-n suppresses default output)
sed -n '/pattern/p' file

# Print specific line numbers
sed -n '5p' file               # Line 5 only
sed -n '5,10p' file            # Lines 5-10
sed -n '$p' file               # Last line

# Print with line numbers
sed -n '=' file                # Print line numbers only
sed = file | sed 'N;s/\n/\t/' # Line numbers followed by content

# Duplicate each line
sed 'p' file
```

### Deleting Lines

```bash
# Delete lines matching a pattern
sed '/pattern/d' file

# Delete empty lines
sed '/^$/d' file
sed '/^\s*$/d' file    # Lines with only whitespace

# Delete specific line numbers
sed '5d' file          # Delete line 5
sed '5,10d' file       # Delete lines 5-10
sed '$d' file          # Delete last line

# Delete first line (header)
sed '1d' file

# Delete lines NOT matching pattern
sed '/pattern/!d' file  # Keep only matching lines

# Delete lines containing any of multiple patterns
sed '/error\|warning\|debug/d' file
sed -E '/error|warning|debug/d' file
```

### Insertion and Appending

```bash
# Insert a line BEFORE a matching line
sed '/pattern/i\New line before' file
sed -i '/pattern/i\# New comment' config.cfg

# Append a line AFTER a matching line
sed '/pattern/a\New line after' file
sed -i '/\[section\]/a\key=value' config.ini

# Replace the entire matching line
sed 's/.*/new line content/' file    # All lines
sed '/pattern/c\replacement line' file  # Only matching lines

# Insert a line at a specific line number
sed '3i\This is inserted at line 3' file

# Append to end of file
sed -i '$a\Last line appended' file
```

### Multi-line and Advanced

```bash
# Process multiple commands with -e
sed -e 's/foo/bar/g' -e 's/baz/qux/g' file

# Process from a script file
sed -f commands.sed file

# Append next line to pattern space (N command)
sed 'N;s/\n/ /' file           # Join consecutive lines

# Delete trailing whitespace
sed 's/[[:space:]]*$//' file

# Delete leading whitespace
sed 's/^[[:space:]]*//' file

# Delete both leading and trailing whitespace
sed 's/^[[:space:]]*//;s/[[:space:]]*$//' file

# Add a blank line after each line
sed 'G' file

# Number lines (add line number at start)
sed '=' file | sed 'N;s/\n/ /'
```

---

## Combining grep, awk, and sed in Pipelines

```bash
# Find errors, extract timestamp and message
grep "ERROR" app.log | awk '{print $1, $2, $5}'

# Parse Apache access log: get top 10 IPs
awk '{print $1}' access.log | sort | uniq -c | sort -rn | head -10

# Find lines with high response times and format
grep "HTTP" access.log | awk '$NF > 1000 {print $7, $NF}' | sort -k2 -rn

# Remove comments and blank lines from config
grep -v "^#" config.conf | grep -v "^$"
sed '/^#/d;/^$/d' config.conf       # Equivalent with sed

# Extract unique values from a field
awk -F, '{print $3}' data.csv | sort -u

# Replace pattern only in lines matching another pattern
grep -n "error" log.txt | awk -F: '{print $1}' | xargs -I{} sed -i "{}s/error/ERROR/" log.txt

# Count words in a file
awk '{count += NF} END {print count}' file

# Find and replace across multiple files
grep -rl "old_text" ./src/ | xargs sed -i 's/old_text/new_text/g'

# Extract values from JSON-like structure
grep "\"name\":" data.json | sed 's/.*"name": "\([^"]*\)".*/\1/'

# Parse CSV, filter, and reformat
awk -F',' '$4 > 100 {printf "%-20s $%s\n", $1, $4}' sales.csv

# Process log file: count HTTP status codes
awk '{print $9}' access.log | sort | uniq -c | sort -rn

# Extract all unique email addresses from files
grep -roh "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]\{2,\}" . | \
  awk -F: '{print $2}' | sort -u

# Show disk usage, filter mounted drives, sort
df -h | grep -v tmpfs | awk 'NR>1{print $5, $6}' | sort -rn
```

---

## Character Classes

```bash
# POSIX character classes (work in grep, awk, sed)
[[:alpha:]]   # Any letter [a-zA-Z]
[[:digit:]]   # Any digit [0-9]
[[:alnum:]]   # Letters and digits
[[:space:]]   # Whitespace (space, tab, newline)
[[:upper:]]   # Uppercase letters [A-Z]
[[:lower:]]   # Lowercase letters [a-z]
[[:print:]]   # Printable characters
[[:punct:]]   # Punctuation characters

# Examples
grep '[[:digit:]]' file                 # Lines with digits
sed 's/[[:upper:]]/\L&/g' file         # Lowercase all (GNU sed)
awk '/[[:alpha:]]/{print}' file
```

---

## Tips & Tricks

- Use `grep --color=auto` (often set by default in Linux) to highlight matches — very useful when piping
- `grep -P` (PCRE) is the most powerful grep mode; use it for lookaheads, lookbehinds, and `\d`, `\w`, `\s`
- In `awk`, `print` adds a newline; `printf` does not — use `printf` for full format control
- `sed -i''` (BSD/macOS) vs `sed -i` (GNU/Linux) — macOS requires an empty string after `-i`; use `''` for portability
- For complex multi-line text processing, `perl -pe` or `python3 -c` can be cleaner than `sed`
- `awk 'NR==FNR{...;next} {...}' file1 file2` is the idiom for processing two files in awk
- `ripgrep (rg)` is a faster, more user-friendly alternative to grep for large codebases
- Use `grep -F` for literal string matching — much faster than regex for fixed strings
- `sed -n '1~2p'` prints every other line starting from line 1 (GNU sed step syntax)
- Test `sed` and `awk` without `-i` first, then add `-i` when confirmed correct — avoid expensive mistakes

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
