#!/bin/bash

# Namespaces
kubectl apply -f ./manifests/namespaces

# OpenTelemetry Operator
kubectl apply -f ./manifests/opentelemetry-operator/
kubectl wait --for=condition=available --timeout=600s deployment.apps/opentelemetry-operator-controller-manager -n opentelemetry-operator-system

# OpenTelemetry Collector
kubectl apply -f ./manifests/opentelemetry/ -n opentelemetry
kubectl wait --for=condition=available --timeout=600s deployment.apps/observability-collector -n opentelemetry

# Grafana Labs Helm Repo
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# Install Grafana
helm upgrade --install --values ./chart-values/grafana-overrides.yaml grafana grafana/grafana --namespace opentelemetry --create-namespace
kubectl wait --for=condition=available --timeout=600s deployment.apps/grafana -n opentelemetry
kubectl get secret --namespace opentelemetry grafana -o jsonpath="{.data.admin-password}" | base64 --decode > grafana.pass

# Install Loki

# helm upgrade --install --values loki-distributed-overrides.yaml loki grafana/loki-distributed -n grafana-loki --create-namespace
helm upgrade --install  loki grafana/loki-distributed -n opentelemetry --create-namespace
kubectl wait --for=condition=available --timeout=600s deployment.apps/loki-loki-distributed-distributor -n opentelemetry
kubectl wait --for=condition=available --timeout=600s deployment.apps/loki-loki-distributed-gateway -n opentelemetry
kubectl wait --for=condition=available --timeout=600s deployment.apps/loki-loki-distributed-query-frontend -n opentelemetry
kubectl -n opentelemetry rollout status sts loki-loki-distributed-ingester
kubectl -n opentelemetry rollout status sts loki-loki-distributed-querier

# Install Promtail
helm upgrade --install --values ./chart-values/promtail-overrides.yaml promtail grafana/promtail -n opentelemetry
kubectl -n opentelemetry rollout status daemonset promtail

# Install a Dummy application
kubectl -n opentelemetry-smoke apply -f ./manifests/dummy/deployment.yaml
kubectl wait --for=condition=available --timeout=600s deployment.apps/dummy-deployment -n opentelemetry-smoke


