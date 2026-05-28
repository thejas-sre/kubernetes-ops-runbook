# Kubernetes Concepts Reference

## Core Objects Used In This Project

### Deployment
Manages a set of identical pods. Handles rolling updates and rollbacks.
Key fields: replicas, selector, strategy, template.

### Service
Provides a stable network endpoint for a set of pods.
ClusterIP: internal only. LoadBalancer: external access.

### ConfigMap
Stores non-sensitive configuration as key-value pairs.
Mounted as environment variables or files in pods.
Never store passwords or tokens here — use Secrets.

### HorizontalPodAutoscaler (HPA)
Automatically scales replica count based on CPU and memory metrics.
Requires metrics-server to be running in the cluster.

### NetworkPolicy
Controls which pods can communicate with each other.
Default Kubernetes behaviour allows all pod-to-pod communication.
NetworkPolicy implements least-privilege networking.

### ServiceAccount
Provides an identity for pods to authenticate with the Kubernetes API.
Setting automountServiceAccountToken: false prevents automatic mounting
of API credentials that the application does not need.

## Pod Lifecycle

    Pending -> ContainerCreating -> Running -> (Succeeded or Failed)

Pending: pod accepted but not yet scheduled or image not pulled
ContainerCreating: image pulled, container starting
Running: all containers running
CrashLoopBackOff: container crashing repeatedly
OOMKilled: container exceeded memory limit
Completed: job or init container finished successfully

## Key kubectl Commands

    kubectl get pods                          # list pods
    kubectl describe pod <name>               # full pod details and events
    kubectl logs <name>                       # current container logs
    kubectl logs <name> --previous            # logs from crashed container
    kubectl exec -it <name> -- /bin/sh        # shell into running container
    kubectl top pod                           # current resource usage
    kubectl get events --sort-by=.lastTimestamp  # cluster events by time
