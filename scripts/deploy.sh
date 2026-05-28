#!/bin/bash
# Deploy or upgrade trade-signal-api via Helm
# Usage: ./scripts/deploy.sh [release-name] [namespace] [values-file]

set -e

RELEASE="${1:-trade-signal-api}"
NAMESPACE="${2:-default}"
VALUES="${3:-helm/values.yaml}"

echo "Deploying $RELEASE to namespace $NAMESPACE using $VALUES"

kubectl get namespace "$NAMESPACE" 2>/dev/null || kubectl create namespace "$NAMESPACE"

helm upgrade --install "$RELEASE" helm/ \
  --namespace "$NAMESPACE" \
  --values "$VALUES" \
  --wait \
  --timeout 5m \
  --atomic

echo "Deployment complete. Checking pod status..."
kubectl get pods -n "$NAMESPACE" -l app=trade-signal-api
