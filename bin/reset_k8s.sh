#!/bin/bash
sudo rm -fr /opt/confidential-containers/*
sudo kubeadm reset -f

echo "Create Cluster"
echo "=========================================================================="
sudo kubeadm init --config kubeadm.conf
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

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
kubectl label node ${HOSTNAME} node.kubernetes.io/worker=
kubectl get nodes --show-labels
