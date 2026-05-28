# Guide — Setting Resource Requests and Limits

## Why Resource Limits Matter

Without limits, one pod can consume all node CPU and memory,
starving other pods. Without requests, the scheduler cannot
make informed placement decisions.

## The Difference Between Requests and Limits

Requests: what the scheduler uses for placement decisions.
The pod is guaranteed this amount.

Limits: the maximum the container can use.
Exceeding the memory limit causes OOMKilled.
Exceeding the CPU limit causes throttling (not killed).

## How To Set Initial Values

Step 1 — Deploy without limits first (dev only):
    Run the service under realistic load for 30 minutes

Step 2 — Observe actual usage:
    kubectl top pod -l app=trade-signal-api

Step 3 — Set requests to observed average usage
Step 4 — Set limits to 2x the observed peak usage

## trade-signal-api Recommended Values

Baseline (low traffic):
    requests: memory 128Mi, cpu 100m
    limits: memory 256Mi, cpu 500m

Medium traffic:
    requests: memory 256Mi, cpu 200m
    limits: memory 512Mi, cpu 1000m

## How To Update Without Downtime

    kubectl set resources deployment trade-signal-api \
      --requests=memory=256Mi,cpu=200m \
      --limits=memory=512Mi,cpu=1000m

Or update values.yaml and upgrade via Helm:
    helm upgrade trade-signal-api helm/ -f helm/values.yaml
