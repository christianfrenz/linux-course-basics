# Lesson 19 — Login Auditing & Access Logs

> **Goal:** Learn how to check who has logged into a Linux system, find failed login attempts, and monitor authentication activity.

---

## Why Login Auditing Matters

Knowing who accessed your system — and who tried to — is a fundamental part of Linux security and system administration. Whether you're managing a server, a Raspberry Pi, or a cloud VM, reviewing login history helps you:

- Detect unauthorized access attempts
- Troubleshoot user account issues
- Maintain an audit trail for compliance

Linux records login activity in several places. This lesson covers the key tools and log files.

---

## `last` — Successful Login History

`last` reads from `/var/log/wtmp` and shows a list of users who logged in (and out), including reboots.

```bash
# Show full login history
last

# Flags:
#   (none)  Show all entries from /var/log/wtmp

# Show the last 10 entries (-n = number of entries)
last -n 10

# Show logins for a specific user
last student

# Show logins with full IP addresses (-a = show hostname in last column, -i = show IP)
last -a -i

# Show system reboots only
last reboot
```

### What the Output Looks Like

```text
student  pts/0        192.168.1.50     Mon Mar 24 09:12   still logged in
student  pts/0        192.168.1.50     Sun Mar 23 14:31 - 17:45  (03:14)
reboot   system boot  5.15.0-97-generi Sun Mar 23 14:28   still running
```

| Column | Meaning |
| ------ | ------- |
| User | Who logged in |
| Terminal | `pts/0` = remote/pseudo terminal, `tty1` = local console |
| From | IP address or hostname |
| Time | Login and logout timestamps |

---

## `lastb` — Failed Login Attempts

`lastb` reads from `/var/log/btmp` and shows **failed** login attempts. Requires root privileges.

```bash
# Show failed login attempts (requires root)
sudo lastb

# Show the last 10 failed attempts (-n = number of entries)
sudo lastb -n 10

# Show failed attempts for a specific user
sudo lastb root
```

> ⚠️ If a server is exposed to the internet, `sudo lastb` will usually show hundreds of brute-force SSH attempts — this is normal and a good reason to disable password-based SSH login.

---

## `lastlog` — Most Recent Login Per User

`lastlog` shows the last login time for **every** user account on the system.

```bash
# Show last login for all users
lastlog

# Show last login for a specific user (-u = user)
lastlog -u student
```

Most system accounts will show **Never logged in** — that's expected.

---

## Auth Logs — Detailed Authentication Events

The auth log records every authentication event: successful logins, failed attempts, `sudo` usage, user switches, and more.

### On Debian/Ubuntu/Raspberry Pi OS

```bash
# View the full auth log
sudo cat /var/log/auth.log

# Follow the log in real time (-f = follow)
sudo tail -f /var/log/auth.log

# View the last 20 entries (-n = number of lines)
sudo tail -n 20 /var/log/auth.log

# Find SSH logins (grep = search for pattern)
sudo grep "sshd" /var/log/auth.log

# Find failed password attempts
sudo grep "Failed password" /var/log/auth.log

# Find successful logins
sudo grep "Accepted" /var/log/auth.log

# Find sudo usage
sudo grep "sudo:" /var/log/auth.log
```

### On RHEL/CentOS/Fedora

```bash
# The equivalent file is /var/log/secure
sudo cat /var/log/secure
sudo grep "Failed password" /var/log/secure
```

### What Auth Log Entries Look Like

```text
Mar 24 09:12:05 myhost sshd[1234]: Accepted publickey for student from 192.168.1.50 port 52341
Mar 24 09:15:22 myhost sshd[1240]: Failed password for root from 10.0.0.5 port 44321 ssh2
Mar 24 09:16:01 myhost sudo:  student : TTY=pts/0 ; PWD=/home/student ; USER=root ; COMMAND=/usr/bin/apt update
```

---

## `journalctl` — Systemd Journal Logs

On systems running systemd, `journalctl` provides structured access to login-related logs.

```bash
# SSH service logs (-u = filter by systemd unit)
journalctl -u ssh

# SSH logs from today only (--since = start time filter)
journalctl -u ssh --since "today"

# SSH logs with ISO timestamps (-o = output format)
journalctl -u ssh -o short-iso

# All authentication-related messages
journalctl _COMM=sshd

# Follow SSH logs in real time (-f = follow)
journalctl -u ssh -f
```

> 💡 Some systems use `sshd` as the unit name instead of `ssh`. Try both: `journalctl -u sshd` or `journalctl -u ssh`.

---

## `who` and `w` — Currently Logged-In Users

```bash
# Show who is logged in right now
who

# Show logged-in users + what they are doing, system load, and uptime
w
```

### `who` Output

```text
student  pts/0        2024-03-24 09:12 (192.168.1.50)
```

### `w` Output

```text
 09:30:01 up 1 day,  2:15,  1 user,  load average: 0.00, 0.01, 0.00
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
student  pts/0    192.168.1.50     09:12    0.00s  0.05s  0.00s w
```

---

## Quick Reference

| Command | What It Shows | Log File |
| ------- | ------------- | -------- |
| `last` | Successful login history | `/var/log/wtmp` |
| `lastb` | Failed login attempts | `/var/log/btmp` |
| `lastlog` | Last login per user | `/var/log/lastlog` |
| `who` | Currently logged-in users | `/var/run/utmp` |
| `w` | Logged-in users + activity | `/var/run/utmp` |
| `grep … auth.log` | Detailed auth events | `/var/log/auth.log` |
| `journalctl -u ssh` | Systemd SSH logs | systemd journal |

---

## Hands-On Exercises

### Exercise 1: Check Login History

```bash
# View the login history
last

# How many times has "student" logged in?
last student | grep "student" | wc -l

# Check for system reboots
last reboot
```

### Exercise 2: Look for Failed Logins

```bash
# Check for failed logins (requires root)
sudo lastb

# Count how many failed attempts there are
sudo lastb | wc -l
```

### Exercise 3: Explore the Auth Log

```bash
# View the last 20 auth log entries
sudo tail -n 20 /var/log/auth.log

# Find all sudo commands you've run
sudo grep "sudo:" /var/log/auth.log | tail -10

# Find any SSH-related entries
sudo grep "sshd" /var/log/auth.log | tail -10
```

### Exercise 4: Monitor Live Logins

```bash
# Open a real-time view of authentication events
sudo tail -f /var/log/auth.log

# In another terminal, run a sudo command:
#   sudo whoami
# Watch the auth log update in real time

# Press Ctrl+C to stop following
```

### Exercise 5: Check Current Users

```bash
# Who is logged in right now?
who

# Get more detail with w
w

# Check when each user account last logged in
lastlog
```

---

## Challenge

Write a script called `login-audit.sh` that generates a login audit report containing:

1. A header with the current date and hostname
2. Currently logged-in users (from `who`)
3. The last 10 successful logins (from `last`)
4. The last 10 failed login attempts (from `lastb`)
5. The last 10 `sudo` commands from `/var/log/auth.log`
6. Saves the report to `~/reports/login-audit-YYYYMMDD.txt`

<!-- markdownlint-disable MD033 -->
<details>
<summary>💡 Solution</summary>

```bash
cat > ~/practice/login-audit.sh << 'SCRIPT'
#!/bin/bash

# Create reports directory
mkdir -p ~/reports

date_stamp=$(date +%Y%m%d)
report_file=~/reports/login-audit-${date_stamp}.txt

{
echo "========================================="
echo "  Login Audit Report"
echo "  Date: $(date)"
echo "  Host: $(hostname)"
echo "========================================="
echo ""

echo "--- Currently Logged-In Users ---"
who 2>/dev/null || echo "No users logged in (or 'who' not available)"
echo ""

echo "--- Last 10 Successful Logins ---"
last -n 10 2>/dev/null || echo "Login history not available"
echo ""

echo "--- Last 10 Failed Login Attempts ---"
sudo lastb -n 10 2>/dev/null || echo "Failed login history not available"
echo ""

echo "--- Last 10 Sudo Commands ---"
if [ -f /var/log/auth.log ]; then
    sudo grep "sudo:" /var/log/auth.log 2>/dev/null | tail -10
else
    echo "Auth log not available."
fi
echo ""

echo "========================================="
echo "  End of Report"
echo "========================================="
} > "$report_file"

echo "Report saved to $report_file"
cat "$report_file"
SCRIPT

chmod +x ~/practice/login-audit.sh
~/practice/login-audit.sh
```

</details>
<!-- markdownlint-enable MD033 -->

---

**[← Lesson 18](18-docker-basics.md)** | **[Back to Home →](../index.md)**
