# Lesson 03 — Files & Directories

> **Goal:** Create, copy, move, rename, and delete files and directories. Find files on the system.

---

## Creating Files

### `touch` — Create Empty Files (or Update Timestamps)

```bash
touch myfile.txt                    # Create a single file
touch file1.txt file2.txt file3.txt # Create multiple files
touch existing-file.txt             # Update its timestamp (doesn't erase content)
```

### Create Files with Content

```bash
# Using echo (overwrites)
echo "Hello World" > greeting.txt

# Using echo (appends)
echo "Another line" >> greeting.txt

# Using cat with heredoc
cat > notes.txt << EOF
Line one
Line two
Line three
EOF
```

**`>` vs `>>`:**

| Operator | Action |
| -------- | ------ |
| `>` | Overwrite (creates or replaces content) |
| `>>` | Append (adds to the end) |

---

## Creating Directories

### `mkdir` — Make Directories

```bash
mkdir projects                      # Create a single directory
mkdir dir1 dir2 dir3                # Create multiple directories
mkdir -p parent/child/grandchild    # Create nested directories (-p = parents)
```

Without `-p`, `mkdir parent/child/grandchild` would fail if `parent/` doesn't exist.

---

## Copying

### `cp` — Copy Files and Directories

```bash
# Copy a file
cp source.txt destination.txt

# Copy a file into a directory
cp myfile.txt projects/

# Copy with a new name
cp myfile.txt projects/renamed.txt

# Copy multiple files into a directory
cp file1.txt file2.txt projects/

# Copy a directory (must use -r for recursive)
cp -r projects/ projects-backup/

# Interactive mode — ask before overwriting
cp -i source.txt destination.txt

# Verbose mode — show what's being done
cp -v source.txt destination.txt
```

---

## Moving & Renaming

### `mv` — Move or Rename

```bash
# Rename a file
mv oldname.txt newname.txt

# Move a file to another directory
mv myfile.txt projects/

# Move and rename simultaneously
mv myfile.txt projects/renamed.txt

# Move a directory
mv projects/ /tmp/projects/

# Interactive mode
mv -i source.txt destination.txt
```

**Note:** `mv` works for both moving AND renaming. If the destination is in the same directory, it's a rename.

---

## Deleting

### `rm` — Remove Files

```bash
# Remove a file
rm unwanted.txt

# Remove multiple files
rm file1.txt file2.txt

# Interactive mode (confirm before each delete)
rm -i myfile.txt

# Force remove (no confirmation, no error for non-existing)
rm -f myfile.txt
```

### `rm -r` — Remove Directories (Recursive)

```bash
# Remove a directory and everything inside
rm -r projects/

# Force remove without prompts
rm -rf old-projects/
```

> ⚠️ **WARNING:** `rm -rf` is powerful and dangerous. There is no recycle bin in Linux. Deleted files are gone forever. Always double-check your command before pressing Enter. (Good thing we're inside Docker — you can always reset!)

### `rmdir` — Remove Empty Directories Only

```bash
rmdir empty-folder/    # Only works if the directory is empty
```

---

## Finding Files

### `find` — Search for Files and Directories

```bash
# Find files by name (case-sensitive)
find /home/student -name "welcome.txt"

# Find files by name (case-insensitive)
find /home/student -iname "WELCOME.TXT"

# Find all .txt files
find /home/student -name "*.txt"

# Find directories only
find /home/student -type d

# Find files only
find /home/student -type f

# Find files modified in the last 24 hours
find /home/student -mtime -1

# Find files larger than 1KB
find /home/student -size +1k

# Find and execute a command on results
find /home/student -name "*.txt" -exec cat {} \;

# Find empty files
find /home/student -empty
```

### `locate` — Fast File Search (uses a database)

```bash
# Update the database first (requires sudo)
sudo updatedb

# Search
locate welcome.txt
```

> `locate` is faster than `find` but uses a pre-built database that needs updating.

---

## Wildcards (Globbing)

Use wildcards to match multiple files:

| Pattern | Matches | Example |
| ------- | ------- | ------- |
| `*` | Any characters (zero or more) | `*.txt` → all .txt files |
| `?` | Any single character | `file?.txt` → file1.txt, fileA.txt |
| `[abc]` | Any one of a, b, or c | `file[123].txt` → file1.txt, file2.txt |
| `[0-9]` | Any digit | `log[0-9].txt` → log1.txt ... log9.txt |
| `[!abc]` | Any character except a, b, c | `file[!0-9].txt` → fileA.txt |

```bash
# List all .txt files in practice
ls ~/practice/*.txt

# List all files starting with 's'
ls ~/practice/s*

# Copy all text files somewhere
cp ~/practice/*.txt /tmp/
```

---

## Hands-On Exercises

### Exercise 1: Create a Project Structure

```bash
cd ~

# Create a project directory with subdirectories
mkdir -p myproject/{src,docs,tests,config}

# Verify with tree
tree myproject
```

### Exercise 2: Work with Files

```bash
cd ~/myproject

# Create files
echo "# My Project" > docs/README.md
echo "print('hello')" > src/main.py
echo "import unittest" > tests/test_main.py
touch config/settings.ini

# Verify
tree
```

### Exercise 3: Copy and Move

```bash
cd ~/myproject

# Copy the main file as a backup
cp src/main.py src/main.py.bak

# Copy entire src as a backup
cp -r src/ src-backup/

# Move the config file
mv config/settings.ini config/app.ini

# Verify
tree
```

### Exercise 4: Cleanup

```bash
cd ~/myproject

# Remove the backup file
rm src/main.py.bak

# Remove the backup directory
rm -r src-backup/

# Verify
tree
```

### Exercise 5: Find Practice

```bash
# Find all .txt files in your home directory (-name = match filename pattern)
find ~ -name "*.txt"

# Find all directories under home (-type d = directories only)
find ~ -type d

# Find all files modified today (-mtime 0 = modified within the last 24 hours)
find ~ -mtime 0

# Find all empty files (-type f = regular files only, -empty = zero-byte files)
find ~ -type f -empty
```

---

## Bonus: Midnight Commander (`mc`)

If you prefer a visual file manager over pure CLI commands, **Midnight Commander** is an excellent TUI (text-based user interface) tool — a direct descendant of the classic Norton Commander from MS-DOS days.

### Installation

`mc` is already pre-installed in the lab container. On other Ubuntu/Debian systems, install it with:

```bash
sudo apt install mc
```

!!! note
    `mc` is in the **universe** repository. If the install fails, enable it first: `sudo add-apt-repository universe && sudo apt update`

### Starting It

```bash
mc
```

This opens a **dual-panel** file manager in your terminal:

```text
┌──────────────────────┬──────────────────────┐
│ Left panel           │ Right panel          │
│ /home/student/       │ /home/student/docs/  │
│ > projects/          │   notes.txt          │
│   documents/         │   readme.md          │
│   file.txt           │                      │
├──────────────────────┴──────────────────────┤
│ 1Help 2Menu 3View 4Edit 5Copy 6Move 7Mkdir │
│ 8Del  9Menu 10Quit                          │
└─────────────────────────────────────────────┘
```

### Key Shortcuts

| Key | Action |
| --- | ------ |
| **Tab** | Switch between left and right panel |
| **F3** | View a file |
| **F4** | Edit a file |
| **F5** | Copy selected file(s) to the other panel |
| **F6** | Move/rename selected file(s) |
| **F7** | Create a new directory |
| **F8** | Delete selected file(s) |
| **F10** | Quit Midnight Commander |
| **Insert** | Select/deselect files |
| **Ctrl+O** | Toggle panels (show/hide the terminal below) |

!!! tip
    `mc` is especially useful when managing files on remote servers over SSH, where you don't have a graphical file manager available.

---

## Challenge

Create the following directory structure in a **single `mkdir` command**, then populate each file using `echo`:

```text
~/website/
├── css/
│   └── style.css
├── js/
│   └── app.js
├── images/
└── index.html
```

Then:

1. Copy `index.html` to `index.html.bak`
2. Move `index.html.bak` into a new `backups/` directory
3. Find all `.html` files under `~/website`

<!-- markdownlint-disable MD033 -->
<details>
<summary>💡 Solution</summary>

```bash
# Create structure
mkdir -p ~/website/{css,js,images,backups}

# Populate files
echo "body { margin: 0; }" > ~/website/css/style.css
echo "console.log('Hello');" > ~/website/js/app.js
echo "<html><body>Hello</body></html>" > ~/website/index.html

# Copy and move
cp ~/website/index.html ~/website/index.html.bak
mv ~/website/index.html.bak ~/website/backups/

# Find
find ~/website -name "*.html"
```

</details>
<!-- markdownlint-enable MD033 -->

---

**[← Lesson 02](02-filesystem-navigation.md)** | **[Lesson 04 →](04-viewing-editing-files.md)**
