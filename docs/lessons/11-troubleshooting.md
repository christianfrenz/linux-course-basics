# Lesson 11 — Troubleshooting Common Issues

> **Goal:** Build a systematic approach to diagnosing problems and learn how to fix the most common Linux issues you will encounter.

---

## The Troubleshooting Mindset

Before diving into specific problems, here is a general process that works for almost any issue:

1. **Read the error message** — it usually tells you exactly what went wrong
2. **Check the obvious first** — typos, wrong directory, missing permissions
3. **Reproduce the problem** — can you trigger it reliably?
4. **Isolate the cause** — change one thing at a time
5. **Search for the error** — paste the exact message into a search engine
6. **Check the logs** — `/var/log/syslog`, `journalctl`, application logs

---

## "Command Not Found"

This is the most common error beginners see.

```text
bash: somecommand: command not found
```

### Causes and Fixes

Typo in the command name:

```bash
# Wrong
lss -la

# Right
ls -la
```

The program is not installed:

```bash
# Check if it is installed
which htop
# If no output, install it
sudo apt install htop
```

The program is installed but not in your PATH:

```bash
# Find where it actually is
# find: / = search from root, -name = match filename, -type f = files only
# 2>/dev/null = hide "permission denied" errors
find / -name "cowsay" -type f 2>/dev/null

# Check your current PATH
echo $PATH

# Run it with the full path
/usr/games/cowsay "Hello"
```

You forgot `sudo` for a system command — some commands are only in root's PATH (`/sbin`, `/usr/sbin`):

```bash
# This might fail for non-root users on some systems
ifconfig

# Use the full path or the modern replacement
/sbin/ifconfig
ip addr
```

### Identifying Command Types

```bash
# Is the command a built-in, alias, or external program?
type ls
type cd
type ll
```

---

## Permission Denied

```text
bash: ./myscript.sh: Permission denied
```

### Causes and Fixes — Permissions

File is not executable:

```bash
# Check permissions
ls -l myscript.sh

# Make it executable
chmod +x myscript.sh
```

You need root privileges:

```bash
# Permission denied on a system file?
cat /etc/shadow
# Use sudo
sudo cat /etc/shadow
```

Writing to a read-only location:

```bash
# This fails — /usr is owned by root
echo "test" > /usr/test.txt

# Write to your home directory instead
echo "test" > ~/test.txt

# Or use sudo if you genuinely need to write there
sudo bash -c 'echo "test" > /usr/test.txt'
```

### Diagnosing Permission Issues

```bash
# Who owns the file? (ls: -l = long format, -a = including hidden files)
ls -la /path/to/file

# What groups am I in?
id

# What are the actual permissions? (stat shows detailed file metadata)
stat /path/to/file
```

---

## "No Such File or Directory"

```text
bash: /home/student/scrpt.sh: No such file or directory
```

### Causes and Fixes — Missing Files

Typo in the path or filename:

```bash
# Check what is actually there
ls -la

# Use Tab completion to avoid typos
cat pra<Tab>     # completes to practice/
```

You are in the wrong directory:

```bash
# Where am I?
pwd

# Go to the right place
cd ~/practice
```

The file is hidden:

```bash
# Hidden files start with a dot
ls -la
# Look for files like .bashrc, .profile
```

Case sensitivity — Linux cares about uppercase vs lowercase:

```bash
# These are THREE different files on Linux
touch File.txt file.txt FILE.txt
ls -la *.txt
```

---

## Disk Space Issues

```text
No space left on device
```

### Diagnosing Disk Usage

```bash
# Check overall disk usage (df: -h = human-readable KB/MB/GB)
df -h

# Find what is using space in the current directory (-s = summary, -h = human-readable)
du -sh *

# Find what is using space system-wide (top 20 largest files)
# find: -type f = regular files, -exec = run command on each
# sort: -r = reverse, -h = human-numeric (understands K, M, G)
# head -20 = first 20 results
sudo find / -type f -exec du -h {} + 2>/dev/null | sort -rh | head -20

# Check for large log files
sudo du -sh /var/log/*
```

### Fixing

```bash
# Clean up APT cache
sudo apt clean

# Remove packages that are no longer needed
sudo apt autoremove -y    # -y = auto-confirm

# Find and remove old log files
# find: -name "*.gz" = gzipped files, -delete = remove them
sudo find /var/log -name "*.gz" -delete

# Truncate a log file instead of deleting it (keeps the file handle)
# truncate: -s 0 = set size to 0 bytes
sudo truncate -s 0 /var/log/syslog
```

---

## Package Manager Problems

### "Unable to locate package"

```bash
# You probably forgot to update the package list
sudo apt update
sudo apt install packagename
```

### "Could not get lock"

```text
E: Could not get lock /var/lib/dpkg/lock-frontend
```

Another `apt` process is running. Wait for it or find and stop it:

```bash
# See what is holding the lock (ps aux = all processes; grep -i = case-insensitive search)
ps aux | grep -i apt

# Wait for it to finish, or if it is stuck:
sudo kill <PID>
sudo rm /var/lib/dpkg/lock-frontend
sudo dpkg --configure -a
```

### "Broken packages"

```bash
# Fix broken dependencies
sudo apt --fix-broken install

# Reconfigure packages
sudo dpkg --configure -a

# If all else fails, force a clean state
sudo apt update
sudo apt upgrade -y
```

---

## Network Connectivity Issues

### Can I reach the internet?

```bash
# Step 1 — Do I have an IP address?
ip addr show

# Step 2 — Can I reach the gateway (local network)?
ip route show
# Note the "default via" address, then ping it
# ping: -c 3 = send only 3 packets
ping -c 3 <gateway-ip>

# Step 3 — Can I reach the outside world by IP?
ping -c 3 8.8.8.8

# Step 4 — Can I resolve domain names (DNS)?
ping -c 3 google.com

# If step 3 works but step 4 fails, it is a DNS problem
cat /etc/resolv.conf
```

### DNS Not Working

```bash
# Check current DNS config
cat /etc/resolv.conf

# Test with a known DNS server
dig @8.8.8.8 google.com

# Temporarily fix by adding Google DNS
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf
```

### Port / Service Not Reachable

```bash
# Is the service running? (ss: -t = TCP, -l = listening, -n = numeric, -p = show process)
ss -tlnp | grep :80

# Is something blocking the port?
sudo ss -tlnp

# Can I connect to a remote port? (curl -v = verbose, show connection details)
curl -v http://example.com:80
```

---

## Process Problems

### A Command Hangs / Freezes

```bash
# Press Ctrl+C to interrupt it

# If Ctrl+C does not work, open another terminal and find the process
ps aux | grep <command-name>
kill <PID>

# Last resort — force kill
kill -9 <PID>
```

### High CPU or Memory Usage

```bash
# See what is using resources
top
# Press Shift+M to sort by memory, Shift+P for CPU

# Or use htop for a friendlier view
htop

# Kill a runaway process (kill sends SIGTERM by default = graceful shutdown)
kill <PID>

# Check memory usage (free -h = human-readable MB/GB)
free -h
```

### Zombie Processes

A zombie is a finished process whose parent has not collected its exit status:

```bash
# Find zombies
# ps aux: a = all users, u = user format, x = include background processes
# awk '$8 ~ /Z/' = print lines where column 8 (STAT) contains Z (zombie)
ps aux | awk '$8 ~ /Z/ {print}'

# You cannot kill a zombie directly — kill its parent instead
# Find the parent PID (PPID)
# ps: -o = custom output format (pid, ppid, stat, comm)
ps -o pid,ppid,stat,comm | grep Z
kill <PPID>
```

---

## SSH and Login Problems

### "Connection refused"

```bash
# Is SSH running on the remote machine?
# ss: -t = TCP, -l = listening, -n = numeric, -p = show process; grep :22 = SSH port
sudo ss -tlnp | grep :22

# Start it if needed
sudo service ssh start
```

### "Permission denied (publickey)"

```bash
# The server does not accept password login, it wants a key

# Generate a key pair (if you do not have one)
# ssh-keygen: -t = key type (ed25519 is modern and secure)
ssh-keygen -t ed25519

# Copy your public key to the server
ssh-copy-id user@remote-host

# Check key permissions (must be strict)
ls -la ~/.ssh/    # -l = long format, -a = show hidden files
# id_ed25519 should be 600, .ssh/ should be 700
chmod 700 ~/.ssh              # 700 = owner: read+write+execute, others: none
chmod 600 ~/.ssh/id_ed25519   # 600 = owner: read+write, others: none
```

### "Host key verification failed"

```bash
# The server's fingerprint changed (rebuilt, new IP, etc.)
# Remove the old key
ssh-keygen -R <hostname-or-ip>

# Then connect again — it will ask you to accept the new key
ssh user@remote-host
```

---

## Shell and Script Errors

### "Syntax error near unexpected token"

Usually a missing quote, bracket, or mismatched `if`/`fi`, `do`/`done`:

```bash
# Wrong — missing closing quote
echo "Hello

# Right
echo "Hello"

# Wrong — missing 'fi'
if [ -f test.txt ]; then
    echo "exists"

# Right
if [ -f test.txt ]; then
    echo "exists"
fi
```

### "Bad substitution"

```bash
# Wrong — extra space or missing brace
echo ${ USER}
echo ${USER

# Right
echo ${USER}
```

### Script Works Manually But Not in Cron

```bash
# Cron uses a minimal environment — PATH is limited
# Always use full paths in cron jobs
# Wrong
crontab: * * * * * backup.sh
# Right
crontab: * * * * * /home/student/scripts/backup.sh

# Or set PATH in the crontab
crontab: PATH=/usr/local/bin:/usr/bin:/bin
```

---

## Useful Diagnostic Commands Cheat Sheet

| What | Command |
| ---- | ------- |
| What OS am I running? | `cat /etc/os-release` |
| Kernel version | `uname -r` |
| Current user | `whoami` |
| Am I root? | `id` |
| Disk space | `df -h` |
| Memory | `free -h` |
| Running processes | `ps aux` or `htop` |
| Open ports | `ss -tlnp` |
| Network interfaces | `ip addr` |
| DNS resolution | `dig example.com` or `nslookup example.com` |
| System logs | `sudo tail -f /var/log/syslog` |
| Recent boots | `who -b` |
| Service status | `service <name> status` |
| Installed packages | `dpkg -l \| grep <name>` |
| File permissions | `ls -la <file>` |
| Find a file | `find / -name "<filename>" 2>/dev/null` |
| Check a command's type | `type <command>` |
| Shell environment | `env` |

---

## Exercises

1. Create a script called `~/practice/debug-me.sh` with an intentional syntax error. Run it and read the error message. Fix it.
2. Create a file owned by root, then try to edit it as `student`. Observe the error and fix it with `sudo`.
3. Fill up a temporary directory and observe the "no space left" behavior:

   ```bash
   mkdir ~/practice/filltest
   # Create a large file (50MB)
   dd if=/dev/zero of=~/practice/filltest/bigfile bs=1M count=50
   # Check usage
   du -sh ~/practice/filltest
   # Clean up
   rm -rf ~/practice/filltest
   ```

4. Run `sleep 300 &` and then find and kill the process using three different methods (`kill`, `pkill`, `killall`).
5. Intentionally misspell a package name with `apt install` and read the error output.

---

## Challenge

Write a diagnostic script called `~/practice/system-check.sh` that:

1. Checks available disk space and warns if any filesystem is above 80% usage
2. Checks available memory and warns if less than 100MB is free
3. Lists any zombie processes
4. Checks if key services are running (cron, rsyslog)
5. Reports the 5 largest files in `/home/student`
6. Prints a green "OK" or red "WARNING" next to each check

<!-- markdownlint-disable MD033 -->
<details>
<summary>💡 Solution</summary>

```bash
cat > ~/practice/system-check.sh << 'SCRIPT'
#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

ok()   { echo -e "  [${GREEN}OK${NC}]      $1"; }
warn() { echo -e "  [${RED}WARNING${NC}]  $1"; }

echo "===== System Health Check ====="
echo ""

# 1. Disk space
echo "--- Disk Space ---"
while read -r usage mount; do
    pct=${usage%\%}
    if [ "$pct" -gt 80 ] 2>/dev/null; then
        warn "$mount is at $usage"
    else
        ok "$mount is at $usage"
    fi
done < <(df -h --output=pcent,target | tail -n +2)
echo ""

# 2. Memory
echo "--- Memory ---"
free_mb=$(free -m | awk '/^Mem:/ {print $7}')
if [ "$free_mb" -lt 100 ]; then
    warn "Only ${free_mb}MB available"
else
    ok "${free_mb}MB available"
fi
echo ""

# 3. Zombies
echo "--- Zombie Processes ---"
zombies=$(ps aux | awk '$8 ~ /Z/ {count++} END {print count+0}')
if [ "$zombies" -gt 0 ]; then
    warn "$zombies zombie process(es) found"
    ps aux | awk '$8 ~ /Z/'
else
    ok "No zombies"
fi
echo ""

# 4. Services
echo "--- Services ---"
for svc in cron rsyslog; do
    if service $svc status > /dev/null 2>&1; then
        ok "$svc is running"
    else
        warn "$svc is not running"
    fi
done
echo ""

# 5. Largest files
echo "--- Top 5 Largest Files in /home/student ---"
find /home/student -type f -exec du -h {} + 2>/dev/null | sort -rh | head -5
echo ""

echo "===== Check Complete ====="
SCRIPT

chmod +x ~/practice/system-check.sh
~/practice/system-check.sh
```

</details>
<!-- markdownlint-enable MD033 -->

---

**[← Lesson 10](10-system-administration.md)** | **[Lesson 12 →](12-io-redirection-pipes.md)**
