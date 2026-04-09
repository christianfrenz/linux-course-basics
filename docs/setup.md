# Lab Setup

Download the files below, place them in a single folder, and follow the steps to get your Linux lab running.

---

## Prerequisites

| Tool | Minimum Version |
| --- | --- |
| Docker | 20.10+ |
| Docker Compose | v2+ (bundled with Docker Desktop) |

Install Docker Desktop from [docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop/).

---

## Download Lab Files

Create a project folder and save these three files into it:

1. **[Dockerfile](downloads/Dockerfile)** — builds the Ubuntu 24.04 lab image with all required packages
2. **[docker-compose.yml](downloads/docker-compose.yml)** — defines the lab container and shared folder
3. **[reset-lab.sh](downloads/reset-lab.sh)** — reset script to rebuild the lab from scratch

Also create an empty folder called `shared/` inside the same directory. Your folder should look like this:

```text
my-linux-lab/
├── Dockerfile
├── docker-compose.yml
├── reset-lab.sh
└── shared/
```

---

## Start the Lab

Open a terminal, navigate to your project folder, and run:

```bash
cd my-linux-lab
docker compose up -d --build
```

The first build takes a few minutes (it downloads Ubuntu and installs packages). Subsequent starts are instant.

---

## Enter the Lab

```bash
docker exec -it linux-lab bash
```

You should see:

```text
student@ubuntu-lab:~$
```

You are now inside an **Ubuntu 24.04** container logged in as the `student` user (password: `student`) with `sudo` privileges.

---

## Reset the Lab

Made a mess? Reset to a clean state in seconds:

```bash
chmod +x reset-lab.sh    # only needed once
./reset-lab.sh
```

This destroys the container and rebuilds it from scratch. Any files you saved to `~/shared/` inside the container are preserved (they live in the `shared/` folder on your host).

---

## Stop / Start the Lab

```bash
docker compose stop       # Pause (preserves state)
docker compose start      # Resume
docker compose down       # Destroy container
```

---

## Saving Your Work

Everything inside the container is **ephemeral** — it is lost when you reset. To keep files, copy them to the shared folder:

```bash
# Inside the container
cp ~/practice/my-script.sh ~/shared/
```

The `shared/` folder is mounted from your host computer. Files there survive container resets and are accessible from both sides.

---

Ready? Start with [Lesson 01 — Getting Started](lessons/01-getting-started.md).
