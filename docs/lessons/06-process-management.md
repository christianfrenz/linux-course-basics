# Lesson 06 — Process Management

> **Goal:** Understand processes, monitor system activity, and control running programs.

---

## What is a Process?

A **process** is a running instance of a program. Every command you run creates a process. Each process has:

- **PID** — Process ID (unique number)
- **PPID** — Parent Process ID (who started it)
- **User** — Who owns the process
- **State** — Running, sleeping, stopped, zombie
- **Priority** — How much CPU time it gets

---

## Viewing Processes

### `ps` — Process Snapshot

```bash
# Your processes in the current terminal
ps

# All your processes (-u = filter by user)
ps -u student

# All processes on the system (a = all users, u = user-oriented format, x = include background processes)
ps aux

# Full format with hierarchy (-e = every process, -f = full format)
ps -ef

# Tree view (aux = all processes + user format; f = forest/tree view)
ps auxf
```

**Understanding `ps aux` columns:**

```text
USER   PID %CPU %MEM    VSZ   RSS TTY  STAT START   TIME COMMAND
root     1  0.0  0.1   4628  3400 pts/0 Ss  10:00  0:00 /bin/bash
```

| Column | Meaning |
| ------ | ------- |
| USER | Process owner |
| PID | Process ID |
| %CPU | CPU usage percentage |
| %MEM | Memory usage percentage |
| STAT | Process state (S=sleeping, R=running, Z=zombie) |
| COMMAND | The command that started it |

### `top` — Live Process Monitor

```bash
top
```

**Inside `top`:**

| Key | Action |
| --- | ------ |
| **q** | Quit |
| **k** | Kill a process (enter PID) |
| **M** | Sort by memory |
| **P** | Sort by CPU |
| **u** | Filter by user |
| **1** | Show individual CPU cores |
| **h** | Help |

### `htop` — Better `top` (Installed in Lab)

```bash
htop
```

`htop` provides a colorful, interactive interface. Use arrow keys and F-keys:

| Key | Action |
| --- | ------ |
| **F3** or **/** | Search |
| **F4** | Filter |
| **F5** | Tree view |
| **F6** | Sort by column |
| **F9** | Kill process |
| **F10** / **q** | Quit |

---

## Process States

| State | Symbol | Meaning |
| ----- | ------ | ------- |
| Running | `R` | Currently executing on CPU |
| Sleeping | `S` | Waiting for an event (normal) |
| Stopped | `T` | Paused (e.g., Ctrl+Z) |
| Zombie | `Z` | Finished but parent hasn't collected exit status |
| Dead | `X` | Being removed |

---

## Background & Foreground Jobs

### Running Commands in the Background

```bash
# Add & to run in background
sleep 100 &

# See background jobs
jobs

# Job output shows:
# [1]+  Running    sleep 100 &
```

### `Ctrl+Z` — Suspend a Foreground Process

```bash
# Start a long command
sleep 200

# Press Ctrl+Z to suspend it
# [1]+  Stopped    sleep 200
```

### `fg` — Bring to Foreground

```bash
fg              # Bring most recent job to foreground
fg %1           # Bring job #1 to foreground
```

### `bg` — Resume in Background

```bash
# After Ctrl+Z
bg              # Resume the stopped job in background
bg %1           # Resume job #1 in background
```

### `jobs` — List Background Jobs

```bash
jobs
jobs -l         # Include PIDs
```

---

## Killing Processes

### `kill` — Send a Signal to a Process

```bash
# Gracefully terminate (SIGTERM — default)
kill PID

# Force kill (SIGKILL — last resort)
kill -9 PID

# Other useful signals
kill -STOP PID    # Pause
kill -CONT PID    # Resume
```

### `killall` — Kill by Name

```bash
killall sleep         # Kill all sleep processes
killall -9 sleep      # Force kill all sleep processes
```

### `pkill` — Kill by Pattern

```bash
pkill -f "sleep 100"    # Kill processes matching the pattern (-f = match against the full command line, not just the process name)
```

### Common Signals

| Signal | Number | Name | Action |
| ------ | ------ | ---- | ------ |
| SIGHUP | 1 | Hangup | Reload config |
| SIGINT | 2 | Interrupt | Same as Ctrl+C |
| SIGKILL | 9 | Kill | Force kill (can't be caught) |
| SIGTERM | 15 | Terminate | Graceful shutdown (default) |
| SIGSTOP | 19 | Stop | Pause (can't be caught) |
| SIGCONT | 18 | Continue | Resume paused process |

---

## Process Priority

### `nice` — Start a Process with Adjusted Priority

Priority range: -20 (highest) to 19 (lowest). Default is 0.

```bash
# Start with lower priority
nice -n 10 long-running-command

# Start with higher priority (needs sudo)
sudo nice -n -5 important-command
```

### `renice` — Change Priority of Running Process

```bash
# Lower priority of a running process
renice 10 -p PID

# Higher priority (needs sudo)
sudo renice -5 -p PID
```

---

## Useful Process Commands

### `pgrep` — Find Process IDs

```bash
pgrep bash                      # PIDs of all bash processes
pgrep -u student                # -u = filter by user; PIDs of student's processes
pgrep -a bash                   # -a = show PID and full command line
```

### `nohup` — Keep Running After Logout

```bash
nohup long-command &
# Output goes to nohup.out
```

### `watch` — Repeat a Command Periodically

```bash
# Run 'ps aux' every 2 seconds (default interval)
watch ps aux

# Every 1 second (-n = interval in seconds)
watch -n 1 date

# Highlight differences between updates (-d = highlight changes)
watch -d free -h
```

---

## System Resources

### `free` — Memory Usage

```bash
free              # In bytes
free -h           # -h = human-readable (MB, GB)
free -h -s 2      # -s 2 = refresh every 2 seconds
```

### `df` — Disk Space

```bash
df                # Disk usage in 1K blocks
df -h             # -h = human-readable (KB, MB, GB)
df -h /           # Just the root filesystem
```

### `du` — Directory Size

```bash
du -h ~/practice              # -h = human-readable sizes
du -sh ~/practice             # -s = summary total (one line), -h = human-readable
du -sh ~/practice/*           # Size of each item in directory
du -h --max-depth=1 ~/        # --max-depth=1 = one level deep
```

---

## Hands-On Exercises

### Exercise 1: Explore Processes

```bash
# View your processes
ps

# View all processes (a = all users, u = user format, x = background too)
ps aux

# How many processes are running? (wc -l = count lines)
ps aux | wc -l

# Find bash processes (grep = search for matching text)
ps aux | grep bash
```

### Exercise 2: Background Jobs

```bash
# Start three background jobs
sleep 300 &
sleep 400 &
sleep 500 &

# View your jobs
jobs
jobs -l         # -l = include PIDs alongside job numbers

# Bring the second one to foreground
fg %2

# Suspend it
# Press Ctrl+Z

# Resume it in background
bg %2

# Check jobs again
jobs
```

### Exercise 3: Kill Processes

```bash
# Start a process
sleep 999 &

# Find its PID
jobs -l        # -l = show PIDs
# or
pgrep sleep    # find PIDs of processes named "sleep"

# Kill it gracefully
kill %1
# or: kill PID

# Verify it's gone
jobs

# Start multiple sleeps
sleep 888 &
sleep 777 &
sleep 666 &

# Kill them all at once
killall sleep
jobs
```

### Exercise 4: Monitor System

```bash
# Check memory
free -h

# Check disk space
df -h

# Check directory sizes
du -sh ~/practice

# Use top (press q to quit)
top

# Use htop (press q to quit)
htop
```

### Exercise 5: Watch in Action

```bash
# Watch the date update every second
watch -n 1 date
# Press Ctrl+C to stop

# Watch processes
watch -n 2 "ps aux | head -20"
# Press Ctrl+C to stop
```

---

## Challenge

1. Start **3 background sleep commands** (sleep 1000, sleep 2000, sleep 3000)
2. Use `jobs` to list them
3. Bring `sleep 2000` to the foreground, then suspend it with Ctrl+Z
4. Kill the suspended job
5. Kill all remaining sleep processes with a single command
6. Verify no sleep processes remain

<!-- markdownlint-disable MD033 -->
<details>
<summary>💡 Solution</summary>

```bash
# 1. Start them
sleep 1000 &
sleep 2000 &
sleep 3000 &

# 2. List
jobs

# 3. Bring sleep 2000 to foreground and suspend
fg %2
# Press Ctrl+Z

# 4. Kill the suspended job
kill %2

# 5. Kill all remaining
killall sleep

# 6. Verify
jobs
pgrep sleep    # Should return nothing
```

</details>
<!-- markdownlint-enable MD033 -->

---

**[← Lesson 05](05-permissions-ownership.md)** | **[Lesson 07 →](07-package-management.md)**
