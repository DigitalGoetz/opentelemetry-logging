#!/bin/bash

# K8S
kind create cluster --name logging

# Cert Manager
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.11.0/cert-manager.yaml
kubectl wait --for=condition=available --timeout=600s deployment.apps/cert-manager -n cert-manager
kubectl wait --for=condition=available --timeout=600s deployment.apps/cert-manager-cainjector -n cert-manager
kubectl wait --for=condition=available --timeout=600s deployment.apps/cert-manager-webhook -n cert-manager

# OpenTelemetry Operator

kubectl apply -f https://github.com/open-telemetry/opentelemetry-operator/releases/latest/download/opentelemetry-operator.yaml
kubectl wait --for=condition=available --timeout=600s deployment.apps/opentelemetry-operator-controller-manager -n opentelemetry-operator-system

# OpenTelemetry Collector

kubectl apply -f ./manifests/opentelemetry/ -n opentelemetry
kubectl wait --for=condition=available --timeout=600s deployment.apps/observability-collector -n opentelemetry

# Grafana Labs Helm Repo
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update


# Install Grafana
helm upgrade --install --values ./chart-values/grafana-overrides.yaml grafana grafana/grafana --namespace grafana --create-namespace
kubectl wait --for=condition=available --timeout=600s deployment.apps/grafana -n grafana
kubectl get secret --namespace grafana grafana -o jsonpath="{.data.admin-password}" | base64 --decode > grafana.pass


# Install Loki

# helm upgrade --install --values loki-distributed-overrides.yaml loki grafana/loki-distributed -n grafana-loki --create-namespace
helm upgrade --install  loki grafana/loki-distributed -n grafana-loki --create-namespace
kubectl wait --for=condition=available --timeout=600s deployment.apps/loki-loki-distributed-distributor -n grafana-loki
kubectl wait --for=condition=available --timeout=600s deployment.apps/loki-loki-distributed-gateway -n grafana-loki
kubectl wait --for=condition=available --timeout=600s deployment.apps/loki-loki-distributed-query-frontend -n grafana-loki
kubectl -n grafana-loki rollout status sts loki-loki-distributed-ingester
kubectl -n grafana-loki rollout status sts loki-loki-distributed-querier

# Install Promtail

helm upgrade --install --values ./chart-values/promtail-overrides.yaml promtail grafana/promtail -n grafana-loki
kubectl -n grafana-loki rollout status daemonset promtail


# Install a Dummy application
kubectl -n default apply -f ./manifests/dummy/deployment.yaml
kubectl wait --for=condition=available --timeout=600s deployment.apps/dummy-deployment -n default


