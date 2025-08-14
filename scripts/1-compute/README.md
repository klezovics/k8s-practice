# Object types
- Pod → Smallest deployable unit; one or more containers running together.
- ReplicaSet → Ensures a specified number of identical Pods are running.
- Deployment → Manages ReplicaSets and rolling updates for stateless apps.
- StatefulSet → Manages stateful Pods with stable identities and storage.
- DaemonSet → Ensures a copy of a Pod runs on all (or selected) nodes.
- Job → Runs Pods to completion (batch tasks).
- CronJob → Runs Jobs on a schedule.

# Key fields
## Pod
- metadata.name → Pod name.
- metadata.labels → Key-value pairs for selection.
- spec.containers[].name → Container name.
- spec.containers[].image → Container image.
- spec.containers[].ports → Container ports.
- spec.containers[].env → Environment variables.
- spec.volumes → Volumes available to containers.
- spec.nodeName / nodeSelector / affinity / tolerations → Pod placement.
- spec.restartPolicy → Always (default), OnFailure, Never.

## ReplicaSet
- metadata.name → ReplicaSet name.
- spec.replicas → Desired number of Pods.
- spec.selector → Labels to match Pods it manages.
- spec.template → Pod template.

## Deployment
- metadata.name → Deployment name.
- spec.replicas → Desired number of Pods.
- spec.selector → Labels to match Pods.
- spec.template → Pod template.
- spec.strategy → RollingUpdate or Recreate; maxUnavailable, maxSurge.

## StatefulSet
- metadata.name → StatefulSet name.
- spec.replicas → Desired number of Pods.
- spec.selector → Labels to match Pods.
- spec.template → Pod template.
- spec.serviceName → Headless Service for stable DNS.
- spec.volumeClaimTemplates → PVC templates for each Pod.
- spec.updateStrategy → RollingUpdate or OnDelete.

## DaemonSet
- metadata.name → DaemonSet name.
- spec.selector → Labels to match Pods.
- spec.template → Pod template.
- spec.updateStrategy → RollingUpdate or OnDelete.

## Job
- metadata.name → Job name.
- spec.template → Pod template.
- spec.completions → Total completions desired.
- spec.parallelism → How many Pods run at once.
- spec.backoffLimit → Retry count.

## CronJob
- metadata.name → CronJob name.
- spec.schedule → Cron format string.
- spec.jobTemplate → Job spec to run.
- spec.concurrencyPolicy → Allow, Forbid, Replace.
- spec.successfulJobsHistoryLimit / failedJobsHistoryLimit → History retention.

# Connections to other object types
## Deployment
- Deployment -> ReplicaSet: Manages ReplicaSets to match desired state.
## ReplicaSet
- ReplicaSet -> Pod: spec.template defines Pods to create.
## StatefulSet
- StatefulSet -> Pod: spec.template defines Pods to create.
- StatefulSet -> PVC: spec.volumeClaimTemplates create PVCs for each Pod.
## DaemonSet
- DaemonSet -> Pod: spec.template defines Pods to create.
## Job
- Job -> Pod: spec.template defines Pods to run.
## CronJob
- CronJob -> Job: Creates Jobs based on schedule.

# CKA tasks
- Create a Pod from a YAML manifest and verify it runs.
- Create a Deployment and scale it up/down.
- Perform a rolling update on a Deployment.
- Roll back a Deployment to a previous revision.
- Create a StatefulSet with stable Pod identities and PVCs.
- Create a DaemonSet that runs on all nodes.
- Create a Job to run a task to completion.
- Create a CronJob to run a task on a schedule.
- Use nodeSelector, affinity, and tolerations to control Pod placement.
- Troubleshoot Pods stuck in Pending/CrashLoopBackOff/ImagePullBackOff.
