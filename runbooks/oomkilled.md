# Runbook — OOMKilled

## What It Means
The container exceeded its memory limit and was killed by the Linux OOM killer.
The pod will restart and OOMKilled will appear in lastState.terminated.reason.

## Diagnosis Steps

Step 1 — Confirm OOMKilled:
    kubectl describe pod <pod-name> -n <namespace>
    Look for: Last State: Terminated, Reason: OOMKilled

Step 2 — Check current memory limit:
    kubectl get pod <pod-name> -o jsonpath='{.spec.containers[0].resources.limits.memory}'

Step 3 — Check memory usage before kill (if Prometheus available):
    Query: container_memory_working_set_bytes{pod="<pod-name>"}
    This shows memory trend leading up to the OOMKill

Step 4 — Check if this is a memory leak:
    kubectl top pod <pod-name> -n <namespace>
    If memory grows continuously without levelling off, it is a leak

Step 5 — Check application logs for memory-related errors:
    kubectl logs <pod-name> --previous -n <namespace> | grep -i "memory\|heap\|oom"

## Common Root Causes and Fixes

Memory limit too low:
    Symptom: OOMKilled immediately after moderate load
    Fix: Increase memory limit in values.yaml
        resources.limits.memory: "512Mi"
    Then: helm upgrade <release> helm/ -f helm/values.yaml

Memory leak in application:
    Symptom: Memory grows continuously, OOMKilled after hours of running
    Fix: Profile the application to find the leak, fix the code

Batch operation loading too much data:
    Symptom: OOMKilled during specific operations (batch lookups, large scans)
    Fix: Add pagination or streaming to the batch endpoint
    For Redis: replace HGETALL on large hashes with HSCAN + bounded batch sizes

## Immediate Mitigation

If you need the service running immediately while investigating:
    kubectl patch deployment trade-signal-api -p \
      '{"spec":{"template":{"spec":{"containers":[{"name":"trade-signal-api","resources":{"limits":{"memory":"512Mi"}}}]}}}}'
