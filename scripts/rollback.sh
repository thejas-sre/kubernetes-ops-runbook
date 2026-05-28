#!/bin/bash
# Rollback trade-signal-api to previous Helm release
# Usage: ./scripts/rollback.sh [release-name] [namespace] [revision]

set -e

RELEASE="${1:-trade-signal-api}"
NAMESPACE="${2:-default}"
REVISION="${3:-0}"

echo "Rolling back $RELEASE in namespace $NAMESPACE"

if [ "$REVISION" -eq 0 ]; then
    echo "Rolling back to previous release..."
    helm rollback "$RELEASE" -n "$NAMESPACE" --wait
else
    echo "Rolling back to revision $REVISION..."
    helm rollback "$RELEASE" "$REVISION" -n "$NAMESPACE" --wait
fi

echo "Rollback complete. Checking pod status..."
kubectl get pods -n "$NAMESPACE" -l app=trade-signal-api

echo "Helm history:"
helm history "$RELEASE" -n "$NAMESPACE"
