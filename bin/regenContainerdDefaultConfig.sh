#!/bin/bash
sudo containerd config default > /tmp/config.toml 
sudo cp /tmp/config.toml /etc/containerd/config.toml 
sudo rm /tmp/config.toml

sudo systemctl daemon-reload
sudo systemctl restart containerd
