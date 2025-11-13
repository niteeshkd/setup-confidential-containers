#!/bin/bash
RELEASE_VERSION="v0.7.0"

kubectl get pods -n confidential-containers-system
echo "Uninstall ccruntime"
#kubectl delete  -f https://raw.githubusercontent.com/confidential-containers/operator/main/config/samples/ccruntime.yaml
kubectl delete -k github.com/confidential-containers/operator/config/samples/ccruntime/default?ref=${RELEASE_VERSION}
kubectl get pods -n confidential-containers-system
numRows=$(kubectl get pods -n confidential-containers-system | wc -l)
while [[ $numRows != 2 ]]
do
    sleep 10
    numRows=$(kubectl get pods -n confidential-containers-system | wc -l)
done
kubectl get pods -n confidential-containers-system
echo "Uninstall operator"
kubectl delete -k "github.com/confidential-containers/operator/config/release?ref=${RELEASE_VERSION}"
