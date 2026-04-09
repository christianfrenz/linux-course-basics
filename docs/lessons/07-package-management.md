# Lesson 07 — Package Management

> **Goal:** Install, remove, update, and manage software using Ubuntu's `apt` package manager.

---

## What is a Package Manager?

A **package manager** automates installing, updating, and removing software. Ubuntu uses **APT** (Advanced Package Tool) backed by `.deb` packages from official repositories.

Think of it as an app store for your terminal.

---

## The `apt` Command

`apt` is the modern, user-friendly interface (replacing older `apt-get`/`apt-cache`).

### Updating Package Lists

Before installing anything, always update the local package database:

```bash
sudo apt update
```

This downloads the latest list of available packages. **It does NOT install or upgrade anything.**

### Upgrading Installed Packages

```bash
# Upgrade all installed packages
sudo apt upgrade

# Upgrade with auto-yes (no confirmation prompt)
sudo apt upgrade -y

# Full upgrade (also handles changed dependencies)
sudo apt full-upgrade
```

---

## Installing Software

```bash
# Install a single package
sudo apt install cowsay

# Install multiple packages
sudo apt install cowsay figlet

# Install without confirmation
sudo apt install -y cowsay

# Install a specific version
sudo apt install package=version
```

### Try it

```bash
sudo apt update
sudo apt install -y cowsay figlet

# Now use them
cowsay "I love Linux!"
figlet "Hello"
```

---

## Removing Software

```bash
# Remove a package (keeps config files)
sudo apt remove cowsay

# Remove package AND its config files
sudo apt purge cowsay

# Remove unused dependencies
sudo apt autoremove

# Combine: purge and clean up
sudo apt purge -y cowsay && sudo apt autoremove -y
```

---

## Searching for Packages

```bash
# Search for packages by keyword
apt search "text editor"

# Search in package names only
apt search --names-only editor

# Show detailed info about a package
apt show nano

# List installed packages
apt list --installed

# List upgradable packages
apt list --upgradable

# Check if a specific package is installed
apt list --installed | grep nano
```

---

## Package Information

```bash
# Detailed package info
apt show htop

# List files installed by a package
dpkg -L nano

# Find which package owns a file
dpkg -S /usr/bin/nano

# Show package status
dpkg -s nano
```

---

## Practical Package Management

### How `apt` Works Under the Hood

1. **Repositories** — URLs where packages are stored (listed in `/etc/apt/sources.list`)
2. **`apt update`** — Downloads the package index from repositories
3. **`apt install`** — Downloads and installs `.deb` files + dependencies
4. **Dependencies** — Other packages required by the one you're installing (handled automatically)

### Repository Files

```bash
# Main source list
cat /etc/apt/sources.list

# Additional source lists
ls /etc/apt/sources.list.d/
```

### The Package Cache

```bash
# See how much space the cache uses (du: -s = summary, -h = human-readable)
du -sh /var/cache/apt/archives/

# Clean the package cache
sudo apt clean          # Remove all cached packages
sudo apt autoclean      # Remove only outdated cached packages
```

---

## `dpkg` — Low-Level Package Tool

`dpkg` works with individual `.deb` files directly (without dependency resolution).

```bash
# Install a .deb file
sudo dpkg -i package.deb

# List all installed packages
dpkg -l

# List files from a package
dpkg -L nano

# Check if a package is installed
dpkg -s nano

# Remove a package
sudo dpkg -r package-name
```

> Prefer `apt` over `dpkg` — it handles dependencies automatically.

---

## Common Packages to Explore

Here are some useful packages you can install to practice:

| Package | Description |
| ------- | ----------- |
| `cowsay` | Makes a cow say things in ASCII art |
| `figlet` | Create large text banners |
| `sl` | Steam locomotive (fun typo handler for `ls`) |
| `fortune` | Random quotes and jokes |
| `neofetch` | System info display |
| `tmux` | Terminal multiplexer |
| `nmap` | Network scanner |
| `jq` | JSON processor |
| `python3` | Python programming language |
| `build-essential` | Compiler and build tools |

---

## Hands-On Exercises

### Exercise 1: Update and Explore

```bash
# Update package lists
sudo apt update

# How many packages are upgradable?
apt list --upgradable

# How many packages are installed? (wc -l = count lines)
apt list --installed | wc -l
```

### Exercise 2: Install Packages

```bash
# Install some fun packages
sudo apt install -y cowsay figlet sl

# Try them out
cowsay "Linux is fun!"
figlet "Hello Linux"
sl        # Watch the train go by (Ctrl+C if impatient)

# Pipe fortune into cowsay (install fortune first)
sudo apt install -y fortune-mod
fortune | cowsay
```

### Exercise 3: Package Information

```bash
# Get info about a package
apt show cowsay

# Find where cowsay files are installed (dpkg -L = list files in a package)
dpkg -L cowsay

# Which package provides /usr/bin/nano? (dpkg -S = search for a file's owning package)
dpkg -S /usr/bin/nano
```

### Exercise 4: Remove Packages

```bash
# Remove cowsay (-y = auto-confirm without prompting)
sudo apt remove cowsay -y

# Verify it's gone
cowsay "test"    # Should fail: command not found

# Clean up (remove packages that were installed as dependencies but are no longer needed)
sudo apt autoremove -y
```

### Exercise 5: Search & Discover

```bash
# Search for a JSON tool (head -20 = show only the first 20 lines)
apt search json | head -20

# Search for packages related to networking (--names-only = match package names, not descriptions)
apt search --names-only network | head -20

# Search for Python packages
apt search python3 | head -20
```

---

## Challenge

1. Update the package database
2. Search for and install `jq` (a JSON processor)
3. Create a JSON file and use `jq` to parse it:

   ```bash
   echo '{"name":"Linux","version":24.04,"awesome":true}' > test.json
   ```

4. Use `jq` to extract just the name field
5. Find out which files `jq` installed on the system
6. Remove `jq` and clean up

<!-- markdownlint-disable MD033 -->
<details>
<summary>💡 Solution</summary>

```bash
# 1. Update
sudo apt update

# 2. Install jq
sudo apt install -y jq

# 3. Create JSON
echo '{"name":"Linux","version":24.04,"awesome":true}' > test.json

# 4. Extract name
jq '.name' test.json
# Output: "Linux"

jq -r '.name' test.json
# Output: Linux (without quotes)

# 5. List installed files
dpkg -L jq

# 6. Clean up
sudo apt purge -y jq
sudo apt autoremove -y
rm test.json
```

</details>
<!-- markdownlint-enable MD033 -->

---

**[← Lesson 06](06-process-management.md)** | **[Lesson 08 →](08-networking-basics.md)**
