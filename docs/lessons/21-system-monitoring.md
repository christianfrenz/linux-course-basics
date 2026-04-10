# Lesson 21 — System Monitoring

> **Goal:** Monitor your Linux system's health — uptime, CPU, memory, disk, temperature, and service status — using built-in tools and simple scripts.

---

## Why System Monitoring Matters

Servers, Raspberry Pis, and cloud VMs don't have a screen showing you how they're doing. You need to proactively check:

- Is the system overloaded?
- Is memory running low?
- Is the disk filling up?
- Is a service down?
- Is the hardware overheating?

This lesson gives you the tools and techniques to answer all of these from the command line.

---

## Uptime & Load Averages

### `uptime` — How Long and How Busy

```bash
# Show uptime and load averages
uptime

# Pretty/human-readable format (-p = pretty)
uptime -p

# Show the exact time the system booted (-s = since)
uptime -s
```

### Output

```text
 10:30:01 up 42 days,  3:15,  2 users,  load average: 0.52, 0.38, 0.41
```

| Field | Meaning |
| ----- | ------- |
| `up 42 days, 3:15` | System has been running for 42 days |
| `2 users` | Currently logged-in sessions |
| `load average: 0.52, 0.38, 0.41` | Average number of processes waiting for CPU (1, 5, 15 minutes) |

### Understanding Load Averages

Load average represents the average number of processes in the CPU run queue.

| Scenario (single-core CPU) | Meaning |
| --------------------------- | ------- |
| Load = **0.0** | Idle — nothing to do |
| Load = **1.0** | Fully utilized — CPU is busy but keeping up |
| Load = **2.0** | Overloaded — processes are waiting in line |

> **Key rule:** Compare load averages to the number of CPU cores. A load of `4.0` on a 4-core system means 100% utilization, not overload.

```bash
# Check how many CPU cores you have
nproc

# If nproc shows 4 and load is 3.8 → system is busy but coping
# If nproc shows 1 and load is 3.8 → system is severely overloaded
```

---

## CPU Information

### `lscpu` — CPU Details

```bash
# Show CPU architecture, cores, threads, model
lscpu
```

Key lines to look for:

```text
Architecture:        x86_64
CPU(s):              4
Model name:          Intel(R) Core(TM) i7-8550U
Thread(s) per core:  2
Core(s) per socket:  2
```

### `/proc/cpuinfo` — Raw CPU Details

```bash
# Full details for every logical CPU
cat /proc/cpuinfo

# Just the model name (one per core)
grep "model name" /proc/cpuinfo

# Count logical CPUs
grep -c "^processor" /proc/cpuinfo
```

### `mpstat` — Per-CPU Statistics

```bash
# Install sysstat package first
sudo apt install sysstat

# Show CPU usage for all cores (-P ALL = all processors)
mpstat -P ALL

# Sample every 2 seconds, 5 times (2 = interval, 5 = count)
mpstat 2 5
```

Key columns: `%usr` (user), `%sys` (kernel), `%idle` (unused), `%iowait` (waiting on disk).

---

## Memory Monitoring

### `free` — Memory Overview

```bash
# Show memory in human-readable units (-h = human)
free -h

# Keep updating every 2 seconds (-s = seconds interval)
free -h -s 2

# Show totals (-t = total row)
free -h -t
```

### Output

```text
              total        used        free      shared  buff/cache   available
Mem:          3.8Gi       1.2Gi       0.4Gi       120Mi       2.2Gi       2.3Gi
Swap:         2.0Gi       0.0Ki       2.0Gi
```

| Column | Meaning |
| ------ | ------- |
| `total` | Physical RAM installed |
| `used` | Memory actively in use by programs |
| `free` | Completely unused RAM |
| `buff/cache` | Memory used for disk caching (released when needed) |
| `available` | How much memory is *actually* available for new programs |

> **Important:** Linux uses free memory for disk caching. A system showing low `free` but high `available` is healthy — that's Linux being efficient.

### `/proc/meminfo` — Detailed Memory Stats

```bash
# All memory details
cat /proc/meminfo

# Quick check of total and available memory
grep -E "MemTotal|MemAvailable|SwapTotal|SwapFree" /proc/meminfo
```

### `vmstat` — Virtual Memory Statistics

```bash
# One-time snapshot
vmstat

# Sample every 2 seconds, 10 times (2 = interval, 10 = count)
vmstat 2 10
```

Key columns:

| Column | Meaning |
| ------ | ------- |
| `r` | Processes waiting to run |
| `b` | Processes in uninterruptible sleep (usually waiting on disk) |
| `si` / `so` | Swap in / swap out (high values = memory pressure) |
| `us` | CPU user time % |
| `sy` | CPU system time % |
| `id` | CPU idle % |
| `wa` | CPU iowait % (waiting on disk) |

> **Warning sign:** If `si`/`so` are consistently above 0, the system is using swap — it's running low on RAM.

---

## Disk Monitoring

### `df` — Disk Space Usage

```bash
# Show all filesystems in human-readable format (-h = human)
df -h

# Show only local filesystems, excluding tmpfs (-x = exclude type)
df -h -x tmpfs -x devtmpfs

# Show a specific mount point
df -h /
```

### Output

```text
Filesystem      Size  Used Avail Use%  Mounted on
/dev/sda1        50G   32G   16G  67%  /
```

> **Rule of thumb:** Investigate when `Use%` goes above **80%**. At **90%+** you need to act.

### `du` — Directory Space Usage

```bash
# Top 10 largest directories under /var (-s = summarize, -h = human)
du -sh /var/*/ | sort -rh | head -10

# Size of a specific directory
du -sh /var/log

# Size of each subdirectory one level deep (-d = depth)
du -h -d 1 /home
```

### `iostat` — Disk I/O Statistics

```bash
# Install sysstat if not present
sudo apt install sysstat

# Show CPU and disk I/O stats
iostat

# Human-readable, repeat every 2 seconds (-h = human, 2 = interval)
iostat -h 2

# Show extended disk stats (-x = extended)
iostat -x
```

Key columns in extended mode: `%util` (how busy the disk is), `await` (average wait time in ms), `r/s` and `w/s` (reads/writes per second).

> **Warning sign:** `%util` consistently near 100% means the disk is a bottleneck.

---

## Temperature Monitoring

Monitoring temperature is important for servers in enclosed spaces and especially for Raspberry Pis which can throttle under heat.

### `sensors` — Hardware Temperatures (lm-sensors)

```bash
# Install lm-sensors
sudo apt install lm-sensors

# Detect available sensors (run once, press Enter to accept defaults)
sudo sensors-detect

# Show all sensor readings
sensors
```

### Example Output

```text
coretemp-isa-0000
Core 0:       +52.0°C  (high = +80.0°C, crit = +100.0°C)
Core 1:       +50.0°C  (high = +80.0°C, crit = +100.0°C)
```

### Raspberry Pi — `vcgencmd`

On Raspberry Pi OS, the `vcgencmd` tool reads the SoC temperature directly:

```bash
# Read the CPU/GPU temperature
vcgencmd measure_temp

# Output: temp=45.6'C

# Check if the CPU is being throttled
vcgencmd get_throttled

# Output: throttled=0x0     (0x0 = no throttling, that's good)
```

### Reading Temperature from `/sys` (works in containers too)

```bash
# Read thermal zone temperatures (values in millidegrees Celsius)
cat /sys/class/thermal/thermal_zone0/temp

# Convert to degrees: divide by 1000
awk '{printf "%.1f°C\n", $1/1000}' /sys/class/thermal/thermal_zone0/temp

# List all available thermal zones
ls /sys/class/thermal/ | grep thermal_zone
```

> **Note:** In Docker containers (like our lab), hardware sensors are usually not available. These commands work best on bare-metal systems or VMs with sensor passthrough.

---

## Service Health

### `systemctl` — Check Services

```bash
# Check if a specific service is running
systemctl status ssh

# Quick active/inactive check (returns just one word)
systemctl is-active ssh

# Check if a service is set to start on boot
systemctl is-enabled ssh

# List all failed services
systemctl --failed

# List all running services
systemctl list-units --type=service --state=running
```

### Output of `systemctl status`

```text
● ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/lib/systemd/system/ssh.service; enabled)
     Active: active (running) since Mon 2024-03-24 08:00:00 UTC; 2 days ago
   Main PID: 1234 (sshd)
      Tasks: 1 (limit: 4915)
     Memory: 3.2M
        CPU: 1.234s
```

Key indicators:

| Field | What to Look For |
| ----- | ---------------- |
| `Active` | Should say `active (running)` |
| `Loaded` | Shows if `enabled` (starts at boot) or `disabled` |
| Last log lines | Look for error messages at the bottom |

### Checking Multiple Services at Once

```bash
# Check several services in a loop
for svc in ssh cron docker nginx; do
  printf "%-15s %s\n" "$svc" "$(systemctl is-active $svc 2>/dev/null || echo 'not installed')"
done
```

---

## Building a Simple Health Check Script

Combine everything into a quick system health report:

```bash
#!/bin/bash
# health-check.sh — Simple system health report

echo "===== SYSTEM HEALTH CHECK ====="
echo "Date:     $(date)"
echo "Hostname: $(hostname)"
echo "Uptime:   $(uptime -p)"
echo ""

echo "--- Load Average ---"
uptime | awk -F'load average: ' '{print $2}'
echo "CPU cores: $(nproc)"
echo ""

echo "--- Memory ---"
free -h | grep -E "Mem|Swap"
echo ""

echo "--- Disk Usage (above 70%) ---"
df -h --output=target,pcent,size,used | awk 'NR==1 || +$2 > 70'
echo ""

echo "--- Failed Services ---"
systemctl --failed --no-legend --no-pager || echo "None"
echo ""

# Temperature (works on bare metal, may not work in containers)
if command -v sensors &>/dev/null; then
  echo "--- Temperature ---"
  sensors | grep -E "Core|temp"
elif [ -f /sys/class/thermal/thermal_zone0/temp ]; then
  echo "--- Temperature ---"
  awk '{printf "CPU: %.1f°C\n", $1/1000}' /sys/class/thermal/thermal_zone0/temp
fi

echo "===== END ====="
```

```bash
# Make it executable and run it
chmod +x health-check.sh
./health-check.sh
```

> **Tip:** Schedule this with cron to run every hour and append output to a log file:
>
> ```bash
> crontab -e
> # Add this line:
> 0 * * * * /home/student/health-check.sh >> /home/student/health.log 2>&1
> ```

---

## Quick Reference

| Command | What It Shows | Package |
| ------- | ------------- | ------- |
| `uptime` | Uptime and load averages | built-in |
| `nproc` | Number of CPU cores | built-in |
| `lscpu` | CPU architecture and details | built-in |
| `free -h` | Memory and swap usage | built-in |
| `vmstat` | CPU, memory, I/O summary | built-in |
| `df -h` | Disk space per filesystem | built-in |
| `du -sh` | Directory size | built-in |
| `iostat` | Disk I/O statistics | `sysstat` |
| `mpstat` | Per-CPU statistics | `sysstat` |
| `sensors` | Hardware temperatures | `lm-sensors` |
| `vcgencmd measure_temp` | Raspberry Pi temperature | built-in (RPi) |
| `systemctl --failed` | Failed systemd services | built-in |

---

## Exercises

### Exercise 1: System Overview

```bash
# 1. Check how long the system has been running
uptime -p

# 2. Show the number of CPU cores
nproc

# 3. Display memory usage
free -h

# 4. Check disk usage on the root filesystem
df -h /
```

### Exercise 2: Load Investigation

```bash
# 1. Show current load averages
uptime

# 2. Compare load to CPU count — is the system overloaded?
echo "Load: $(awk '{print $1}' /proc/loadavg) | Cores: $(nproc)"

# 3. Run vmstat for 10 seconds and look at the 'r' column
vmstat 2 5
```

### Exercise 3: Find What's Using Disk Space

```bash
# 1. Show disk usage for all mount points
df -h

# 2. Find the 5 largest directories under /var
du -sh /var/*/ 2>/dev/null | sort -rh | head -5

# 3. Check the size of the log directory
du -sh /var/log
```

### Exercise 4: Build a Health Report

1. Create the `health-check.sh` script from the section above
2. Run it and review the output
3. Add a check that prints a warning if any filesystem is above 90%
4. (Bonus) Add a cron job to run it every 6 hours

---

## Challenge

Build an extended monitoring setup:

1. Write a script called `monitor.sh` that:
    - Shows uptime, load, memory, and disk usage
    - Lists all failed services
    - Shows the 5 biggest directories under `/var`
    - Prints a **WARNING** line if load average (1 min) exceeds the CPU core count
    - Prints a **WARNING** line if any filesystem is above 85% usage
2. Schedule it with cron to run every 30 minutes, writing output to `~/monitor.log`
3. Use `tail -f ~/monitor.log` in a tmux session to watch the results in real time
