# Lesson 01 — Getting Started

> **Goal:** Understand what the shell is, run your first commands, and learn how to get help.

---

## Before You Begin — Connect to the Lab

Make sure your Docker container is running. Open a terminal **on your host machine** (not inside VS Code's integrated terminal if you prefer a separate window) and run:

```bash
docker exec -it linux-lab bash
```

If you see an error like *"No such container"*, the container is not running. Start it first:

```bash
cd /path/to/linux-course
docker compose up -d --build
```

Once connected you should see:

```text
student@ubuntu-lab:~$
```

You are now inside the Linux lab. Everything you type from this point runs inside the Ubuntu container — your host system is not affected. If anything goes wrong, exit and run `./reset-lab.sh` to get a fresh environment.

> **Saving Your Work:** Everything inside the container is lost when you reset.
> To keep files (scripts, notes), copy them to `~/shared/`:
>
> ```bash
> cp ~/practice/my-script.sh ~/shared/
> ```
>
> The `shared/` folder is mounted from your host computer, so files there
> survive resets and are accessible from both sides.

---

## What is the Shell?

The **shell** is a text-based interface to your operating system. You type commands, press Enter, and the shell executes them. The default shell on Ubuntu is **Bash** (Bourne Again Shell).

When you see a prompt like this:

```text
student@ubuntu-lab:~$
```

It tells you:

- `student` — your username
- `ubuntu-lab` — the hostname (machine name)
- `~` — your current directory (`~` means your home directory)
- `$` — you're a regular user (`#` would mean root)

---

## Your First Commands

### `whoami` — Who am I?

```bash
whoami
```

Output: `student`

### `hostname` — What machine am I on?

```bash
hostname
```

Output: `ubuntu-lab`

### `date` — What time is it?

```bash
date
```

Shows the current date and time.

### `uptime` — How long has the system been running?

```bash
uptime
```

### `echo` — Print text to the screen

```bash
echo "Hello, Linux!"
```

You can also use it with variables:

```bash
echo "My username is $(whoami)"
echo "Today is $(date)"
```

### `clear` — Clear the terminal screen

```bash
clear
```

Or press **Ctrl + L** as a shortcut.

---

## Getting Help

Almost every command has built-in documentation.

### `--help` flag

```bash
ls --help
```

Quick summary of a command's options.

> **Note:** Not every command supports `--help` the same way. For example,
> `echo --help` just prints `--help` as text because `echo` treats everything
> after it as a string to print. When `--help` does not work, use `man`
> instead.

### `man` — Manual pages

```bash
man ls
```

Opens the full manual. Navigate with:

- **Arrow keys** or **j/k** — scroll
- **q** — quit
- **/** — search (type a word, press Enter)
- **n** — next search result

### `whatis` — One-line description

```bash
whatis ls
whatis echo
```

### `which` — Where is a command located?

```bash
which bash
which ls
```

---

## The Command Structure

Commands follow this pattern:

```text
command [options] [arguments]
```

| Part | Example | Meaning |
| ------ | --------- | --------- |
| command | `ls` | The program to run |
| options | `-l -a` or `-la` | Modify behavior (flags) |
| arguments | `/home` | What the command acts on |

Example:

```bash
ls -la /home/student
```

This runs `ls` with options `-l` (long format) and `-a` (show hidden files) on the directory `/home/student`.

---

## Keyboard Shortcuts

| Shortcut | Action |
| ---------- | -------- |
| **Tab** | Auto-complete commands and file names |
| **Ctrl + C** | Cancel/stop the current command |
| **Ctrl + L** | Clear the screen |
| **Ctrl + A** | Jump to beginning of line |
| **Ctrl + E** | Jump to end of line |
| **Ctrl + R** | Search command history |
| **Up/Down arrows** | Browse previous commands |

### Try Tab Completion

```bash
# Type "who" then press Tab twice
who<TAB><TAB>
```

You'll see all commands starting with "who".

---

## Command History

Bash remembers your commands.

```bash
# Show recent command history
history

# Show last 10 commands
history 10

# Re-run the last command
!!

# Re-run command number 5 from history
!5
```

---

## Hands-On Exercises

1. **Run these commands and observe the output:**

   ```bash
   whoami
   hostname
   date
   uptime
   echo "I am learning Linux!"
   ```

2. **Get help for the `echo` command:**

   ```bash
   echo --help
   man echo
   whatis echo
   ```

3. **Explore tab completion:**
   - Type `dat` and press Tab — it should complete to `date`
   - Type `ls /home/s` and press Tab — it should complete to `ls /home/student`

4. **Try keyboard shortcuts:**
   - Type a long command, then use Ctrl+A and Ctrl+E to jump around
   - Press Ctrl+R, type "who" — it should find your `whoami` command

5. **Check your command history:**

   ```bash
   history
   ```

---

## Challenge

Write a single command using `echo` that prints:

```text
Hello! I am [your username] on [hostname]. Today is [date].
```

Use command substitution `$(command)` to fill in the blanks dynamically.

<!-- markdownlint-disable MD033 -->
<details>
<summary>💡 Hint</summary>

```bash
echo "Hello! I am $(whoami) on $(hostname). Today is $(date)."
```

</details>
<!-- markdownlint-enable MD033 -->

---

**Next:** [Lesson 02 — Navigating the Filesystem →](02-filesystem-navigation.md)
