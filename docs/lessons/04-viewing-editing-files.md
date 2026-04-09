# Lesson 04 — Viewing & Editing Files

> **Goal:** Read file contents, search inside files, and edit files using terminal editors.

---

## Viewing File Contents

### `cat` — Display Entire File

```bash
cat practice/welcome.txt

# Show line numbers
cat -n practice/sample.log

# Show multiple files concatenated
cat practice/welcome.txt practice/fruits.txt
```

**Best for:** Small files. For large files, use `less`.

### `less` — Scrollable File Viewer

```bash
less practice/sample.log
```

**Navigation inside `less`:**

| Key | Action |
| --- | ------ |
| **Space** / **Page Down** | Next page |
| **b** / **Page Up** | Previous page |
| **j** / **↓** | Down one line |
| **k** / **↑** | Up one line |
| **g** | Go to beginning |
| **G** | Go to end |
| **/pattern** | Search forward |
| **?pattern** | Search backward |
| **n** | Next search result |
| **N** | Previous search result |
| **q** | Quit |

### `head` — Show First Lines

```bash
head practice/sample.log          # First 10 lines (default)
head -n 3 practice/sample.log    # First 3 lines
head -n 1 practice/fruits.txt    # Just the first line
```

### `tail` — Show Last Lines

```bash
tail practice/sample.log          # Last 10 lines (default)
tail -n 3 practice/sample.log    # Last 3 lines
tail -f /var/log/syslog           # Follow — live updates (Ctrl+C to stop)
```

> `tail -f` is extremely useful for monitoring log files in real time.

### `wc` — Word Count

```bash
wc practice/fruits.txt            # Lines, words, characters
wc -l practice/fruits.txt        # Lines only
wc -w practice/fruits.txt        # Words only
wc -c practice/fruits.txt        # Characters (bytes) only
```

---

## Searching Inside Files

### `grep` — Search for Patterns

`grep` is one of the most powerful tools in Linux.

```bash
# Basic search
grep "ERROR" practice/sample.log

# Case-insensitive
grep -i "error" practice/sample.log

# Show line numbers
grep -n "ERROR" practice/sample.log

# Count matches
grep -c "ERROR" practice/sample.log

# Invert — show lines that DO NOT match
grep -v "INFO" practice/sample.log

# Search recursively in a directory
grep -r "Hello" ~/practice/

# Show context (2 lines before and after)
grep -B 2 -A 2 "ERROR" practice/sample.log

# Use regex patterns
grep -E "ERROR|WARN" practice/sample.log
```

**Useful `grep` combos:**

```bash
# Search for a word in all .txt files
grep "apple" ~/practice/*.txt

# Combine with other commands using pipes
cat practice/sample.log | grep "ERROR"
history | grep "ls"
```

---

## Pipes & Redirection

### Pipes (`|`) — Send Output to Another Command

```bash
# Count how many files are in /etc
ls /etc | wc -l

# Find errors in your log and count them
grep "ERROR" practice/sample.log | wc -l

# Sort the fruits list
cat practice/fruits.txt | sort

# Sort in reverse
cat practice/fruits.txt | sort -r

# Remove duplicates
echo -e "apple\napple\nbanana\napple" | sort | uniq

# Get unique entries with count
echo -e "apple\napple\nbanana\napple" | sort | uniq -c
```

### Redirection

```bash
# Save command output to a file (overwrite)
ls -la /etc > etc-listing.txt

# Append to a file
date >> etc-listing.txt

# Redirect errors to a file
ls /nonexistent 2> errors.txt

# Redirect both output and errors
ls /etc /nonexistent > output.txt 2>&1

# Discard output
ls /etc > /dev/null

# Discard errors
ls /nonexistent 2> /dev/null
```

---

## Sorting & Text Processing

### `sort` — Sort Lines

```bash
sort practice/fruits.txt          # Alphabetical
sort -r practice/fruits.txt       # Reverse
sort -n numbers.txt               # Numeric sort
```

### `uniq` — Remove Adjacent Duplicates

```bash
# Must sort first to group duplicates together
sort practice/fruits.txt | uniq
sort practice/fruits.txt | uniq -c   # Count occurrences
```

### `cut` — Extract Columns

```bash
# Extract the first field (colon-separated)
cut -d: -f1 /etc/passwd

# Extract fields 1 and 3
cut -d: -f1,3 /etc/passwd

# Extract characters 1-8
cut -c1-8 /etc/passwd
```

### `tr` — Translate/Replace Characters

```bash
echo "hello world" | tr 'a-z' 'A-Z'    # Uppercase
echo "hello   world" | tr -s ' '       # Squeeze repeated spaces
```

---

## Editing Files

### `nano` — Beginner-Friendly Editor

```bash
nano myfile.txt
```

**Nano shortcuts** (shown at bottom of screen):

| Shortcut | Action |
| -------- | ------ |
| **Ctrl + O** | Save (Write Out) |
| **Ctrl + X** | Exit |
| **Ctrl + K** | Cut line |
| **Ctrl + U** | Paste line |
| **Ctrl + W** | Search |
| **Ctrl + \\** | Search and replace |
| **Alt + U** | Undo |
| **Ctrl + G** | Help |

**Practice with nano:**

```bash
# Create and edit a file
nano ~/practice/mynotes.txt

# Type some text, save with Ctrl+O (Enter to confirm), exit with Ctrl+X
```

### `vim` — Powerful Advanced Editor

Vim has **modes**:

| Mode | Purpose | How to enter |
| ---- | ------- | ------------ |
| **Normal** | Navigate and command | Press `Esc` |
| **Insert** | Type text | Press `i` |
| **Command** | Run commands | Press `:` (from Normal mode) |

```bash
vim myfile.txt
```

**Essential Vim commands:**

| Command | Mode | Action |
| ------- | ---- | ------ |
| `i` | Normal → Insert | Start typing before cursor |
| `a` | Normal → Insert | Start typing after cursor |
| `Esc` | Any → Normal | Return to Normal mode |
| `:w` | Command | Save |
| `:q` | Command | Quit |
| `:wq` or `:x` | Command | Save and quit |
| `:q!` | Command | Quit without saving |
| `dd` | Normal | Delete current line |
| `yy` | Normal | Copy (yank) current line |
| `p` | Normal | Paste below |
| `u` | Normal | Undo |
| `/text` | Normal | Search for "text" |
| `n` | Normal | Next search result |

**Survival guide:** If you're stuck in Vim, press `Esc` then type `:q!` and Enter to force-quit.

---

## Hands-On Exercises

### Exercise 1: View Files

```bash
cd ~/practice

# View the full sample log
cat sample.log

# View with line numbers (-n = number every line)
cat -n sample.log

# View just the first 3 lines (-n 3 = how many lines from the top)
head -n 3 sample.log

# View the last 2 lines (-n 2 = how many lines from the bottom)
tail -n 2 sample.log

# Scroll through with less (press q to quit)
less sample.log
```

### Exercise 2: Search with `grep`

```bash
cd ~/practice

# Find all ERROR lines
grep "ERROR" sample.log

# Find all non-INFO lines (-v = invert, show lines that do NOT match)
grep -v "INFO" sample.log

# Count ERROR lines (-c = count matching lines instead of printing them)
grep -c "ERROR" sample.log

# Search for fruits containing 'a'
grep "a" fruits.txt

# Case-insensitive search (-i = ignore uppercase vs lowercase)
grep -i "APPLE" fruits.txt
```

### Exercise 3: Pipes in Action

```bash
# How many lines in sample.log? (wc -l = count lines only)
wc -l ~/practice/sample.log

# Sort fruits alphabetically, then reversed (-r = reverse order)
sort ~/practice/fruits.txt
sort -r ~/practice/fruits.txt

# Get the first 3 fruits alphabetically (-n 3 = first 3 lines)
sort ~/practice/fruits.txt | head -n 3

# List all users on the system
# cut: -d: = use colon as delimiter, -f1 = first field (username)
cut -d: -f1 /etc/passwd | sort
```

### Exercise 4: Redirection

```bash
# Save the sorted fruit list (> overwrites the file)
sort ~/practice/fruits.txt > ~/practice/sorted-fruits.txt
cat ~/practice/sorted-fruits.txt

# Save error search results
grep "ERROR" ~/practice/sample.log > ~/practice/errors-only.txt
cat ~/practice/errors-only.txt

# Count entries and append to a summary
echo "Error count:" > ~/practice/summary.txt
# grep -c = count matching lines; >> appends to the file
grep -c "ERROR" ~/practice/sample.log >> ~/practice/summary.txt
cat ~/practice/summary.txt
```

### Exercise 5: Edit with nano

```bash
# Open nano and create a file
nano ~/practice/my-notes.txt

# 1. Type: "Things I learned today:"
# 2. Press Enter and add a few items
# 3. Save: Ctrl+O, Enter
# 4. Exit: Ctrl+X

# Verify
cat ~/practice/my-notes.txt
```

---

## Challenge

Using the `sample.log` file in your practice directory:

1. Count how many `INFO` lines there are
2. Count how many `ERROR` lines there are
3. Extract only unique log levels (INFO, WARN, ERROR) and count each
4. Save all results to `~/practice/log-report.txt`

<!-- markdownlint-disable MD033 -->
<details>
<summary>💡 Solution</summary>

```bash
cd ~/practice

# Counts
echo "=== Log Report ===" > log-report.txt
echo "INFO count: $(grep -c 'INFO' sample.log)" >> log-report.txt
echo "ERROR count: $(grep -c 'ERROR' sample.log)" >> log-report.txt
echo "WARN count: $(grep -c 'WARN' sample.log)" >> log-report.txt

echo "" >> log-report.txt
echo "=== Level Summary ===" >> log-report.txt
grep -oE "INFO|WARN|ERROR" sample.log | sort | uniq -c >> log-report.txt

cat log-report.txt
```

</details>
<!-- markdownlint-enable MD033 -->

---

**[← Lesson 03](03-files-and-directories.md)** | **[Lesson 05 →](05-permissions-ownership.md)**
