#!/bin/bash
# Source: https://intel.github.io/intel-device-plugins-for-kubernetes/cmd/sgx_plugin/README.html

#echo "Uninstall epc-register --- It does not work"
#kubectl apply -k https://github.com/intel/intel-device-plugins-for-kubernetes/deployments/sgx_plugin/overlays/epc-register/

echo "Delete the SGX device plugin ---"
kubectl delete -k 'https://github.com/intel/intel-device-plugins-for-kubernetes/deployments/sgx_plugin/overlays/epc-nfd/'

#echo "Delete SGX admission webhook if cert-manager is used --- Sometime it is needed"
#kubectl apply -k https://github.com/intel/intel-device-plugins-for-kubernetes/deployments/sgx_admissionwebhook/overlays/default-with-certmanager/

echo "Delete the NodeFeatureRules and NFD ---"
kubectl delete -k 'https://github.com/intel/intel-device-plugins-for-kubernetes/deployments/nfd/overlays/node-feature-rules'
kubectl delete -k 'https://github.com/intel/intel-device-plugins-for-kubernetes/deployments/nfd'

echo "Delete cert-manager ---"
#kubectl delete -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.2/cert-manager.yaml
kubectl delete -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.3/cert-manager.yaml
