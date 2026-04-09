# Lesson 05 — Permissions & Ownership

> **Goal:** Understand the Linux permission system and control who can read, write, and execute files.

---

## Understanding Permissions

Every file and directory in Linux has three sets of permissions for three categories of users:

### The Three Permission Types

| Symbol | Permission | For Files | For Directories |
| ------ | ---------- | --------- | --------------- |
| `r` | Read | View content | List contents |
| `w` | Write | Modify content | Add/delete files inside |
| `x` | Execute | Run as program | Enter (cd into) it |
| `-` | None | No permission | No permission |

### The Three User Categories

| Category | Symbol | Who |
| -------- | ------ | --- |
| **Owner** (user) | `u` | The file's owner |
| **Group** | `g` | Members of the file's group |
| **Others** | `o` | Everyone else |

### Reading Permission Strings

When you run `ls -l` (`-l` = long format showing permissions, owner, size, and date), you see something like:

```text
-rwxr-xr-- 1 student student 45 Mar 4 10:00 hello.sh
```

Breaking down `-rwxr-xr--`:

```text
-    rwx    r-x    r--
│    │      │      │
│    │      │      └── Others:  read only
│    │      └── Group:   read + execute
│    └── Owner:   read + write + execute
└── File type: - = regular file, d = directory, l = symlink
```

---

## Numeric (Octal) Permissions

Each permission has a numeric value:

| Permission | Value |
| ---------- | ----- |
| Read (r) | 4 |
| Write (w) | 2 |
| Execute (x) | 1 |
| None (-) | 0 |

Add up the values for each category:

| Numeric | Symbolic | Meaning |
| ------- | -------- | ------- |
| `7` | `rwx` | Read + Write + Execute (4+2+1) |
| `6` | `rw-` | Read + Write (4+2) |
| `5` | `r-x` | Read + Execute (4+1) |
| `4` | `r--` | Read only |
| `3` | `-wx` | Write + Execute (2+1) |
| `2` | `-w-` | Write only |
| `1` | `--x` | Execute only |
| `0` | `---` | No permissions |

**Common permission sets:**

| Numeric | Symbolic | Typical Use |
| ------- | -------- | ----------- |
| `755` | `rwxr-xr-x` | Executable files, directories |
| `644` | `rw-r--r--` | Regular files |
| `700` | `rwx------` | Private directories |
| `600` | `rw-------` | Private files (SSH keys) |
| `777` | `rwxrwxrwx` | Full access for everyone (risky!) |

---

## Changing Permissions

### `chmod` — Change File Mode

**Symbolic mode:**

```bash
# Add execute for owner
chmod u+x script.sh

# Remove write for group
chmod g-w file.txt

# Set exact permissions for others
chmod o=r file.txt

# Add read+execute for everyone
chmod a+rx script.sh

# Multiple changes at once
chmod u+x,g-w,o-r file.txt
```

**Numeric mode:**

```bash
# Owner: rwx, Group: r-x, Others: r-x
chmod 755 script.sh

# Owner: rw-, Group: r--, Others: r--
chmod 644 document.txt

# Owner: rwx, Group: ---, Others: ---
chmod 700 private-dir/

# Owner: rw-, Group: ---, Others: ---
chmod 600 secret.key
```

**Recursive — apply to directory and all contents:**

```bash
chmod -R 755 myproject/
```

---

## Ownership

### `chown` — Change Ownership

```bash
# Change owner (requires sudo)
sudo chown root file.txt

# Change owner and group
sudo chown root:admin file.txt

# Recursive
sudo chown -R student:student myproject/
```

### `chgrp` — Change Group

```bash
sudo chgrp admin file.txt
sudo chgrp -R admin myproject/
```

### Viewing Ownership

```bash
ls -l file.txt
# -rw-r--r-- 1 student student 26 Mar 4 10:00 file.txt
#               ↑owner  ↑group
```

---

## Understanding Users & Groups

```bash
# What groups am I in?
groups

# Detailed group membership (shows UID, GID, and all groups)
id

# View all users
cat /etc/passwd

# View all groups
cat /etc/group

# View just usernames (cut: -d: = colon delimiter, -f1 = first field)
cut -d: -f1 /etc/passwd
```

---

## The `sudo` Command

`sudo` lets authorized users run commands as root (superuser).

```bash
# Run a command as root
sudo ls /root

# Edit a system file
sudo nano /etc/hostname

# Switch to root user
sudo su -

# Run a command as a different user
sudo -u www-data whoami
```

**`student` has sudo access in our Docker lab.**

---

## Default Permissions: `umask`

`umask` sets default permissions for newly created files and directories.

```bash
# View current umask
umask

# Common default: 0022
# Files:       666 - 022 = 644 (rw-r--r--)
# Directories: 777 - 022 = 755 (rwxr-xr-x)

# Set a more restrictive umask
umask 077
# Files:       666 - 077 = 600 (rw-------)
# Directories: 777 - 077 = 700 (rwx------)

# Test it
touch umask-test.txt
ls -l umask-test.txt
```

---

## Special Permissions

| Permission | Numeric | Symbol | Purpose |
| --------- | ------- | ------ | ------- |
| **SUID** | 4000 | `s` on user | Run file as file's owner |
| **SGID** | 2000 | `s` on group | Run as group, inherit group in directories |
| **Sticky Bit** | 1000 | `t` on others | Only owner can delete files (used on /tmp) |

```bash
# See the sticky bit on /tmp (ls -ld: -l = long format, -d = show directory itself, not its contents)
ls -ld /tmp
# drwxrwxrwt — notice the 't' at the end

# Find SUID files (find: -perm -4000 = has SUID bit set; 2>/dev/null = hide permission errors)
find / -perm -4000 2>/dev/null
```

---

## Hands-On Exercises

### Exercise 1: Read Permissions

```bash
cd ~/practice

# Check current permissions (-l = long format, -a = show hidden files)
ls -la

# Check permissions on the hello.sh script (-l = long format with permissions)
ls -l hello.sh
```

### Exercise 2: Modify Permissions (Symbolic)

```bash
cd ~
echo "test content" > permtest.txt

# Check default permissions
ls -l permtest.txt

# Remove all permissions for group and others
chmod go-rwx permtest.txt
ls -l permtest.txt

# Add read for group
chmod g+r permtest.txt
ls -l permtest.txt

# Make it executable by owner
chmod u+x permtest.txt
ls -l permtest.txt
```

### Exercise 3: Modify Permissions (Numeric)

```bash
cd ~

# Create a script
echo '#!/bin/bash' > myscript.sh
echo 'echo "Running!"' >> myscript.sh

# Try to run it (will fail — no execute permission)
./myscript.sh

# Check permissions
ls -l myscript.sh

# Make it executable (755)
chmod 755 myscript.sh

# Now run it
./myscript.sh

# Make it private (700)
chmod 700 myscript.sh
ls -l myscript.sh
```

### Exercise 4: Ownership

```bash
# Check who owns your files (-l = long format, -a = include hidden)
ls -la ~/practice/

# Create a file and check ownership
touch /tmp/testfile.txt
ls -l /tmp/testfile.txt

# Change ownership to root (needs sudo; chown user:group file)
sudo chown root:root /tmp/testfile.txt
ls -l /tmp/testfile.txt

# Try to write to it (will fail — you're not root)
echo "test" > /tmp/testfile.txt

# Take it back
sudo chown student:student /tmp/testfile.txt
echo "test" > /tmp/testfile.txt    # Works now!
```

### Exercise 5: Understanding umask

```bash
# Check current umask
umask

# Create a file and directory with default umask
touch default-file.txt
mkdir default-dir
ls -l default-file.txt     # -l = long format; shows permissions
ls -ld default-dir          # -l = long format, -d = the directory itself

# Change umask to restrictive
umask 077

# Create new ones
touch private-file.txt
mkdir private-dir
ls -l private-file.txt
ls -ld private-dir

# Reset umask
umask 022

# Clean up
rm default-file.txt private-file.txt
rmdir default-dir private-dir
```

---

## Challenge

1. Create a directory `~/secret` with a file `classified.txt` inside
2. Set permissions so that:
   - **Only you** can enter the directory and read/write the file
   - **Nobody else** can even see what's inside the directory
3. Verify with `ls -la` that permissions are correct
4. Switch to root (`sudo su -`) and confirm root can still read it

<!-- markdownlint-disable MD033 -->
<details>
<summary>💡 Solution</summary>

```bash
# Create
mkdir ~/secret
echo "Top secret information" > ~/secret/classified.txt

# Set permissions
chmod 700 ~/secret
chmod 600 ~/secret/classified.txt

# Verify
ls -ld ~/secret
ls -l ~/secret/classified.txt

# Test as root
sudo cat ~/secret/classified.txt    # Works — root bypasses permissions
```

</details>
<!-- markdownlint-enable MD033 -->

---

**[← Lesson 04](04-viewing-editing-files.md)** | **[Lesson 06 →](06-process-management.md)**
