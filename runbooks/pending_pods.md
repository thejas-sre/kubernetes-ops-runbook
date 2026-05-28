# Runbook — Pending Pods

## What It Means
The pod has been accepted by the cluster but cannot be scheduled onto a node.
It will stay in Pending state until the scheduling constraint is resolved.

## Diagnosis Steps

Step 1 — Confirm pod is Pending:
    kubectl get pods -n <namespace>
    Look for STATUS = Pending

Step 2 — Read the scheduling events:
    kubectl describe pod <pod-name> -n <namespace>
    Read the Events section — it will say exactly why scheduling failed

Step 3 — Check node resource availability:
    kubectl describe nodes | grep -A 5 "Allocated resources"
    Look for nodes where CPU or memory requests are near 100%

Step 4 — Check if any nodes exist:
    kubectl get nodes
    If no nodes are Ready, the cluster itself has a problem

## Common Root Causes and Fixes

Insufficient CPU or memory on all nodes:
    Symptom: Events say "0/N nodes are available: insufficient memory"
    Fix option 1: Reduce resource requests in values.yaml
    Fix option 2: Add more nodes to the cluster

Node selector or affinity mismatch:
    Symptom: Events say "0/N nodes matched node selector"
    Fix: Remove or correct the nodeSelector in the deployment spec

PersistentVolumeClaim not bound:
    Symptom: Events say "persistentvolumeclaim not found" or "unbound"
    Fix: Check PVC status with kubectl get pvc -n <namespace>

Taints and tolerations mismatch:
    Symptom: Events say "N nodes had taint that the pod did not tolerate"
    Fix: Add appropriate tolerations to the pod spec or remove the taint
