#!/bin/bash
# Source https://docs.docker.com/engine/install/ubuntu/


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

# Install docker and containerd
sudo apt-get install -y docker-ce docker-ce-cli docker-buildx-plugin docker-compose-plugin

# If it fails, reinstall docker-ce
# sudo apt-get install -y docker-ce

# Verify the installation using hello-world image.
sudo docker run hello-world
