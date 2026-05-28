# Runbook — CrashLoopBackOff

## What It Means
The container is starting, crashing, and being restarted repeatedly.
Kubernetes backs off restart attempts exponentially (10s, 20s, 40s, up to 5 minutes).

## Diagnosis Steps

Step 1 — Identify the failing pod:
    kubectl get pods -n <namespace>
    Look for STATUS = CrashLoopBackOff and high RESTARTS count

Step 2 — Read the crash logs:
    kubectl logs <pod-name> --previous -n <namespace>
    The --previous flag shows logs from the crashed container, not the current one

Step 3 — Describe the pod for events:
    kubectl describe pod <pod-name> -n <namespace>
    Read the Events section at the bottom — it shows exactly why it crashed

Step 4 — Check environment variables:
    kubectl exec <pod-name> -n <namespace> -- env
    Look for missing or incorrect values that the app depends on

Step 5 — Check if referenced secrets exist:
    kubectl get secrets -n <namespace>
    If a secret is missing the container will crash immediately on startup

Step 6 — Check if referenced ConfigMaps exist:
    kubectl get configmaps -n <namespace>

## Common Root Causes and Fixes

Missing environment variable:
    Symptom: App crashes with KeyError or missing config on startup
    Fix: Add missing value to ConfigMap or Secret, redeploy

Failed liveness probe:
    Symptom: Events show "Liveness probe failed" before restart
    Fix: Increase initialDelaySeconds or timeoutSeconds in probe config

Application error on startup:
    Symptom: Python traceback or import error in --previous logs
    Fix: Fix the code bug, rebuild image, redeploy

Wrong image:
    Symptom: Image pull error or wrong binary executing
    Fix: Verify image tag in deployment spec matches what was built

Secret not mounted:
    Symptom: File not found error for expected secret path
    Fix: Verify secretRef name matches the actual Secret name

## Fix and Redeploy

    helm upgrade <release-name> helm/ -f helm/values.yaml
