#!/bin/bash
# Source https://docs.docker.com/engine/install/ubuntu/

# Stop & remove containerd.io if running/installed
sudo systemctl stop containerd
sudo apt remove -y containerd.io 


# Stop  & remove docker if running/installed 
sudo systemctl stop docker.service
sudo systemctl stop docker.socket
sudo apt-get remove -y docker-ce docker-ce-cli docker-buildx-plugin docker-compose-plugin

sudo apt-get remove -y docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc
sudo apt autoremove
