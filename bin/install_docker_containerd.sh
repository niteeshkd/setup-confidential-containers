#!/bin/bash
# Source https://docs.docker.com/engine/install/ubuntu/

# Set up the repository
sudo apt-get update
sudo apt-get install -y ca-certificates curl

# Add docker GPG key
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

#curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor --batch --yes -o /etc/apt/keyrings/docker.gpg


# Add docker apt repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

#echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Fetch the package lists from docker repository
sudo apt-get update

# Install docker and containerd
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# If it fails, reinstall docker-ce
# sudo apt-get install -y docker-ce

# Verify the installation using hello-world image.
sudo docker run hello-world


# Comment out the line disabled_plugins = ["cri"] and restart containerd
grep cri /etc/containerd/config.toml >/dev/null
if [[ $? -eq 0 ]]
then
    echo "Modify /etc/containerd/config.toml "
    sudo cp /etc/containerd/config.toml /etc/containerd/config.toml.orig
    #sudo sed -i -e 's/disabled_plugins/#disabled_plugins/' /etc/containerd/config.toml
    sudo containerd config default > /tmp/config.toml 
    sudo cp /tmp/config.toml /etc/containerd/config.toml 
    sudo rm /tmp/config.toml
fi 
sudo systemctl daemon-reload
sudo systemctl restart containerd
