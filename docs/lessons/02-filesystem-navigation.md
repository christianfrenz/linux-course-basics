# Lesson 02 — Navigating the Filesystem

> **Goal:** Understand the Linux directory tree and move around confidently.

---

## The Linux Directory Tree

Linux organizes everything in a single tree starting from **`/`** (root). There are no drive letters (C:\, D:\) like Windows.

```text
/                   ← Root of the entire filesystem
├── home/           ← User home directories
│   └── student/    ← Your home directory (~)
├── etc/            ← System configuration files
├── var/            ← Variable data (logs, mail, spool)
├── tmp/            ← Temporary files (cleared on reboot)
├── usr/            ← User programs and utilities
│   ├── bin/        ← User commands
│   └── lib/        ← Libraries
├── bin/            ← Essential system commands
├── sbin/           ← System admin commands
├── dev/            ← Device files
├── proc/           ← Virtual filesystem (process info)
├── opt/            ← Optional/third-party software
└── root/           ← Root user's home directory
```

---

## Absolute vs. Relative Paths

| Type | Starts with | Example | Meaning |
| ---- | ----------- | ------- | ------- |
| Absolute | `/` | `/home/student/practice` | Full path from root |
| Relative | anything else | `practice` or `./practice` | Relative to current directory |

Special path symbols:

- **`.`** — Current directory
- **`..`** — Parent directory (one level up)
- **`~`** — Home directory (`/home/student`)
- **`-`** — Previous directory

---

## Key Commands

### `pwd` — Print Working Directory

Shows where you are right now.

```bash
pwd
```

Output: `/home/student`

### `ls` — List Directory Contents

```bash
ls                # List current directory
ls /etc           # List a specific directory
ls -l             # Long format (permissions, size, date)
ls -a             # Show hidden files (starting with .)
ls -la            # Combine: long + hidden
ls -lh            # Human-readable sizes (KB, MB, GB)
ls -lt            # Sort by modification time (newest first)
ls -lS            # Sort by size (largest first)
ls -R             # Recursive — list subdirectories too
```

**Understanding `ls -l` output:**

```text
-rw-r--r-- 1 student student  26 Mar  4 10:00 welcome.txt
│          │ │       │        │   │            │
│          │ owner   group   size  date       filename
│          link count
permissions
```

### `cd` — Change Directory

```bash
cd /etc              # Go to /etc (absolute path)
cd practice          # Go into the practice folder (relative)
cd ..                # Go up one level
cd ../..             # Go up two levels
cd ~                 # Go to home directory
cd                   # Also goes to home directory (shortcut)
cd -                 # Go back to the previous directory
```

### `tree` — Visual Directory Tree

```bash
tree                     # Tree of current directory
tree /home/student       # Tree of a specific directory
tree -L 2                # Limit depth to 2 levels
tree -d                  # Show directories only
tree -a                  # Include hidden files
```

### `file` — Determine File Type

```bash
file practice/welcome.txt
file practice/hello.sh
file /bin/bash
```

---

## Hands-On Exercises

### Exercise 1: Explore the Filesystem

```bash
# Start from home
cd ~
pwd

# Go to the root directory
cd /
ls
pwd

# Explore important directories
ls /home
ls /etc
ls /var/log
ls /tmp
```

### Exercise 2: Practice Navigation

```bash
# Go home
cd ~

# Enter the practice folder
cd practice
pwd
ls -la    # -l = long format, -a = include hidden files

# Go back up
cd ..
pwd

# Go into practice using absolute path
cd /home/student/practice
pwd

# Go home using shortcut
cd
pwd
```

### Exercise 3: Use `ls` Options

```bash
cd ~

# Basic listing
ls

# See hidden files (-a = show files starting with .)
ls -a

# Detailed listing (-l = long format, -a = hidden files)
ls -la

# Human-readable sizes (-l = long, -h = show KB/MB/GB instead of bytes)
ls -lh

# List the practice directory from anywhere
ls -la ~/practice
```

### Exercise 4: Explore with `tree`

```bash
# View your home directory as a tree
tree ~

# Limit to 1 level deep (-L = max depth)
tree -L 1 ~

# Show directories only (-d = directories, skip files)
tree -d /home
```

### Exercise 5: Rapid Navigation with `cd -`

```bash
cd /etc
cd /var/log
cd -          # Jumps back to /etc
cd -          # Jumps back to /var/log
```

---

## Challenge

Starting from your home directory, navigate the filesystem to answer these questions:

1. How many items are in `/etc`?
2. What's inside `/var/log`?
3. Can you find the Bash configuration file in your home directory? (Hint: it's hidden)

<!-- markdownlint-disable MD033 -->
<details>
<summary>💡 Hints</summary>

```bash
# Question 1 — wc -l counts the number of lines in its input
ls /etc | wc -l

# Question 2
ls -la /var/log

# Question 3
ls -la ~
# Look for .bashrc
```

</details>
<!-- markdownlint-enable MD033 -->

---

**[← Lesson 01](01-getting-started.md)** | **[Lesson 03 →](03-files-and-directories.md)**
