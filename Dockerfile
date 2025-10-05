# Use official Ubuntu 22.04 image
FROM ubuntu:22.04

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV container docker

# Install systemd and basic utilities
RUN apt-get update && apt-get install -y \
    systemd systemd-sysv dbus sudo curl wget git nano htop iproute2 net-tools \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Create necessary directories for systemd
RUN mkdir -p /run/systemd && \
    echo 'docker' > /etc/container_environment

# Create a non-root user (Railway runs as root otherwise)
RUN useradd -m -s /bin/bash railway && echo 'railway:railway' | chpasswd && adduser railway sudo

# Download ttyd (web terminal)
RUN wget https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.x86_64 \
    && chmod +x ttyd.x86_64 \
    && mv ttyd.x86_64 /usr/local/bin/ttyd

# Working directory
WORKDIR /home/railway

# Expose ttyd web terminal port
EXPOSE 8080

# Enable systemd services
VOLUME [ "/sys/fs/cgroup" ]

# Default command
CMD ["/usr/sbin/init"]
