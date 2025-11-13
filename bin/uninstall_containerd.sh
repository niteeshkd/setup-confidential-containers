#!/bin/bash

# Stop & remove containerd.io if running/installed
sudo systemctl stop containerd
sudo apt purge containerd.io -y
sudo apt purge containerd -y
