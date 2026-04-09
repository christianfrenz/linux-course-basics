# 🐧 Learn Linux — Ubuntu / Debian Docker Lab

A hands-on, step-by-step Linux tutorial running inside Docker so you can experiment freely without risk to your host system. Supports **Ubuntu 24.04** (default) and **Debian 12**. Break things, reset in seconds, and learn by doing.

---

## Prerequisites

| Tool | Minimum Version |
| -------- | ----------------- |
| Docker | 20.10+ |
| Docker Compose | v2+ (bundled with Docker Desktop) |

---

## Quick Start

```bash
# 1. Clone this repo (use the green "Code" button on GitHub for the URL)
git clone <repo-url>
cd <repo-folder>

# 2. (Optional) Switch to Debian — edit .env and uncomment the Debian lines
#    See "Choosing a Distribution" below for details.

# 3. Build and start the lab container
docker compose up -d --build

# 4. Enter the lab
docker exec -it linux-lab bash
```

You are now inside a Linux container (Ubuntu 24.04 by default) logged in as the `student` user (password: `student`). The user has `sudo` privileges.

---

## Choosing a Distribution

The lab defaults to **Ubuntu 24.04**. To use **Debian 12** instead, edit the `.env` file in the project root:

```dotenv
# Comment out the Ubuntu lines
# DISTRO=ubuntu
# BASE_IMAGE=ubuntu:24.04

# Uncomment the Debian lines
DISTRO=debian
BASE_IMAGE=debian:12
```

Then rebuild:

```bash
docker compose down
docker compose up -d --build
```

You can also override on the command line without editing `.env`:

```bash
DISTRO=debian BASE_IMAGE=debian:12 docker compose up -d --build
```

> **Note:** Both distributions use `apt` for package management, so all lessons work on either. The only difference is the base image and the shell prompt hostname (`ubuntu-lab` vs `debian-lab`).

---

## Connecting to the Lab

The Docker container runs in the background. To interact with it you open a **terminal on your host machine** and use `docker exec` to start a shell session inside the container.

### First Time

```bash
# Build the image and start the container in detached mode
docker compose up -d --build
```

This only needs to be run once (or after a reset). Once the container is running, connect with:

```bash
docker exec -it linux-lab bash
```

- `docker exec` — run a command inside a running container
- `-it` — interactive + allocate a pseudo-TTY (gives you a usable shell)
- `linux-lab` — the container name (defined in `docker-compose.yml`)
- `bash` — the shell to launch

You should see a prompt like:

```text
student@ubuntu-lab:~$    # Ubuntu (default)
student@debian-lab:~$    # Debian
```

That means you are inside the Linux lab and ready to follow the lessons.

### Opening Multiple Terminals

You can open as many connections as you like. Each one is independent:

```bash
# Terminal 1
docker exec -it linux-lab bash

# Terminal 2 (open a new host terminal tab/window first)
docker exec -it linux-lab bash
```

This is useful when one lesson asks you to run a long-running command in one terminal and observe it from another.

### Exiting the Container

To leave the container shell and return to your host:

```bash
exit
```

Or press **Ctrl + D**. The container keeps running in the background — your work is preserved until you destroy it.

### Checking Container Status

```bash
# Is the container running?
docker compose ps

# View container logs (useful if something goes wrong)
docker compose logs
```

### Reset Everything

Made a mess? No problem — reset to a clean state in seconds:

```bash
# From your HOST terminal (not inside the container)
chmod +x reset-lab.sh
./reset-lab.sh
```

### Stop / Start the Lab

```bash
docker compose stop       # Pause (preserves state)
docker compose start      # Resume
docker compose down       # Destroy container (rebuild with up -d --build)
```

### Shared Folder — Saving Your Work

Everything inside the container is **ephemeral** — when you run `./reset-lab.sh`, the container is destroyed and rebuilt from scratch. Any files you created (scripts, notes, practice work) are lost.

The `shared/` directory is the exception. It is a **bind mount** between your host and the container:

| Location | Path |
| --- | --- |
| Host (your computer) | `shared/` (in the project folder) |
| Container | `/home/student/shared/` |

Files in this folder exist on **both sides simultaneously**. They survive container resets.

To save your work from inside the container:

```bash
# Copy a script you want to keep
cp ~/practice/validate.sh ~/shared/

# Or work directly in the shared folder
cd ~/shared
nano my-notes.txt
```

To bring a file from your host into the container, drop it into the `shared/` folder on your computer — it will instantly appear at `~/shared/` inside the container.

---

## Lesson Plan

| # | Lesson | Topics |
| --- | -------- | -------- |
| 01 | [Getting Started](docs/lessons/01-getting-started.md) | First commands, getting help, the shell |
| 02 | [Navigating the Filesystem](docs/lessons/02-filesystem-navigation.md) | Paths, cd, ls, pwd, tree |
| 03 | [Files & Directories](docs/lessons/03-files-and-directories.md) | touch, mkdir, cp, mv, rm, find |
| 04 | [Viewing & Editing Files](docs/lessons/04-viewing-editing-files.md) | cat, less, head, tail, grep, nano, vim |
| 05 | [Permissions & Ownership](docs/lessons/05-permissions-ownership.md) | chmod, chown, chgrp, umask |
| 06 | [Process Management](docs/lessons/06-process-management.md) | ps, top, htop, kill, jobs, bg, fg |
| 07 | [Package Management](docs/lessons/07-package-management.md) | apt update, install, remove, search |
| 08 | [Networking Basics](docs/lessons/08-networking-basics.md) | ip, ping, curl, wget, ss, DNS |
| 09 | [Shell Scripting](docs/lessons/09-shell-scripting.md) | Variables, conditionals, loops, functions |
| 10 | [System Administration](docs/lessons/10-system-administration.md) | Users, services, cron, logs, disk |
| 11 | [Troubleshooting](docs/lessons/11-troubleshooting.md) | Common errors, diagnostics, fixes |
| 12 | [I/O Redirection & Pipes](docs/lessons/12-io-redirection-pipes.md) | stdin, stdout, stderr, pipes, tee, xargs |
| 13 | [Text Processing](docs/lessons/13-text-processing.md) | cut, sort, uniq, tr, sed, awk |
| 14 | [Regular Expressions](docs/lessons/14-regular-expressions.md) | Patterns, character classes, quantifiers, grep -E |
| 15 | [Shell Customization](docs/lessons/15-shell-customization.md) | .bashrc, aliases, PS1 prompt, PATH, functions |
| 16 | [SSH & Remote Access](docs/lessons/16-ssh-remote-access.md) | Keys, config, scp, rsync, tunnels |
| 17 | [Git Basics](docs/lessons/17-git-basics.md) | init, add, commit, branch, merge, remotes |
| 18 | [Docker Basics](docs/lessons/18-docker-basics.md) | Images, containers, Dockerfile, volumes, compose |
| 19 | [Login Auditing](docs/lessons/19-login-auditing.md) | last, lastb, who, auth logs, failed logins |
| 20 | [Useful CLI Tools](docs/lessons/20-useful-cli-tools.md) | tmux, fzf, tldr, ncdu, bat, tcpdump, iftop, nload |

Each lesson contains:

- **Concepts** — brief theory
- **Commands** — syntax and flags explained
- **Hands-on exercises** — practice inside the Docker lab
- **Challenge** — a mini-task to test your understanding

---

## Tips for Learning

1. **Type every command yourself** — don't copy-paste. Muscle memory matters.
2. **Use `man <command>`** or **`<command> --help`** to explore on your own.
3. **Break things on purpose** — that's what the reset script is for.
4. **Take notes** — save them in the `shared/` folder so they persist.

---

## Website (MkDocs)

The lessons are published as a website using [MkDocs Material](https://squidfunk.github.io/mkdocs-material/). The site is hosted on GitHub Pages.

### Setup (one-time)

```bash
# Create a virtual environment and install dependencies
python3 -m venv .venv
source .venv/bin/activate   # On Windows: .venv\Scripts\activate
pip install -r requirements.txt
```

### Preview locally

```bash
.venv/bin/mkdocs serve
```

Open <http://127.0.0.1:8000> in your browser. Changes to markdown files are reflected live.

### Deploy to GitHub Pages

```bash
.venv/bin/mkdocs gh-deploy
```

This builds the site and pushes it to the `gh-pages` branch.

A GitHub Actions workflow (`.github/workflows/deploy.yml`) also runs on every push to `main` to deploy automatically.

### Project structure

```text
mkdocs.yml          ← Site configuration (nav, theme, extensions)
requirements.txt    ← Python dependencies (mkdocs-material)
docs/
  index.md          ← Site landing page
  lessons/          ← All 18 lesson files
```

---

## License

This project is provided for educational purposes. Feel free to fork and adapt.
