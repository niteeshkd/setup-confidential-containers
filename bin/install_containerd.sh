#!/bin/bash
# Source https://docs.docker.com/engine/install/ubuntu/

# Stop & remove containerd.io if running/installed
sudo systemctl stop containerd
sudo apt purge containerd.io -y

# Set up the repository
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# Add docker GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor --batch --yes -o /etc/apt/keyrings/docker.gpg


# Add docker apt repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Fetch the package lists from docker repository
sudo apt-get update

# Install containerd
sudo apt-get install -y containerd

sudo cp /etc/containerd/config.toml /etc/containerd/config.toml.orig 2>/dev/null
sudo containerd config default > /tmp/config.toml 
sudo cp /tmp/config.toml /etc/containerd/config.toml 
sudo rm /tmp/config.toml

sudo systemctl daemon-reload
sudo systemctl restart containerd
