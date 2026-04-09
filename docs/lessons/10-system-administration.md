# Lesson 10 — System Administration Essentials

> **Goal:** Manage users, schedule tasks, work with services, monitor logs, and handle disks.

---

## User & Group Management

### Creating Users

```bash
# Create a new user
sudo useradd -m -s /bin/bash newuser

# Flags:
#   -m  Create home directory
#   -s  Set default shell

# Set a password
sudo passwd newuser

# Create a user with more options
sudo useradd -m -s /bin/bash -c "John Doe" -G sudo johndoe
#   -c  Comment (full name)
#   -G  Additional groups
```

### `adduser` — Interactive User Creation (Ubuntu-Friendly)

```bash
sudo adduser testuser
# Prompts for password, full name, etc.
```

### Modifying Users

```bash
# Add user to a group (-a = append, -G = supplementary group; without -a it replaces all groups)
sudo usermod -aG sudo newuser

# Change default shell (-s = set login shell)
sudo usermod -s /bin/bash newuser

# Lock a user account (-L = lock the password)
sudo usermod -L newuser

# Unlock (-U = unlock the password)
sudo usermod -U newuser

# Change username (-l = new login name)
sudo usermod -l newname oldname
```

### Deleting Users

```bash
# Delete user (keep home directory)
sudo userdel newuser

# Delete user AND home directory
sudo userdel -r newuser
```

### Managing Groups

```bash
# Create a group
sudo groupadd developers

# Add user to group (-a = append, -G = supplementary group)
sudo usermod -aG developers student

# View group membership
groups student
id student

# Remove user from group (gpasswd -d = delete user from group)
sudo gpasswd -d student developers

# Delete a group
sudo groupdel developers
```

### Important User/Group Files

```bash
# User accounts
cat /etc/passwd
# Format: username:x:UID:GID:comment:home:shell

# Group definitions
cat /etc/group

# Encrypted passwords (readable only by root)
sudo cat /etc/shadow

# Sudoers config
sudo cat /etc/sudoers
```

---

## Switching Users

```bash
# Switch to another user
su - username

# Switch to root
sudo su -

# Run a single command as another user
sudo -u username command

# Check who you are
whoami
id
```

---

## Scheduled Tasks with `cron`

`cron` runs tasks automatically on a schedule.

### Crontab Format

```text
┌───────────── minute (0-59)
│ ┌───────────── hour (0-23)
│ │ ┌───────────── day of month (1-31)
│ │ │ ┌───────────── month (1-12)
│ │ │ │ ┌───────────── day of week (0-7, 0 and 7 = Sunday)
│ │ │ │ │
* * * * * command to execute
```

### Common Schedules

| Schedule | Meaning |
| -------- | ------- |
| `* * * * *` | Every minute |
| `0 * * * *` | Every hour |
| `0 0 * * *` | Every day at midnight |
| `0 0 * * 0` | Every Sunday at midnight |
| `0 9 * * 1-5` | Every weekday at 9 AM |
| `*/5 * * * *` | Every 5 minutes |
| `0 0 1 * *` | First day of every month |

### Managing Crontab

```bash
# Edit your crontab
crontab -e

# List your cron jobs
crontab -l

# Remove all your cron jobs
crontab -r

# Edit another user's crontab (requires sudo)
sudo crontab -u username -e
```

### Crontab Examples

```bash
# Log the date every minute
* * * * * echo "$(date)" >> /home/student/cron.log

# Run a backup every day at 2 AM
0 2 * * * /home/student/practice/backup.sh

# Clean /tmp every Sunday at midnight
0 0 * * 0 rm -rf /tmp/old-files/*

# Run a health check every 5 minutes
*/5 * * * * /home/student/practice/sysinfo.sh >> /home/student/health.log 2>&1
```

---

## System Logs

Linux stores logs in `/var/log/`. They're essential for troubleshooting.

### Important Log Files

| File | Purpose |
| ---- | ------- |
| `/var/log/syslog` | General system log |
| `/var/log/auth.log` | Authentication (logins, sudo) |
| `/var/log/kern.log` | Kernel messages |
| `/var/log/dpkg.log` | Package installation log |
| `/var/log/apt/history.log` | APT history |

### Reading Logs

```bash
# View the system log
sudo cat /var/log/syslog

# Follow logs in real time (tail -f = follow, show new lines as they appear)
sudo tail -f /var/log/syslog

# View last 20 lines (tail -n 20 = last 20 lines)
sudo tail -n 20 /var/log/syslog

# Search for errors (grep -i = case-insensitive match)
sudo grep -i "error" /var/log/syslog

# View auth log (login attempts)
sudo cat /var/log/auth.log

# View package install history (tail -20 = last 20 lines)
cat /var/log/dpkg.log | tail -20
```

### `journalctl` — Systemd Journal

```bash
# View all logs
journalctl

# View recent logs (-n 50 = last 50 entries)
journalctl -n 50

# Follow logs in real time (-f = follow, like tail -f)
journalctl -f

# Filter by priority (-p = priority level: emerg, alert, crit, err, warning, notice, info, debug)
journalctl -p err        # Errors only
journalctl -p warning    # Warnings and above

# Filter by time
journalctl --since "1 hour ago"
journalctl --since "2024-01-01" --until "2024-01-02"

# Filter by unit/service (-u = systemd unit name)
journalctl -u cron
```

---

## Disk Management

### Viewing Disk Usage

```bash
# Filesystem usage (-h = human-readable sizes)
df -h

# Directory sizes (-s = summary, -h = human-readable)
du -sh /home/student/*
# --max-depth=1 = show only one level of subdirectories
du -h --max-depth=1 /home/student

# Find the largest files
# find: -type f = files only, -exec = run command on each result
# sort: -r = reverse, -h = human-numeric (understands K, M, G)
# head -20 = first 20 lines
find / -type f -exec du -h {} + 2>/dev/null | sort -rh | head -20
```

### Understanding `df -h` Output

```text
Filesystem      Size  Used Avail Use% Mounted on
overlay          59G   12G   44G  22% /
```

| Column | Meaning |
| ------ | ------- |
| Filesystem | Physical or virtual disk |
| Size | Total size |
| Used | Space used |
| Avail | Space available |
| Use% | Percentage used |
| Mounted on | Where it's accessible in the filesystem |

### Working with Archives

```bash
# Create a tar.gz archive
# tar: -c = create, -z = compress with gzip, -f = output filename
tar -czf archive.tar.gz directory/

# Extract a tar.gz archive
# tar: -x = extract, -z = decompress gzip, -f = input filename
tar -xzf archive.tar.gz

# List contents without extracting
# tar: -t = list contents, -z = gzip, -f = filename
tar -tzf archive.tar.gz

# Create a zip file (-r = recursive, include subdirectories)
zip -r archive.zip directory/

# Extract a zip file
unzip archive.zip

# Extract to a specific directory (-d = destination directory)
unzip archive.zip -d /path/to/destination/
```

**`tar` flags:**

| Flag | Meaning |
| ---- | ------- |
| `-c` | Create archive |
| `-x` | Extract archive |
| `-z` | Compress/decompress with gzip |
| `-f` | Specify filename |
| `-v` | Verbose (show files) |
| `-t` | List contents |

---

## Environment Variables

```bash
# View all environment variables
env

# View a specific variable
echo $HOME
echo $PATH
echo $USER

# Set a variable (current session only)
export MY_VAR="hello"
echo $MY_VAR

# Set permanently — add to ~/.bashrc
echo 'export MY_VAR="hello"' >> ~/.bashrc
source ~/.bashrc    # Reload

# View and modify PATH
echo $PATH
export PATH="$PATH:/home/student/scripts"
```

### Important Environment Variables

| Variable | Purpose |
| -------- | ------- |
| `$HOME` | Home directory path |
| `$USER` | Current username |
| `$PATH` | Directories searched for commands |
| `$SHELL` | Current shell |
| `$EDITOR` | Default text editor |
| `$LANG` | System language/locale |
| `$PWD` | Current directory |
| `$HOSTNAME` | Machine name |

---

## Startup Files

When Bash starts, it reads these files in order:

| File | When |
| ---- | ---- |
| `/etc/profile` | System-wide, login shells |
| `~/.bash_profile` | User-specific, login shells |
| `~/.bashrc` | User-specific, interactive non-login shells |
| `~/.bash_logout` | Runs when you log out |

To customize your shell, edit `~/.bashrc`:

```bash
nano ~/.bashrc

# Add useful aliases
alias ll='ls -la'
alias cls='clear'
alias update='sudo apt update && sudo apt upgrade -y'
alias ..='cd ..'
alias ...='cd ../..'

# Reload
source ~/.bashrc
```

---

## Hands-On Exercises

### Exercise 1: User Management

```bash
# Create a test user
sudo useradd -m -s /bin/bash testuser
sudo passwd testuser
# Enter a password when prompted

# Create a group
sudo groupadd testers

# Add user to group
sudo usermod -aG testers testuser

# Verify
id testuser
groups testuser

# Switch to the new user
su - testuser
whoami
pwd
exit    # Back to student

# Clean up
sudo userdel -r testuser
sudo groupdel testers
```

### Exercise 2: Cron Jobs

```bash
# Start cron service (some Docker containers need this)
sudo service cron start

# Create a cron job that logs every minute
crontab -e
# Add this line:
# * * * * * echo "$(date): cron is working" >> /home/student/cron-test.log

# Wait 2 minutes, then check
cat ~/cron-test.log

# Remove the cron job
crontab -r

# Clean up
rm ~/cron-test.log
```

### Exercise 3: Explore Logs

```bash
# Check system logs
sudo tail -20 /var/log/syslog

# Check auth logs
sudo tail -10 /var/log/auth.log

# Search for your sudo usage
sudo grep "student" /var/log/auth.log

# Check package history
cat /var/log/dpkg.log | tail -10
```

### Exercise 4: Disk Management

```bash
# Check disk usage
df -h

# What's taking space in your home?
du -sh ~/*

# Create an archive of your practice directory
cd ~
tar -czf practice-backup.tar.gz practice/

# List archive contents
tar -tzf practice-backup.tar.gz

# Extract to a test directory
mkdir /tmp/test-extract
tar -xzf practice-backup.tar.gz -C /tmp/test-extract/
ls /tmp/test-extract/practice/

# Clean up
rm practice-backup.tar.gz
rm -rf /tmp/test-extract
```

### Exercise 5: Customize Your Shell

```bash
# Add aliases to .bashrc
cat >> ~/.bashrc << 'EOF'

# Custom aliases
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias cls='clear'
alias myip='hostname -I'
alias ports='ss -tlnp'
alias update='sudo apt update && sudo apt upgrade -y'
EOF

# Reload
source ~/.bashrc

# Test your new aliases
ll
myip
ports
```

---

## Challenge

Create a complete "daily maintenance" script that:

1. Prints a header with date and hostname
2. Shows disk usage summary
3. Shows memory usage
4. Counts total running processes
5. Lists any users currently logged in
6. Checks if any critical log entries appeared today
7. Saves the full report to `~/reports/daily-YYYYMMDD.txt`

<!-- markdownlint-disable MD033 -->
<details>
<summary>💡 Solution</summary>

```bash
cat > ~/practice/daily-report.sh << 'SCRIPT'
#!/bin/bash

# Create reports directory
mkdir -p ~/reports

date_stamp=$(date +%Y%m%d)
report_file=~/reports/daily-${date_stamp}.txt

{
echo "========================================="
echo "  Daily System Report"
echo "  Date: $(date)"
echo "  Host: $(hostname)"
echo "========================================="
echo ""

echo "--- Disk Usage ---"
df -h / | tail -1 | awk '{printf "Used: %s / %s (%s)\n", $3, $2, $5}'
echo ""

echo "--- Memory ---"
free -h | grep Mem | awk '{printf "Used: %s / %s\n", $3, $2}'
echo ""

echo "--- Processes ---"
echo "Total: $(ps aux | wc -l)"
echo "Top 5 by CPU:"
ps aux --sort=-%cpu | head -6
echo ""

echo "--- Logged-in Users ---"
who 2>/dev/null || echo "No users logged in (or 'who' not available)"
echo ""

echo "--- Recent Errors in Syslog ---"
if [ -f /var/log/syslog ]; then
    errors=$(sudo grep -i "error" /var/log/syslog 2>/dev/null | tail -5)
    if [ -n "$errors" ]; then
        echo "$errors"
    else
        echo "No recent errors found."
    fi
else
    echo "Syslog not available."
fi

echo ""
echo "========================================="
echo "  Report saved to: $report_file"
echo "========================================="
} | tee "$report_file"
SCRIPT

chmod +x ~/practice/daily-report.sh
~/practice/daily-report.sh
```

</details>
<!-- markdownlint-enable MD033 -->

---

**[← Lesson 09](09-shell-scripting.md)** | **[Lesson 11 →](11-troubleshooting.md)**
