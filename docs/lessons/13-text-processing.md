# Lesson 13 — Text Processing

> **Goal:** Master the core text-processing tools that make Linux powerful for data manipulation.

---

## Why Text Processing Matters

In Linux, almost everything is a text file — configuration, logs, data, command output. Being able to slice, transform, and analyze text from the command line is one of the most valuable skills you can have.

---

## `cut` — Extract Columns

`cut` pulls specific fields or characters from each line.

### By Delimiter and Field

```bash
# /etc/passwd uses : as delimiter
# Extract just usernames (field 1):
cut -d: -f1 /etc/passwd

# Extract username and shell (fields 1 and 7):
cut -d: -f1,7 /etc/passwd

# Extract fields 1 through 3:
cut -d: -f1-3 /etc/passwd
```

### By Character Position

```bash
# First 10 characters of each line
cut -c1-10 practice/sample.log

# Characters 1 through 5
echo "Hello World" | cut -c1-5
```

| Flag | Meaning |
| ---- | ------- |
| `-d` | Set the delimiter (default: Tab) |
| `-f` | Select fields (columns) |
| `-c` | Select character positions |

---

## `sort` — Sort Lines

```bash
# Alphabetical sort
sort practice/fruits.txt

# Reverse sort
sort -r practice/fruits.txt

# Numeric sort
echo -e "10\n2\n33\n1\n5" | sort -n

# Sort by a specific column (e.g., column 5 of ls -l)
# -k5 = sort by 5th field, -n = numeric order
ls -l /etc | sort -k5 -n

# Sort and remove duplicates (-u = unique, discard duplicate lines)
sort -u practice/fruits.txt
```

| Flag | Meaning |
| ---- | ------- |
| `-n` | Numeric sort (2 before 10) |
| `-r` | Reverse order |
| `-k N` | Sort by column N |
| `-t` | Set field separator |
| `-u` | Unique (remove duplicates) |
| `-h` | Human-numeric sort (1K, 2M, 3G) |

---

## `uniq` — Remove Duplicate Lines

`uniq` only removes **adjacent** duplicates, so always `sort` first:

```bash
# Remove duplicates
sort practice/fruits.txt | uniq

# Count occurrences
sort practice/fruits.txt | uniq -c

# Show only duplicated lines
sort practice/fruits.txt | uniq -d

# Show only unique lines (appear exactly once)
sort practice/fruits.txt | uniq -u
```

---

## `tr` — Translate or Delete Characters

`tr` works on characters, not lines or words.

```bash
# Convert lowercase to uppercase
echo "hello world" | tr 'a-z' 'A-Z'

# Replace spaces with newlines (one word per line)
echo "one two three" | tr ' ' '\n'

# Delete specific characters
echo "Hello 123 World" | tr -d '0-9'

# Squeeze repeated characters
echo "too    many    spaces" | tr -s ' '

# Replace multiple characters
echo "hello.world.txt" | tr '.' '-'
```

| Flag | Meaning |
| ---- | ------- |
| `-d` | Delete characters |
| `-s` | Squeeze repeats into one |
| `-c` | Complement (invert the character set) |

---

## `sed` — Stream Editor

`sed` is a powerful tool for finding and replacing text in a stream.

### Basic Substitution

```bash
# Replace first occurrence on each line
echo "hello world hello" | sed 's/hello/goodbye/'

# Replace ALL occurrences on each line (g flag)
echo "hello world hello" | sed 's/hello/goodbye/g'

# Case-insensitive replace
echo "Hello HELLO hello" | sed 's/hello/goodbye/gi'
```

### Working with Files

```bash
# Replace text and print to stdout (does not modify the file)
sed 's/ERROR/CRITICAL/' practice/sample.log

# Edit a file in place
sed -i 's/ERROR/CRITICAL/' practice/sample.log

# Create a backup before editing
sed -i.bak 's/ERROR/CRITICAL/' practice/sample.log
```

### Addressing — Apply to Specific Lines

```bash
# Only line 3
sed '3s/old/new/' file.txt

# Lines 2 through 5
sed '2,5s/old/new/' file.txt

# Lines matching a pattern
sed '/ERROR/s/old/new/' file.txt

# Delete lines
sed '3d' file.txt             # Delete line 3
sed '/ERROR/d' file.txt       # Delete lines containing ERROR
sed '1,3d' file.txt           # Delete lines 1-3

# Insert and append
sed '2i\New line above line 2' file.txt
sed '2a\New line below line 2' file.txt
```

### Multiple Operations

```bash
# Chain with -e (-e = add a script/expression)
sed -e 's/ERROR/CRITICAL/' -e 's/WARN/NOTICE/' practice/sample.log

# Or use semicolons
sed 's/ERROR/CRITICAL/; s/WARN/NOTICE/' practice/sample.log
```

### Common `sed` Recipes

```bash
# Remove blank lines (^$ = empty line, d = delete)
sed '/^$/d' file.txt

# Remove leading whitespace (^[[:space:]]* = spaces/tabs at start of line)
sed 's/^[[:space:]]*//' file.txt

# Remove trailing whitespace ([[:space:]]*$ = spaces/tabs at end of line)
sed 's/[[:space:]]*$//' file.txt

# Print only lines 5-10 (-n = suppress auto-print, p = print matched lines)
sed -n '5,10p' file.txt

# Add a prefix to every line (^ = start of line)
sed 's/^/PREFIX: /' file.txt
```

---

## `awk` — Pattern Scanning and Processing

`awk` is a full programming language for text processing. It processes input line by line, splitting each into fields.

### Fields

By default, `awk` splits each line on whitespace:

```bash
# Print the first field (column)
echo "Alice 30 Engineer" | awk '{print $1}'
# Alice

# Print the third field
echo "Alice 30 Engineer" | awk '{print $3}'
# Engineer

# $0 is the entire line
echo "Alice 30 Engineer" | awk '{print $0}'

# NF is the number of fields
echo "Alice 30 Engineer" | awk '{print NF}'
# 3

# $NF is the last field
echo "Alice 30 Engineer" | awk '{print $NF}'
# Engineer
```

### Custom Delimiters

```bash
# Use : as the field separator (-F: = set field separator to colon)
awk -F: '{print $1, $7}' /etc/passwd

# Output with a custom separator
awk -F: '{print $1 " -> " $7}' /etc/passwd

# Set output field separator
# BEGIN runs once before processing; OFS = Output Field Separator
awk -F: 'BEGIN {OFS="\t"} {print $1, $7}' /etc/passwd
```

### Patterns and Conditions

```bash
# Only print lines matching a pattern
awk '/ERROR/' practice/sample.log

# Only if field 1 equals something
awk -F: '$1 == "root"' /etc/passwd

# Numeric comparison — users with UID > 1000
awk -F: '$3 > 1000 {print $1, $3}' /etc/passwd

# Combine conditions
awk -F: '$3 >= 1000 && $7 ~ /bash/' /etc/passwd
```

### Built-in Variables

| Variable | Meaning |
| -------- | ------- |
| `$0` | The entire current line |
| `$1`, `$2`, ... | Individual fields |
| `NR` | Current line number |
| `NF` | Number of fields on current line |
| `FS` | Field separator (input) |
| `OFS` | Output field separator |
| `RS` | Record separator (default: newline) |

```bash
# Print line numbers
awk '{print NR, $0}' practice/fruits.txt

# Print only even lines
awk 'NR % 2 == 0' practice/fruits.txt
```

### BEGIN and END Blocks

```bash
# Print a header and footer
awk 'BEGIN {print "=== Fruits ==="} {print "- " $0} END {print "Total: " NR}' practice/fruits.txt

# Sum a column of numbers
echo -e "10\n20\n30" | awk '{sum += $1} END {print "Total:", sum}'

# Average
echo -e "10\n20\n30" | awk '{sum += $1; count++} END {print "Avg:", sum/count}'
```

### Common `awk` One-Liners

```bash
# Count lines containing ERROR
awk '/ERROR/ {count++} END {print count}' practice/sample.log

# Print unique values in a column
awk -F: '{print $7}' /etc/passwd | sort -u

# Print lines longer than 40 characters
awk 'length > 40' /etc/passwd

# Swap first two fields
echo "hello world" | awk '{print $2, $1}'

# Print the last field of each line
awk '{print $NF}' file.txt
```

---

## Combining Tools

The real power is chaining these together:

```bash
# Top 5 shells used on the system, with counts
# cut: -d: = colon delimiter, -f7 = 7th field (shell)
# sort = alphabetical; uniq -c = count occurrences
# sort: -r = reverse, -n = numeric
# head -5 = first 5 results
cat /etc/passwd | cut -d: -f7 | sort | uniq -c | sort -rn | head -5

# Extract IPs from a log and show the most frequent
# awk '{print $1}' = print first field (the IP address)
awk '{print $1}' access.log | sort | uniq -c | sort -rn | head -10

# Convert a CSV to a nicely formatted table
# tr ',' '\t' = replace commas with tabs; column -t = align into columns
cat data.csv | tr ',' '\t' | column -t

# Find all unique error messages in a log
# grep = find lines with ERROR; sed = remove everything before the message
# sort -u = sort and deduplicate in one step
grep "ERROR" practice/sample.log | sed 's/.*ERROR: //' | sort -u
```

---

## Exercises

1. Use `cut` to extract just the usernames and home directories (fields 1 and 6) from `/etc/passwd`.
2. Create a file with 10 lines of random numbers (`echo $RANDOM` in a loop) and sort them numerically.
3. Use `tr` to convert the contents of `practice/welcome.txt` to all uppercase.
4. Use `sed` to replace every occurrence of "INFO" with "INFORMATION" in `practice/sample.log` (without modifying the original file).
5. Use `awk` to print only the lines from `/etc/passwd` where the shell (field 7) is `/bin/bash`.
6. Build a pipeline to count how many unique shells are listed in `/etc/passwd`.

---

## Challenge

Create a script `~/practice/log-analyzer.sh` that takes a log file as an argument and produces a report showing:

1. Total number of lines
2. Count of each log level (INFO, WARN, ERROR)
3. The most common message for each log level
4. A formatted summary table

<!-- markdownlint-disable MD033 -->
<details>
<summary>💡 Solution</summary>

```bash
cat > ~/practice/log-analyzer.sh << 'SCRIPT'
#!/bin/bash

file="${1:-practice/sample.log}"

if [ ! -f "$file" ]; then
    echo "File not found: $file"
    exit 1
fi

total=$(wc -l < "$file")
info=$(grep -c "INFO" "$file")
warn=$(grep -c "WARN" "$file")
error=$(grep -c "ERROR" "$file")

echo "==============================="
echo "  Log Analysis Report"
echo "  File: $file"
echo "==============================="
echo ""
printf "%-10s %s\n" "Level" "Count"
printf "%-10s %s\n" "-----" "-----"
printf "%-10s %s\n" "INFO" "$info"
printf "%-10s %s\n" "WARN" "$warn"
printf "%-10s %s\n" "ERROR" "$error"
printf "%-10s %s\n" "-----" "-----"
printf "%-10s %s\n" "TOTAL" "$total"
echo ""

echo "Most common messages:"
for level in INFO WARN ERROR; do
    msg=$(grep "$level" "$file" | sed "s/.*${level}: //" | sort | uniq -c | sort -rn | head -1)
    if [ -n "$msg" ]; then
        echo "  $level: $msg"
    fi
done
SCRIPT

chmod +x ~/practice/log-analyzer.sh
~/practice/log-analyzer.sh
```

</details>
<!-- markdownlint-enable MD033 -->

---

**[← Lesson 12](12-io-redirection-pipes.md)** | **[Lesson 14 →](14-regular-expressions.md)**
