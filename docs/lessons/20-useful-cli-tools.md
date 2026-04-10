# Lesson 20 — Useful CLI Tools

> **Goal:** Discover powerful command-line tools that boost productivity: terminal multiplexing, fuzzy finding, disk analysis, network monitoring, and more.

---

## Why These Tools Matter

The commands you learned in earlier lessons (`ls`, `grep`, `top`, `df`, …) are solid foundations. But the Linux ecosystem has a rich collection of tools that make everyday tasks faster and more pleasant. This lesson covers the most impactful ones — all work over SSH with no graphical environment needed.

> **Note:** Most of these are already pre-installed in the lab container. On other systems, install them with `sudo apt install <package>`.

---

## `tmux` — Terminal Multiplexer

`tmux` lets you run multiple terminal sessions inside a single window, split panes side by side, and — most importantly — **detach and reattach** sessions. If your SSH connection drops, your work keeps running.

### Quick Start

```bash
# Start a new session
tmux

# You're now INSIDE tmux — notice the green status bar at the bottom
```

### Key Bindings

All tmux shortcuts start with the **prefix key**: **Ctrl + B**, then release, then press the action key.

| Action | Keys |
| ------ | ---- |
| **New window** | `Ctrl+B` then `c` |
| **Next window** | `Ctrl+B` then `n` |
| **Previous window** | `Ctrl+B` then `p` |
| **Split horizontally** | `Ctrl+B` then `"` |
| **Split vertically** | `Ctrl+B` then `%` |
| **Switch pane** | `Ctrl+B` then arrow key |
| **Detach session** | `Ctrl+B` then `d` |
| **Close current pane** | `exit` or `Ctrl+D` |

### Detach & Reattach (the killer feature)

```bash
# Inside tmux, start a long-running command
ping google.com

# Detach: Ctrl+B then d
# You're back in your normal shell — tmux keeps running in the background

# List running sessions
tmux ls

# Reattach
tmux attach
# or if you have multiple sessions:
tmux attach -t 0
```

### Named Sessions

```bash
# Create a named session
tmux new -s myproject

# Detach (Ctrl+B d), then reattach by name
tmux attach -t myproject
```

### Exercise

1. Start a tmux session named `lab`
2. Split the window into two vertical panes (`Ctrl+B %`)
3. Run `top` in the left pane
4. Switch to the right pane (`Ctrl+B →`) and run `df -h`
5. Detach (`Ctrl+B d`) and verify the session is still running with `tmux ls`
6. Reattach with `tmux attach -t lab`
7. Close everything: `exit` in each pane

---

## `fzf` — Fuzzy Finder

`fzf` is an interactive fuzzy search tool. Type a few characters and it instantly narrows down results from any list — files, command history, processes, you name it.

### Install

```bash
sudo apt install fzf
```

### Basic Usage

```bash
# Fuzzy-find a file in the current directory tree
fzf

# Start typing to filter — use arrow keys to select, Enter to confirm
```

### Piping Into fzf

```bash
# Find and open a file
nano $(find . -type f | fzf)

# Search command history interactively
history | fzf

# Kill a process by picking it from a list
kill $(ps aux | fzf | awk '{print $2}')
```

### Bash Integration

```bash
# After installing, enable key bindings:
source /usr/share/doc/fzf/examples/key-bindings.bash

# Now use:
#   Ctrl+R  — fuzzy search command history (replaces default)
#   Ctrl+T  — fuzzy find files and paste the path
#   Alt+C   — fuzzy find directories and cd into them
```

> **Tip:** Add the `source` line to your `~/.bashrc` to make it permanent.

### Exercise

1. Install `fzf` if not already present
2. Run `fzf` in your home directory and find a file by typing part of its name
3. Use `history | fzf` to find a previous command
4. Try the `Ctrl+R` shortcut after sourcing the key-bindings

---

## `tldr` — Simplified Man Pages

`man` pages are comprehensive but overwhelming. `tldr` shows practical examples for common use cases — perfect when you just need a quick reminder.

### Install

```bash
sudo apt install tldr

# Update the local page cache (required on first run)
tldr --update
```

### Usage

```bash
# Instead of: man tar
tldr tar

# Output:
#   tar
#   Archiving utility.
#   Often combined with a compression method, such as gzip or bzip2.
#
#   - Create an archive from files:
#     tar cf target.tar file1 file2 file3
#
#   - Extract an archive in the current directory:
#     tar xf source.tar
#   ...
```

### Compare

```bash
# Full manual (pages of text)
man rsync

# Quick cheat sheet (a few practical examples)
tldr rsync
```

### Exercise

1. Install `tldr` and run `tldr --update`
2. Look up `tldr find` and compare it with `man find`
3. Try `tldr curl`, `tldr chmod`, `tldr grep`

---

## `ncdu` — Disk Usage Explorer

`ncdu` (NCurses Disk Usage) is a visual, interactive version of `du`. It scans a directory and lets you drill down to find what's using space.

### Install & Run

```bash
sudo apt install ncdu

# Scan the current directory
ncdu

# Scan a specific path
ncdu /var/log
```

### Navigation

| Key | Action |
| --- | ------ |
| **↑ / ↓** | Navigate the list |
| **Enter** | Drill into a directory |
| **← / Backspace** | Go back up |
| **d** | Delete selected file/directory (asks confirmation) |
| **s** | Sort by size |
| **n** | Sort by name |
| **q** | Quit |

### Exercise

1. Run `ncdu /` to scan the entire filesystem
2. Find the largest directories under `/usr`
3. Press `s` to sort by size, then `n` to sort by name
4. Quit with `q`

---

## `bat` — `cat` with Syntax Highlighting

`bat` is a drop-in replacement for `cat` that adds line numbers, syntax highlighting, and Git integration.

### Install & Use

```bash
# On Ubuntu/Debian the package is called "bat" but the binary is "batcat"
sudo apt install bat

# Use it (note: the command is batcat on Debian/Ubuntu)
batcat /etc/passwd

# View a script with syntax highlighting
batcat ~/.bashrc

# Use as a pager for other commands
ps aux | batcat
```

> **Tip:** Create an alias: `alias bat='batcat'` in your `~/.bashrc`.

### Exercise

1. Install `bat` and view a config file: `batcat /etc/ssh/sshd_config`
2. Compare the output with `cat /etc/ssh/sshd_config`
3. Try piping into it: `ls -la /etc | batcat`

---

## Network Traffic Monitoring

On Windows you might use Wireshark. On Linux, the CLI equivalents are `tcpdump` for packet capture and `iftop` / `nload` for live bandwidth monitoring.

### `tcpdump` — Packet Capture (CLI Wireshark)

`tcpdump` captures and displays network packets in real time. It's the most widely used network debugging tool on Linux.

```bash
# Capture all traffic on the default interface (Ctrl+C to stop)
sudo tcpdump

# Capture on a specific interface
sudo tcpdump -i eth0

# Capture only HTTP traffic (port 80)
sudo tcpdump -i eth0 port 80

# Capture traffic to/from a specific host
sudo tcpdump host 8.8.8.8

# Capture DNS queries (port 53)
sudo tcpdump port 53

# Limit to 10 packets
sudo tcpdump -c 10

# Show traffic in ASCII (readable for HTTP, etc.)
sudo tcpdump -A port 80

# Save capture to a file (can be opened in Wireshark later!)
sudo tcpdump -w capture.pcap

# Read a saved capture file
sudo tcpdump -r capture.pcap
```

### Common Filters

```bash
# Combine filters with and/or/not
sudo tcpdump -i eth0 port 443 and host 192.168.1.1
sudo tcpdump -i eth0 not port 22       # Exclude SSH traffic
sudo tcpdump -i eth0 src 10.0.0.5      # Only from this source
sudo tcpdump -i eth0 dst port 53       # Only DNS destination
```

### Reading the Output

```text
09:15:42.123456 IP 192.168.1.10.54321 > 8.8.8.8.53: Flags [S], seq 123456, ...
│               │  │                     │            │
│               │  │                     │            └─ TCP flags (S=SYN, .=ACK, P=PSH, F=FIN)
│               │  │                     └─ Destination IP and port
│               │  └─ Source IP and port
│               └─ Protocol
└─ Timestamp
```

> **Tip:** Save captures as `.pcap` files with `-w` and transfer them to your host machine to open in Wireshark for a graphical view.

### `iftop` — Live Bandwidth by Connection

`iftop` shows a real-time view of active connections and how much bandwidth each one uses — like `top` but for network traffic.

```bash
sudo apt install iftop

# Monitor the default interface
sudo iftop

# Monitor a specific interface
sudo iftop -i eth0
```

| Key | Action |
| --- | ------ |
| **h** | Toggle help |
| **n** | Toggle DNS resolution |
| **s** | Toggle source display |
| **d** | Toggle destination display |
| **p** | Toggle port numbers |
| **P** | Pause display |
| **q** | Quit |

### `nload` — Live Bandwidth Graph

`nload` shows incoming and outgoing traffic as a live ASCII graph — great for a quick bandwidth overview.

```bash
sudo apt install nload

# Monitor default interface
nload

# Monitor a specific interface
nload eth0
```

| Key | Action |
| --- | ------ |
| **← / →** | Switch between interfaces |
| **F2** | Show options |
| **q** | Quit |

### Exercise — Network Monitoring

1. Open two tmux panes (use what you learned above!)
2. In pane 1, start `sudo tcpdump -c 20 port 80`
3. In pane 2, run `curl http://example.com`
4. Watch the packets appear in pane 1
5. Try `sudo iftop` while running `curl` commands in the other pane
6. Save a capture: `sudo tcpdump -c 50 -w ~/shared/traffic.pcap` — you can open this in Wireshark on your host machine

---

## Quick Reference

| Tool | Purpose | Install |
| ---- | ------- | ------- |
| `tmux` | Terminal multiplexer, split panes, detach/reattach | `sudo apt install tmux` |
| `fzf` | Fuzzy finder for files, history, anything | `sudo apt install fzf` |
| `tldr` | Simplified man pages with examples | `sudo apt install tldr` |
| `ncdu` | Interactive disk usage explorer | `sudo apt install ncdu` |
| `bat` | `cat` with syntax highlighting | `sudo apt install bat` |
| `tcpdump` | Packet capture (CLI Wireshark) | `sudo apt install tcpdump` |
| `iftop` | Live bandwidth per connection | `sudo apt install iftop` |
| `nload` | Live bandwidth graph | `sudo apt install nload` |

---

## Challenge

Set up a productive terminal workspace:

1. Start a named tmux session called `workspace`
2. Create three windows: `main`, `monitor`, `network`
3. In `monitor`: split into two panes — run `top` in one and `ncdu /` in the other
4. In `network`: run `sudo iftop`
5. In `main`: use `fzf` to find a file and view it with `batcat`
6. Detach from tmux, then reattach by name
7. Save a 30-second packet capture to `~/shared/challenge.pcap`
