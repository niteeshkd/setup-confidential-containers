#!/bin/bash
#INSTALL_DIR=/opt/confidential-containers
INSTALL_DIR=/opt/kata
RELEASE_VERSION="v0.8.0"

function cleanup()
{
    echo "Cleanup stale files"
    sudo rm /etc/systemd/system/containerd.service.d/containerd-for-cc-override.conf 2>/dev/null
    if [[ $? -eq 0 ]]
    then
        sudo systemctl daemon-reload
        sudo systemctl restart containerd
    fi
    sudo rm -fr ${INSTALL_DIR} 2>/dev/null
}

cleanup

dt=$(date +%Y.%m%d)
echo "Deploy Operator"
kubectl apply -k "github.com/confidential-containers/operator/config/release?ref=${RELEASE_VERSION}"
sleep 5
kubectl get pods -n confidential-containers-system | grep -v STATUS | grep -v Running
while [[ $? != 1 ]]
do
    sleep 5
    kubectl get pods -n confidential-containers-system | grep -v STATUS | grep -v Running
done

exit

echo "Deploy ccruntimes"
# kubectl apply  -f https://raw.githubusercontent.com/confidential-containers/operator/main/config/samples/ccruntime.yaml 
# wget https://github.com/confidential-containers/operator/blob/main/config/samples/ccruntime/base/ccruntime.yaml
kubectl apply -k github.com/confidential-containers/operator/config/samples/ccruntime/default?ref=${RELEASE_VERSION}
sleep 10
kubectl get pods -n confidential-containers-system | grep -v STATUS | grep -v Running
while [[ $? != 1 ]]
do
    echo "Wait till all the pods are running..."
    sleep 10
    kubectl get pods -n confidential-containers-system | grep -v STATUS | grep -v Running
done

kubectl get pods -n confidential-containers-system
kubectl get runtimeclass
ls -l ${INSTALL_DIR}
