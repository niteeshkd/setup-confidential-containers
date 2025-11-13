kind create cluster --image "kindest/node:v1.27.3" -n coco-sgx --config tests/e2e/enclave-cc-kind-config.yaml --wait 120s
kubectl label node coco-sgx-worker node.kubernetes.io/worker=
kubectl apply -k github.com/confidential-containers/operator/config/default
kubectl apply -k github.com/confidential-containers/operator/config/samples/enclave-cc/sim/
kubectl get runtimeclass
kubectl apply -f tests/e2e/enclave-cc-pod-sim.yaml
kubectl logs enclave-cc-pod-sim
