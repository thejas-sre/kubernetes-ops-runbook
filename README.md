# kubernetes-ops-runbook

Kubernetes operational runbook for deploying and operating trade-signal-api
on a Kubernetes cluster. Includes production-grade manifests, Helm charts,
and step-by-step troubleshooting guides for the most common failure modes.

---

## Problem Statement

Operating trade-signal-api on Kubernetes requires clear manifests, Helm charts,
and documented procedures for when things go wrong. On-call engineers need exact
diagnostic commands and remediation steps for common failure modes.
This runbook provides everything needed to deploy, operate, and debug the service.

---

## Architecture

    Developer runs deploy.sh
            |
            v
    Helm upgrade --install
            |
            v
    Kubernetes Deployment (2 replicas, RollingUpdate)
            |
            +---> Service (ClusterIP, port 80 -> 8000)
            |
            +---> HPA (scale 2-10 pods on CPU/memory)
            |
            +---> NetworkPolicy (least-privilege pod networking)
            |
            +---> ServiceAccount (no auto-mounted API token)

---

## How To Run

Prerequisites: minikube or any Kubernetes cluster, kubectl, Helm 3

Start minikube:

    minikube start

Deploy with Helm:

    ./scripts/deploy.sh

Rollback:

    ./scripts/rollback.sh

Debug a failing pod:

    ./scripts/debug_pod.sh <pod-name>

Apply raw manifests (without Helm):

    kubectl apply -f manifests/

---

## Failure Mode Runbooks

| Failure | Runbook | Common Cause |
|---|---|---|
| CrashLoopBackOff | runbooks/crashloopbackoff.md | Missing env var, bad image, failed probe |
| OOMKilled | runbooks/oomkilled.md | Memory limit too low, memory leak |
| Pending pod | runbooks/pending_pods.md | Insufficient cluster resources |
| High restart count | runbooks/resource_limits.md | Probe misconfiguration or OOM |

---

## CrashLoopBackOff Quick Reference

    kubectl get pods
    kubectl logs <pod> --previous
    kubectl describe pod <pod>
    kubectl exec <pod> -- env

Full diagnosis guide in runbooks/crashloopbackoff.md

---

## OOMKilled Quick Reference

    kubectl describe pod <pod> | grep -A 3 "Last State"
    kubectl top pod <pod>
    kubectl get pod <pod> -o jsonpath='{.spec.containers[0].resources.limits.memory}'

Full diagnosis guide in runbooks/oomkilled.md

---

## What This Project Demonstrates

- Production-grade Kubernetes manifests with resource limits and probes
- HorizontalPodAutoscaler for CPU and memory-based scaling
- NetworkPolicy enforcing least-privilege pod networking
- Dedicated ServiceAccount with no auto-mounted API token
- Helm chart with dev and staging value overrides
- Runbooks for CrashLoopBackOff, OOMKilled, and Pending pod diagnosis
- Exact kubectl commands for every diagnostic step

---

## Compliance Considerations

- NetworkPolicy enforces least-privilege networking — pods communicate only on defined paths
- ServiceAccount disables auto-mounted API credentials not needed by the application
- Resource limits on every pod prevent noisy-neighbour resource exhaustion
- All runbooks include timestamps in diagnosis steps for audit trail purposes

---

## Related Projects

| Project | Connection |
|---|---|
| trade-signal-api | The service these manifests deploy and operate |
| observability-stack | Monitors this service — alerts trigger runbook execution |
| release-validation-pipeline | Validates pod readiness before every release |
