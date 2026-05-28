#!/bin/bash
# Comprehensive pod debugging script
# Usage: ./scripts/debug_pod.sh <pod-name> [namespace]

set -e

POD="${1}"
NAMESPACE="${2:-default}"

if [ -z "$POD" ]; then
    echo "Usage: ./scripts/debug_pod.sh <pod-name> [namespace]"
    echo ""
    echo "Available pods:"
    kubectl get pods -n "$NAMESPACE"
    exit 1
fi

echo "=========================================="
echo "Pod Debug Report: $POD"
echo "Namespace: $NAMESPACE"
echo "Timestamp: $(date -u)"
echo "=========================================="

echo ""
echo "--- POD STATUS ---"
kubectl get pod "$POD" -n "$NAMESPACE"

echo ""
echo "--- POD DESCRIPTION ---"
kubectl describe pod "$POD" -n "$NAMESPACE"

echo ""
echo "--- CURRENT LOGS (last 50 lines) ---"
kubectl logs "$POD" -n "$NAMESPACE" --tail=50 2>/dev/null || echo "No current logs available"

echo ""
echo "--- PREVIOUS CONTAINER LOGS ---"
kubectl logs "$POD" -n "$NAMESPACE" --previous --tail=50 2>/dev/null || echo "No previous logs available"

echo ""
echo "--- RESOURCE USAGE ---"
kubectl top pod "$POD" -n "$NAMESPACE" 2>/dev/null || echo "Metrics server not available"

echo ""
echo "--- EVENTS ---"
kubectl get events -n "$NAMESPACE" --field-selector involvedObject.name="$POD" --sort-by='.lastTimestamp'
