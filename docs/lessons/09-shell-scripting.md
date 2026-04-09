# Lesson 09 — Shell Scripting

> **Goal:** Write Bash scripts to automate tasks — variables, conditionals, loops, and functions.

---

## Your First Script

A Bash script is a text file containing commands that are executed in sequence.

### Create and Run a Script

```bash
nano ~/practice/hello.sh
```

```bash
#!/bin/bash
# My first script
echo "Hello, Linux world!"
echo "Today is $(date)"
echo "You are: $(whoami)"
```

```bash
chmod +x ~/practice/hello.sh    # +x = add execute permission
~/practice/hello.sh
```

**The `#!/bin/bash` line** (called a "shebang") tells Linux which interpreter to use.

---

## Variables

### Defining Variables

```bash
# No spaces around the = sign!
name="Linux"
version=24
greeting="Hello from $name"

echo $name
echo $version
echo $greeting
```

**Rules:**

- No spaces around `=`
- Use quotes for strings with spaces: `message="Hello World"`
- Access with `$variable` or `${variable}`

### Special Variables

| Variable | Meaning |
| -------- | ------- |
| `$0` | Script name |
| `$1`, `$2`, ... | Positional arguments |
| `$#` | Number of arguments |
| `$@` | All arguments (as separate strings) |
| `$*` | All arguments (as one string) |
| `$?` | Exit status of last command (0=success) |
| `$$` | Current script's PID |

```bash
#!/bin/bash
echo "Script name: $0"
echo "First argument: $1"
echo "Second argument: $2"
echo "Total arguments: $#"
echo "All arguments: $@"
```

### User Input

```bash
#!/bin/bash
read -p "What is your name? " username    # -p = display a prompt before reading
echo "Hello, $username!"
```

### Command Substitution

```bash
current_date=$(date)
file_count=$(ls | wc -l)            # wc -l = count lines (one per file)
my_ip=$(hostname -I)                # -I = show all IP addresses

echo "Date: $current_date"
echo "Files here: $file_count"
echo "My IP: $my_ip"
```

---

## Conditionals

### `if` / `elif` / `else`

```bash
#!/bin/bash
age=25

if [ $age -lt 18 ]; then
    echo "Minor"
elif [ $age -lt 65 ]; then
    echo "Adult"
else
    echo "Senior"
fi
```

### Comparison Operators

**Numbers:**

| Operator | Meaning |
| -------- | ------- |
| `-eq` | Equal |
| `-ne` | Not equal |
| `-lt` | Less than |
| `-le` | Less than or equal |
| `-gt` | Greater than |
| `-ge` | Greater than or equal |

**Strings:**

| Operator | Meaning |
| -------- | ------- |
| `=` or `==` | Equal |
| `!=` | Not equal |
| `-z` | Empty string |
| `-n` | Non-empty string |

**Files:**

| Operator | Meaning |
| -------- | ------- |
| `-f` | Is a regular file |
| `-d` | Is a directory |
| `-e` | Exists (file or directory) |
| `-r` | Is readable |
| `-w` | Is writable |
| `-x` | Is executable |
| `-s` | Is non-empty |

### Examples

```bash
#!/bin/bash

# Check if a file exists
if [ -f "/etc/passwd" ]; then
    echo "/etc/passwd exists"
fi

# Check if a directory exists
if [ -d "$HOME/practice" ]; then
    echo "Practice directory exists"
fi

# String comparison
read -p "Enter a fruit: " fruit
if [ "$fruit" = "apple" ]; then
    echo "You chose apple!"
elif [ "$fruit" = "banana" ]; then
    echo "You chose banana!"
else
    echo "Unknown fruit: $fruit"
fi

# Check if an argument was provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi
```

### Using `[[ ]]` (Bash-specific, more powerful)

```bash
# Pattern matching
if [[ "$name" == J* ]]; then
    echo "Name starts with J"
fi

# Regex matching
if [[ "$email" =~ ^[a-zA-Z]+@[a-zA-Z]+\.[a-zA-Z]+$ ]]; then
    echo "Valid email format"
fi

# Logical operators
if [[ $age -gt 18 && $age -lt 65 ]]; then
    echo "Working age"
fi
```

---

## Loops

### `for` Loop

```bash
#!/bin/bash

# Loop through a list
for fruit in apple banana cherry; do
    echo "I like $fruit"
done

# Loop through files
for file in ~/practice/*.txt; do
    echo "File: $file ($(wc -l < "$file") lines)"    # wc -l = count lines
done

# C-style for loop
for ((i=1; i<=5; i++)); do
    echo "Count: $i"
done

# Loop through command output
# cut: -d: = colon delimiter, -f1 = first field (username)
for user in $(cut -d: -f1 /etc/passwd); do
    echo "User: $user"
done

# Loop through a range
for i in {1..10}; do
    echo "Number: $i"
done
```

### `while` Loop

```bash
#!/bin/bash

# Count to 5
count=1
while [ $count -le 5 ]; do
    echo "Count: $count"
    ((count++))
done

# Read a file line by line
# IFS= preserves leading/trailing whitespace; -r prevents backslash escaping
while IFS= read -r line; do
    echo "Line: $line"
done < ~/practice/fruits.txt

# Infinite loop (Ctrl+C to stop)
while true; do
    echo "$(date): Still running..."
    sleep 2
done
```

### `until` Loop

```bash
#!/bin/bash

count=1
until [ $count -gt 5 ]; do
    echo "Count: $count"
    ((count++))
done
```

### Loop Control

```bash
# break — exit the loop
for i in {1..10}; do
    if [ $i -eq 5 ]; then
        break
    fi
    echo $i
done

# continue — skip to next iteration
for i in {1..10}; do
    if [ $((i % 2)) -eq 0 ]; then
        continue
    fi
    echo "$i is odd"
done
```

---

## Functions

```bash
#!/bin/bash

# Define a function
greet() {
    echo "Hello, $1!"
}

# Call it
greet "Linux"
greet "World"

# Function with return value
is_even() {
    if [ $(($1 % 2)) -eq 0 ]; then
        return 0    # Success (true)
    else
        return 1    # Failure (false)
    fi
}

if is_even 4; then
    echo "4 is even"
fi

# Function that outputs a value
get_disk_usage() {
    # df -h = disk free in human-readable format
    # tail -1 = last line only
    # awk '{print $5}' = print the 5th column (usage percentage)
    df -h / | tail -1 | awk '{print $5}'
}

usage=$(get_disk_usage)
echo "Disk usage: $usage"
```

### Local Variables

```bash
my_function() {
    local my_var="I'm local"
    echo $my_var
}

my_function
echo $my_var    # Empty — it's local to the function
```

---

## Practical Scripts

### Script 1: File Backup

```bash
#!/bin/bash
# backup.sh — Create a timestamped backup of a directory

if [ $# -ne 1 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

source_dir="$1"
if [ ! -d "$source_dir" ]; then
    echo "Error: $source_dir is not a directory"
    exit 1
fi

timestamp=$(date +%Y%m%d_%H%M%S)    # date format: Year Month Day _ Hour Minute Second
backup_name="backup_${timestamp}.tar.gz"

# tar: -c = create, -z = compress with gzip, -f = output filename
tar -czf "$backup_name" "$source_dir"
echo "Backup created: $backup_name"
# du: -h = human-readable size; cut -f1 = first field (the size)
echo "Size: $(du -h "$backup_name" | cut -f1)"
```

### Script 2: System Info Report

```bash
#!/bin/bash
# sysinfo.sh — Display a system information summary

echo "==============================="
echo "   System Information Report"
echo "==============================="
echo ""
echo "Hostname: $(hostname)"
echo "User:     $(whoami)"
echo "Date:     $(date)"
echo "Uptime:  $(uptime -p)"    # -p = pretty/human-readable format
echo ""
echo "--- Memory ---"
free -h | grep Mem              # free -h = human-readable; grep Mem = show only the memory line
echo ""
echo "--- Disk Usage ---"
df -h / | tail -1               # df -h = human-readable; tail -1 = last line (skips header)
echo ""
echo "--- Top 5 Processes (by CPU) ---"
# ps aux = all processes; --sort=-%cpu = sort by CPU descending; head -6 = header + 5 rows
ps aux --sort=-%cpu | head -6
```

### Script 3: Log Analyzer

```bash
#!/bin/bash
# loganalyzer.sh — Analyze a log file

if [ $# -ne 1 ]; then
    echo "Usage: $0 <logfile>"
    exit 1
fi

logfile="$1"
if [ ! -f "$logfile" ]; then
    echo "Error: $logfile not found"
    exit 1
fi

echo "=== Log Analysis: $logfile ==="
echo "Total lines: $(wc -l < "$logfile")"
echo ""

for level in INFO WARN ERROR; do
    count=$(grep -c "$level" "$logfile")
    echo "$level: $count occurrences"
done
```

---

## Hands-On Exercises

### Exercise 1: Basic Script

```bash
cat > ~/practice/greet.sh << 'EOF'
#!/bin/bash
if [ $# -eq 0 ]; then
    read -p "Enter your name: " name
else
    name="$1"
fi

echo "Hello, $name! Welcome to Linux."
echo "The time is $(date +%H:%M)"
EOF

chmod +x ~/practice/greet.sh
~/practice/greet.sh
~/practice/greet.sh "World"
```

### Exercise 2: Loop Practice

```bash
cat > ~/practice/countdown.sh << 'EOF'
#!/bin/bash
echo "Countdown!"
for i in {10..1}; do
    echo "$i..."
    sleep 0.5
done
echo "🚀 Liftoff!"
EOF

chmod +x ~/practice/countdown.sh
~/practice/countdown.sh
```

### Exercise 3: File Processor

```bash
cat > ~/practice/fileinfo.sh << 'EOF'
#!/bin/bash
echo "Files in current directory:"
echo "=========================="

for file in *; do
    if [ -f "$file" ]; then
        size=$(du -h "$file" | cut -f1)
        lines=$(wc -l < "$file" 2>/dev/null || echo "N/A")
        echo "📄 $file — Size: $size, Lines: $lines"
    elif [ -d "$file" ]; then
        echo "📁 $file/"
    fi
done
EOF

chmod +x ~/practice/fileinfo.sh
cd ~/practice && ./fileinfo.sh
```

### Exercise 4: Use the System Info Script

```bash
cat > ~/practice/sysinfo.sh << 'EOF'
#!/bin/bash
echo "==============================="
echo "   System Information Report"
echo "==============================="
echo ""
echo "Hostname: $(hostname)"
echo "User:     $(whoami)"
echo "Date:     $(date)"
echo ""
echo "--- Memory ---"
free -h | grep Mem
echo ""
echo "--- Disk Usage ---"
df -h /
echo ""
echo "--- Processes ---"
echo "Total: $(ps aux | wc -l)"
EOF

chmod +x ~/practice/sysinfo.sh
~/practice/sysinfo.sh
```

### Exercise 5: Log Analyzer

```bash
cat > ~/practice/analyze.sh << 'EOF'
#!/bin/bash
logfile="${1:-$HOME/practice/sample.log}"

if [ ! -f "$logfile" ]; then
    echo "Log file not found: $logfile"
    exit 1
fi

echo "Analyzing: $logfile"
echo "---"
echo "Total lines: $(wc -l < "$logfile")"

for level in INFO WARN ERROR; do
    count=$(grep -c "$level" "$logfile" 2>/dev/null)
    echo "$level: $count"
done
EOF

chmod +x ~/practice/analyze.sh
~/practice/analyze.sh
```

---

## Challenge

Write a script called `organizer.sh` that:

1. Takes a directory as an argument (default: current directory)
2. Creates subdirectories: `text/`, `scripts/`, `data/`, `other/`
3. Moves files based on extension:
   - `.txt`, `.md` → `text/`
   - `.sh` → `scripts/`
   - `.csv`, `.json`, `.log` → `data/`
   - Everything else → `other/`
4. Prints a summary of how many files were moved to each folder

<!-- markdownlint-disable MD033 -->
<details>
<summary>💡 Solution</summary>

```bash
cat > ~/practice/organizer.sh << 'SCRIPT'
#!/bin/bash
dir="${1:-.}"
cd "$dir" || exit 1

# Create target directories
mkdir -p text scripts data other

# Counters
text_count=0
script_count=0
data_count=0
other_count=0

for file in *; do
    [ -f "$file" ] || continue
    [ "$file" = "organizer.sh" ] && continue

    case "$file" in
        *.txt|*.md)
            mv "$file" text/ && ((text_count++))
            ;;
        *.sh)
            mv "$file" scripts/ && ((script_count++))
            ;;
        *.csv|*.json|*.log)
            mv "$file" data/ && ((data_count++))
            ;;
        *)
            mv "$file" other/ && ((other_count++))
            ;;
    esac
done

echo "=== Organization Summary ==="
echo "Text files:   $text_count"
echo "Scripts:      $script_count"
echo "Data files:   $data_count"
echo "Other files:  $other_count"
echo "Total moved:  $((text_count + script_count + data_count + other_count))"
SCRIPT

chmod +x ~/practice/organizer.sh
```

</details>
<!-- markdownlint-enable MD033 -->

---

**[← Lesson 08](08-networking-basics.md)** | **[Lesson 10 →](10-system-administration.md)**
