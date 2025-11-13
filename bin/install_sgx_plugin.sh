#!/bin/bash
# Sources: https://intel.github.io/intel-device-plugins-for-kubernetes/cmd/sgx_plugin/README.html
#         https://cert-manager.io/docs/installation/kubectl/

echo " Install cert-manager ---"
#kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.2/cert-manager.yaml
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.3/cert-manager.yaml
sleep 30 
kubectl get pods --namespace cert-manager

echo "Deploy NFD and the necessary NodeFeatureRules ---"
kubectl apply -k 'https://github.com/intel/intel-device-plugins-for-kubernetes/deployments/nfd'
kubectl apply -k 'https://github.com/intel/intel-device-plugins-for-kubernetes/deployments/nfd/overlays/node-feature-rules'

#echo " Install SGX admission webhook if cert-manager is used --- Sometime it is needed"
#kubectl apply -k https://github.com/intel/intel-device-plugins-for-kubernetes/deployments/sgx_admissionwebhook/overlays/default-with-certmanager/

echo "Deploy SGX plugin ---"
kubectl apply -k 'https://github.com/intel/intel-device-plugins-for-kubernetes/deployments/sgx_plugin/overlays/epc-nfd/'

#echo "Install epc-register --- It does not work"
#kubectl apply -k https://github.com/intel/intel-device-plugins-for-kubernetes/deployments/sgx_plugin/overlays/epc-register/

kubectl describe node ${HOSTNAME} | grep sgx.intel.com
