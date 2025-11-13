#!/bin/bash
COCO_INSTALL_DIR=/opt/confidential-containers
function cleanup()
{
    echo "Cleanup stale files"
    sudo rm /etc/systemd/system/containerd.service.d/containerd-for-cc-override.conf 2>/dev/null
    if [[ $? -eq 0 ]]
    then
        sudo systemctl daemon-reload
        sudo systemctl restart containerd
    fi
    sudo rm -fr ${COCO_INSTALL_DIR} 2>/dev/null
}


#Not fully tested
kubectl delete -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
#kubectl delete -f https://docs.projectcalico.org/manifests/calico-typha.yaml

sudo kubeadm reset -f
#Kill k8s related process 
kube_pids=$(ps -ef | grep "kube-" | grep -v grep | awk '{print $2}' )
[[ ! -z $kube_pids ]] && sudo kill -9 $kube_pids

sudo apt-mark unhold kubelet kubeadm kubectl
sudo apt purge kubectl kubeadm kubelet kubernetes-cni -y
sudo apt autoremove -y
sudo rm -fr /etc/kubernetes/; sudo rm -fr ~/.kube/; sudo rm -fr /var/lib/etcd; sudo rm -rf /var/lib/cni/; sudo rm  -fr /etc/cni/net.d
sudo systemctl daemon-reload
sudo iptables -F && sudo iptables -t nat -F && sudo iptables -t mangle -F && sudo iptables -X
lscgroup | grep kubepods | wc -l

cleanup
