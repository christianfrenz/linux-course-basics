# Lesson 08 — Networking Basics

> **Goal:** Understand basic networking concepts and use Linux networking tools.

---

## Networking Fundamentals

### Key Concepts

| Concept | What It Is |
| ------- | ---------- |
| **IP Address** | A unique address for a device on a network (e.g., 192.168.1.10) |
| **Subnet Mask** | Defines the network boundary (e.g., 255.255.255.0 or /24) |
| **Gateway** | The router — the "exit" to other networks / the internet |
| **DNS** | Translates domain names (google.com) to IP addresses |
| **Port** | A number identifying a specific service (80=HTTP, 443=HTTPS, 22=SSH) |
| **MAC Address** | Hardware address of a network interface |

---

## Checking Network Configuration

### `ip` — Modern Network Tool

```bash
# Show all network interfaces and their IPs
ip addr show
# or shorter:
ip a

# Show only IPv4 addresses
ip -4 addr show

# Show routing table (default gateway)
ip route show
# or:
ip r

# Show a specific interface
ip addr show eth0

# Show link layer info (MAC address)
ip link show
```

### `hostname` — View or Set Hostname

```bash
hostname                # Show hostname
hostname -I             # Show all IP addresses
```

---

## DNS — Name Resolution

### `cat /etc/resolv.conf` — Check DNS Servers

```bash
cat /etc/resolv.conf
```

### `nslookup` — Query DNS

```bash
nslookup google.com
nslookup ubuntu.com
```

### `dig` — Advanced DNS Lookup

```bash
# Basic lookup
dig google.com

# Short answer only
dig +short google.com

# Query a specific DNS server
dig @8.8.8.8 google.com

# Get all record types
dig google.com ANY

# Reverse lookup (IP → hostname)
dig -x 8.8.8.8
```

### `host` — Simple DNS Lookup

```bash
host google.com
host 8.8.8.8
```

---

## Testing Connectivity

### `ping` — Test if a Host is Reachable

```bash
# Ping a host (Ctrl+C to stop)
ping google.com

# Send only 4 pings (-c = count, stop after this many)
ping -c 4 google.com

# Ping with 1 second interval (-c = count, -i = interval in seconds)
ping -c 4 -i 1 google.com
```

### `traceroute` — Show the Path to a Host

```bash
traceroute google.com
```

Shows each hop (router) between you and the destination. Useful for diagnosing network issues.

---

## Downloading Files

### `curl` — Transfer Data (Versatile)

```bash
# Fetch a webpage (prints to screen)
curl https://example.com

# Save to a file (-o = output to specified filename)
curl -o example.html https://example.com

# Save with the server's filename (-O = use remote filename)
curl -O https://example.com/file.txt

# Follow redirects (-L = follow Location headers)
curl -L https://example.com

# Show response headers (-I = fetch headers only, no body)
curl -I https://example.com

# Download silently (-s = silent, no progress bar)
curl -s https://example.com

# POST request (-X = HTTP method, -d = data to send)
curl -X POST -d "name=linux" https://httpbin.org/post

# POST with JSON (-H = add a header, -d = request body)
curl -X POST -H "Content-Type: application/json" \
     -d '{"name":"linux"}' https://httpbin.org/post
```

### `wget` — Download Files

```bash
# Download a file
wget https://example.com/file.txt

# Save with a specific name
wget -O myfile.txt https://example.com

# Download in the background
wget -b https://example.com/large-file.zip

# Resume a download
wget -c https://example.com/large-file.zip

# Download quietly
wget -q https://example.com
```

---

## Monitoring Network Connections

### `ss` — Socket Statistics (Modern Replacement for `netstat`)

```bash
# Show all listening ports
ss -l

# Show listening TCP ports
ss -lt

# Show listening UDP ports
ss -lu

# Show all connections with process info
sudo ss -tulnp

# Show established connections
ss -t state established
```

**Understanding `ss -tulnp` flags:**

| Flag | Meaning |
| ---- | ------- |
| `-t` | TCP |
| `-u` | UDP |
| `-l` | Listening |
| `-n` | Numeric (don't resolve names) |
| `-p` | Show process using the socket |

### `netstat` — Classic Network Statistics

```bash
# Show all listening ports (requires net-tools)
# -t = TCP, -l = listening, -n = numeric (don't resolve names), -p = show process
netstat -tlnp

# Show all connections (-a = all sockets, listening and non-listening)
netstat -a

# Show routing table (-r = display routes)
netstat -r
```

---

## The `/etc/hosts` File

A local DNS override file. Entries here are checked before real DNS.

```bash
cat /etc/hosts
```

```text
127.0.0.1   localhost
127.0.1.1   ubuntu-lab
```

You can add custom entries:

```bash
sudo nano /etc/hosts

# Add a line like:
# 192.168.1.100   myserver
```

---

## Transferring Files

### `scp` — Secure Copy (Between Machines)

```bash
# Copy local file to remote
scp myfile.txt user@remote:/path/to/destination/

# Copy remote file to local
scp user@remote:/path/to/file.txt ./

# Copy a directory recursively
scp -r mydir/ user@remote:/path/
```

### `rsync` — Efficient File Sync

```bash
# Sync a directory
rsync -avz source/ destination/

# Sync to a remote
rsync -avz mydir/ user@remote:/path/

# Dry run (show what would happen)
rsync -avzn source/ destination/
```

| Flag | Meaning |
| ---- | ------- |
| `-a` | Archive mode (preserves permissions, etc.) |
| `-v` | Verbose |
| `-z` | Compress during transfer |
| `-n` | Dry run |

---

## Hands-On Exercises

### Exercise 1: Check Your Network

```bash
# View your IP addresses
ip addr show
hostname -I

# View your routing table
ip route show

# Check DNS settings
cat /etc/resolv.conf
```

### Exercise 2: Test Connectivity

```bash
# Ping Google (4 pings) (-c 4 = send 4 packets then stop)
ping -c 4 google.com

# Ping localhost (-c 2 = send 2 packets)
ping -c 2 127.0.0.1

# Trace the route to Google
traceroute google.com
```

### Exercise 3: DNS Lookups

```bash
# Look up an IP address
nslookup ubuntu.com
host ubuntu.com
dig +short ubuntu.com         # +short = show only the answer, no extra info

# Reverse lookup (-x = reverse lookup, IP to hostname)
dig -x 8.8.8.8 +short
```

### Exercise 4: Download with `curl` and `wget`

```bash
# Download a webpage with curl (-o = save to specified filename)
curl -o ~/practice/example.html https://example.com
cat ~/practice/example.html | head -20    # head -20 = show first 20 lines

# Check response headers (-I = headers only)
curl -I https://example.com

# Download with wget (-O = save with specified name)
wget -O ~/practice/example2.html https://example.com
```

### Exercise 5: Check Listening Ports

```bash
# What's listening on the system?
# ss: -t = TCP, -l = listening, -n = numeric, -p = show process
ss -tlnp

# Show all sockets (-a = all) and first 20 lines
ss -a | head -20
```

---

## Challenge

1. Find the IP address of `github.com` using three different tools (`dig`, `nslookup`, `host`)
2. Download the GitHub homepage using `curl`, save it to `~/practice/github.html`
3. Check the HTTP response headers of `https://github.com`
4. Write a simple script that pings a list of websites and reports which are reachable

<!-- markdownlint-disable MD033 -->
<details>
<summary>💡 Solution</summary>

```bash
# 1. Three DNS tools
dig +short github.com
nslookup github.com
host github.com

# 2. Download homepage
curl -o ~/practice/github.html https://github.com

# 3. Headers
curl -I https://github.com

# 4. Ping script
cat > ~/practice/ping-test.sh << 'EOF'
#!/bin/bash
sites=("google.com" "github.com" "example.com" "nonexistent.invalid")

for site in "${sites[@]}"; do
    if ping -c 1 -W 2 "$site" > /dev/null 2>&1; then
        echo "✅ $site is reachable"
    else
        echo "❌ $site is NOT reachable"
    fi
done
EOF

chmod +x ~/practice/ping-test.sh
~/practice/ping-test.sh
```

</details>
<!-- markdownlint-enable MD033 -->

---

**[← Lesson 07](07-package-management.md)** | **[Lesson 09 →](09-shell-scripting.md)**
