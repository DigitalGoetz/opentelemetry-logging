# K8S
kind create cluster --name logging

# Cert Manager
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.11.0/cert-manager.yaml
kubectl wait --for=condition=available --timeout=600s deployment.apps/cert-manager -n cert-manager
kubectl wait --for=condition=available --timeout=600s deployment.apps/cert-manager-cainjector -n cert-manager
kubectl wait --for=condition=available --timeout=600s deployment.apps/cert-manager-webhook -n cert-manager
