#!/bin/bash
# Source: https://blog.radwell.codes/2021/05/provisioning-single-node-kubernetes-cluster-using-kubeadm-on-ubuntu-20-04/
#         https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
#         https://github.com/confidential-containers/operator/blob/main/docs/INSTALL.md

# Configure docker to use overlay2 storage and systemd
#sudo mkdir -p /etc/docker
#cat <<EOF | sudo tee /etc/docker/daemon.json
#{
#    "exec-opts": ["native.cgroupdriver=systemd"],
#    "log-driver": "json-file",
#    "log-opts": {"max-size": "100m"},
#    "storage-driver": "overlay2"
#}
#EOF

# Restart docker to load new configuration
sudo systemctl restart docker

# Add docker to start up programs
sudo systemctl enable docker

# Allow current user access to docker command line
sudo usermod -aG docker $USER

# Restart containerd
sudo systemctl daemon-reload
sudo systemctl restart containerd

# Add Kubernetes GPG key
#sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
#curl -fsSL  https://packages.cloud.google.com/apt/doc/apt-key.gpg|sudo gpg --dearmor --always-trust -o /etc/apt/trusted.gpg.d/k8s.gpg
sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor --yes -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Add Kubernetes apt repository
#echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
#echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Fetch package list
sudo apt-get update

echo "Install kubelet, kubeadm & kubectl"
echo "=========================================================================="
sudo apt-get install -y kubelet kubeadm kubectl
#sudo apt-get install -y kubelet=1.24.0-00 kubeadm=1.24.0-00 kubectl=1.24.0-00 
# Prevent them from being updated automatically
sudo apt-mark hold kubelet kubeadm kubectl

# Turn off swap
sudo swapoff -a

# Disable swap completely
sudo sed -i -e '/swap/d' /etc/fstab

echo "Create Cluster"
echo "=========================================================================="
# On Linux the default CRI socket for containerd is /run/containerd/containerd.sock
#sudo kubeadm init --pod-network-cidr=10.244.0.0/16
#sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --cri-socket unix:///run/containerd/containerd.sock
sudo kubeadm init --config kubeadm.conf
mkdir -p $HOME/.kube
sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "Install CNI plugin flannel/calcio"
#echo "=========================================================================="
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
#kubectl apply -f https://docs.projectcalico.org/manifests/calico-typha.yaml
#kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/master/manifests/calico-typha.yaml

kubectl get node | tail -1 | grep -q -w Ready
while [[ $? != 0 ]]
do
   echo "Wait for the node to be ready"
   sleep 10
   kubectl get node | tail -1 | grep -q -w Ready
done
kubectl get node

echo "Untaint the node"
echo "=========================================================================="
kubectl get nodes -o json | jq '.items[].spec.taints'

kubectl taint nodes --all node-role.kubernetes.io/control-plane-
kubectl taint nodes --all node-role.kubernetes.io/master-

kubectl get nodes -o json | jq '.items[].spec.taints'

#Label the node with 'worker' role
# https://github.com/confidential-containers/operator/issues/194
# Change node label to kubelet.kubernetes.io or node.kubernetes.io
#kubectl label node ${HOSTNAME} node-role.kubernetes.io/worker=
kubectl label node ${HOSTNAME} node.kubernetes.io/worker=
kubectl get nodes --show-labels
