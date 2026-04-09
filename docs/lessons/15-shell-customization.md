# Lesson 15 — Environment and Shell Customization

> **Goal:** Customize your shell environment with aliases, variables, prompts, and startup files.

---

## Environment Variables

Environment variables are named values available to all programs in your session.

### Viewing Variables

```bash
# See all environment variables
env

# See a specific variable
echo $HOME
echo $USER
echo $PATH
echo $SHELL
```

### Important Variables

| Variable | Purpose | Example Value |
| -------- | ------- | ------------- |
| `$HOME` | Your home directory | `/home/student` |
| `$USER` | Current username | `student` |
| `$PATH` | Directories searched for commands | `/usr/bin:/bin:...` |
| `$SHELL` | Default shell | `/bin/bash` |
| `$PWD` | Current working directory | `/home/student` |
| `$EDITOR` | Default text editor | `nano` |
| `$LANG` | System locale | `en_US.UTF-8` |
| `$PS1` | Shell prompt format | (see below) |

### Setting Variables

```bash
# Set a variable (current shell only)
GREETING="Hello World"
echo $GREETING

# Export it so child processes can see it
export GREETING="Hello World"

# Set and export in one step
export EDITOR=nano

# Unset a variable
unset GREETING
```

### The Difference Between `VAR=x` and `export VAR=x`

```bash
# Without export — only visible in the current shell
SECRET="hidden"
bash -c 'echo "Secret: $SECRET"'    # -c = execute the following string as a command
# Output: Secret:    (empty — child shell cannot see it)

# With export — visible in child processes
export SECRET="visible"
bash -c 'echo "Secret: $SECRET"'
# Output: Secret: visible
```

---

## The `$PATH` Variable

`$PATH` is a colon-separated list of directories. When you type a command, the shell searches these directories in order.

```bash
# See your current PATH
echo $PATH

# Add a directory to PATH
export PATH="$HOME/scripts:$PATH"

# Now scripts in ~/scripts can be run by name
mkdir -p ~/scripts
echo '#!/bin/bash' > ~/scripts/hello
echo 'echo "Hello from my script!"' >> ~/scripts/hello
chmod +x ~/scripts/hello
hello
```

---

## Aliases

An alias is a shortcut for a longer command.

### Creating Aliases

```bash
# Create an alias
alias ll='ls -la'
alias cls='clear'
alias myip='hostname -I'
alias update='sudo apt update && sudo apt upgrade -y'

# Use it
ll
```

### Viewing and Removing Aliases

```bash
# See all current aliases
alias

# See a specific alias
alias ll

# Remove an alias
unalias ll

# Temporarily bypass an alias (use the real command)
\ls
```

### Useful Alias Ideas

```bash
# Safety nets — ask before overwriting (-i = interactive, prompt before overwriting)
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# Shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias h='history'
alias ports='ss -tlnp'       # ss: -t = TCP, -l = listening, -n = numeric, -p = process
alias dfh='df -h'             # df: -h = human-readable sizes
alias meminfo='free -h'       # free: -h = human-readable MB/GB

# Colorize output (--color=auto = color when outputting to terminal)
alias grep='grep --color=auto'
alias ls='ls --color=auto'
```

---

## Customizing the Prompt (`$PS1`)

The `$PS1` variable controls what your prompt looks like.

### Default Prompt

```text
student@ubuntu-lab:~$
```

This comes from: `\u@\h:\w\$`

### Prompt Escape Codes

| Code | Meaning |
| ---- | ------- |
| `\u` | Username |
| `\h` | Hostname (short) |
| `\H` | Hostname (full) |
| `\w` | Current directory (full path, `~` for home) |
| `\W` | Current directory (basename only) |
| `\d` | Date |
| `\t` | Time (24-hour HH:MM:SS) |
| `\T` | Time (12-hour HH:MM:SS) |
| `\n` | Newline |
| `\$` | `$` for regular users, `#` for root |

### Customizing

```bash
# Simple — just username and directory
export PS1="\u:\W\$ "

# With color (green user, blue directory)
export PS1="\[\033[32m\]\u\[\033[0m\]:\[\033[34m\]\w\[\033[0m\]\$ "

# With timestamp
export PS1="[\t] \u@\h:\w\$ "

# Two-line prompt
export PS1="\u@\h:\w\n\$ "
```

### Color Codes

Wrap color codes in `\[...\]` so Bash knows they are non-printing characters:

| Color | Code |
| ----- | ---- |
| Red | `\[\033[31m\]` |
| Green | `\[\033[32m\]` |
| Yellow | `\[\033[33m\]` |
| Blue | `\[\033[34m\]` |
| Purple | `\[\033[35m\]` |
| Cyan | `\[\033[36m\]` |
| Reset | `\[\033[0m\]` |

```bash
# Red username, cyan directory, reset at end
export PS1="\[\033[31m\]\u\[\033[0m\]@\h:\[\033[36m\]\w\[\033[0m\]\$ "
```

---

## Shell Startup Files

When Bash starts, it reads configuration files in a specific order.

### Login Shells vs Non-Login Shells

| Type | When | Reads |
| ---- | ---- | ----- |
| Login shell | SSH, `su -`, first terminal | `~/.bash_profile` then `~/.bashrc` |
| Non-login shell | New terminal tab, `bash` command | `~/.bashrc` only |

### Key Files

| File | Purpose |
| ---- | ------- |
| `/etc/profile` | System-wide settings for all users |
| `/etc/bash.bashrc` | System-wide Bash settings |
| `~/.bash_profile` | User login setup (often sources `.bashrc`) |
| `~/.bashrc` | User interactive shell configuration |
| `~/.bash_logout` | Runs when you log out |
| `~/.bash_aliases` | Alias definitions (sourced by `.bashrc` on Ubuntu) |

### The Most Important File: `~/.bashrc`

This is where you put your personal customizations:

```bash
# View yours
cat ~/.bashrc

# Edit it
nano ~/.bashrc
```

### Apply Changes Without Logging Out

After editing `.bashrc`, reload it:

```bash
source ~/.bashrc
# or the shorthand
. ~/.bashrc
```

---

## Building Your `.bashrc`

### Adding Aliases

```bash
# Open .bashrc
nano ~/.bashrc

# Add at the bottom:
# My custom aliases
alias ll='ls -la'
alias ..='cd ..'
alias cls='clear'
alias h='history | tail -20'
```

### Adding a Custom PATH

```bash
# Add to .bashrc:
export PATH="$HOME/scripts:$HOME/.local/bin:$PATH"
```

### Setting a Custom Prompt

```bash
# Add to .bashrc:
export PS1="[\t] \[\033[32m\]\u\[\033[0m\]@\h:\[\033[34m\]\w\[\033[0m\]\n\$ "
```

### Setting Default Editor

```bash
# Add to .bashrc:
export EDITOR=nano
export VISUAL=nano
```

### Custom Functions

You can define functions in `.bashrc` that work like commands:

```bash
# Add to .bashrc:

# Create a directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Quick backup of a file
backup() {
    cp "$1" "$1.bak.$(date +%Y%m%d)"    # date +%Y%m%d = format: YearMonthDay (e.g., 20260313)
}

# Extract any archive
extract() {
    case "$1" in
        *.tar.gz)  tar xzf "$1"   ;;    # x = extract, z = gzip, f = filename
        *.tar.bz2) tar xjf "$1"   ;;    # x = extract, j = bzip2, f = filename
        *.tar)     tar xf "$1"    ;;     # x = extract, f = filename
        *.zip)     unzip "$1"     ;;
        *.gz)      gunzip "$1"    ;;
        *)         echo "Unknown format: $1" ;;
    esac
}
```

---

## Exercises

1. Create an alias called `myinfo` that prints your username, hostname, and current date on one line.
2. Add `~/scripts` to your `$PATH`, create a simple script there, and run it by name from any directory.
3. Customize your prompt to show the time, username, and current directory in color.
4. Add your prompt and at least 3 aliases to `~/.bashrc`. Reload it and verify they work.
5. Write a shell function called `weather` that takes a city name and prints "The weather in CITY is..." (just the echo — we will not call an actual API).

---

## Challenge

Set up a complete personalized shell environment with:

1. A custom two-line color prompt showing time, user, host, and full path
2. At least 5 useful aliases
3. A custom `$PATH` that includes `~/bin`
4. The `mkcd`, `backup`, and `extract` functions from this lesson
5. A greeting message that prints when you open a new shell

All changes should persist (saved in `~/.bashrc`).

<!-- markdownlint-disable MD033 -->
<details>
<summary>💡 Solution</summary>

```bash
cat >> ~/.bashrc << 'ADDITIONS'

# === Custom Shell Environment ===

# Color prompt: [time] user@host:path (two-line)
export PS1="[\t] \[\033[32m\]\u\[\033[0m\]@\[\033[33m\]\h\[\033[0m\]:\[\033[34m\]\w\[\033[0m\]\n\$ "

# Custom PATH
export PATH="$HOME/bin:$HOME/scripts:$PATH"
mkdir -p ~/bin ~/scripts

# Aliases
alias ll='ls -la --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias cls='clear'
alias h='history | tail -20'
alias ports='ss -tlnp'
alias dfh='df -h'

# Functions
mkcd() { mkdir -p "$1" && cd "$1"; }

backup() { cp "$1" "$1.bak.$(date +%Y%m%d)"; }

extract() {
    case "$1" in
        *.tar.gz)  tar xzf "$1"   ;;
        *.tar.bz2) tar xjf "$1"   ;;
        *.tar)     tar xf "$1"    ;;
        *.zip)     unzip "$1"     ;;
        *.gz)      gunzip "$1"    ;;
        *)         echo "Unknown format: $1" ;;
    esac
}

# Greeting
echo "Welcome back, $USER! It is $(date '+%A, %B %d %Y at %H:%M')."
ADDITIONS

source ~/.bashrc
```

</details>
<!-- markdownlint-enable MD033 -->

---

**[← Lesson 14](14-regular-expressions.md)** | **[Lesson 16 →](16-ssh-remote-access.md)**
