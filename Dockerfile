ARG BASE_IMAGE=ubuntu:24.04
FROM ${BASE_IMAGE}

ARG DISTRO=ubuntu

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Restore man pages and docs stripped from the minimal Docker image (Ubuntu only)
RUN if [ "$DISTRO" = "ubuntu" ]; then yes | unminimize; fi

# Enable universe repository (needed for mc and other tools)
RUN apt-get update && apt-get install -y software-properties-common \
    && add-apt-repository universe \
    && rm -rf /var/lib/apt/lists/*

# Update package lists and install essential tools for the course
RUN apt-get update && apt-get install -y \
    mc \
    bash-completion \
    curl \
    wget \
    file \
    nano \
    vim \
    less \
    man-db \
    manpages \
    tree \
    htop \
    net-tools \
    iputils-ping \
    iproute2 \
    dnsutils \
    traceroute \
    sudo \
    passwd \
    plocate \
    psmisc \
    rsync \
    cron \
    rsyslog \
    tar \
    gzip \
    zip \
    unzip \
    git \
    openssh-client \
    openssh-server \
    locales \
    && rm -rf /var/lib/apt/lists/*

# Generate locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en

# Include /usr/games in PATH so tools like cowsay and sl work
ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games"

# Create a student user with sudo privileges
RUN useradd -m -s /bin/bash student \
    && echo "student:student" | chpasswd \
    && usermod -aG sudo student

# Create practice directories with sample files for exercises
RUN mkdir -p /home/student/practice /home/student/exercises \
    && echo "Hello from ${DISTRO} Linux!" > /home/student/practice/welcome.txt \
    && echo "This is a sample log file.\nINFO: System started\nWARN: Low disk space\nERROR: Connection timeout\nINFO: User logged in\nERROR: File not found\nINFO: Process completed" > /home/student/practice/sample.log \
    && echo "apple\nbanana\ncherry\ndate\nelderberry\nfig\ngrape" > /home/student/practice/fruits.txt \
    && echo "#!/bin/bash\necho 'Hello from a script!'" > /home/student/practice/hello.sh \
    && chmod +x /home/student/practice/hello.sh \
    && chown -R student:student /home/student

# Set working directory
WORKDIR /home/student

# Switch to student user by default
USER student

# Default command
CMD ["/bin/bash"]
