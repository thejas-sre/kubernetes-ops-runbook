# kubernetes-ops-runbook

Kubernetes operational runbook for deploying and operating trade-signal-api
on a Kubernetes cluster. Includes production-grade manifests, Helm charts,
and step-by-step troubleshooting guides for the most common failure modes.

## Status

> Work in progress — full implementation coming shortly.

## What This Project Demonstrates

- Kubernetes Deployments, Services, ConfigMaps with resource limits and probes
- HorizontalPodAutoscaler for CPU and memory-based scaling
- NetworkPolicy for least-privilege pod networking
- Helm chart with dev and staging value overrides
- Runbooks for CrashLoopBackOff, OOMKilled, and Pending pod diagnosis
- Exact kubectl commands for every diagnostic step

## Failure Modes Documented

- CrashLoopBackOff — missing env vars, failed probes, config errors
- OOMKilled — memory limit tuning, heap analysis
- Pending pods — resource pressure, node selector mismatches
- High restart count — liveness probe misconfiguration

## Stack

Kubernetes · Helm · Docker · minikube · kubectl · Python
