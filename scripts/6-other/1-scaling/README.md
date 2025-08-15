# Notes
- A HPA can only target ONE Deployment/StatefulSet/ReplicaSet (spec.scaleTargetRef).

# Object types
- HorizontalPodAutoscaler (HPA) → Auto-scales Pod replicas based on metrics.
- VerticalPodAutoscaler (VPA, addon) → Recommends/sets Pod CPU/Memory requests/limits.
- Cluster Autoscaler (component) → Scales node count based on pending Pods.
- Manual scaling → Deployment/StatefulSet spec.replicas.

# Key fields
## HorizontalPodAutoscaler (autoscaling/v2)
- metadata.name → Name.
- spec.scaleTargetRef.(apiVersion,kind,name) → Target (Deployment/StatefulSet/ReplicaSet).
- spec.minReplicas / spec.maxReplicas → Bounds.
- spec.metrics[] → Metric specs:
    - type: Resource|Pods|Object|External
    - resource.name: cpu|memory (for type=Resource)
    - target.type: Utilization|Value|AverageValue
    - target.averageUtilization / averageValue / value → Thresholds.
- spec.behavior.scaleUp/scaleDown → Policies:
    - stabilizationWindowSeconds
    - selectPolicy: Max|Min|Disabled
    - policies[].type: Pods|Percent, value, periodSeconds.

## VerticalPodAutoscaler (addon CRD)
- metadata.name → Name.
- spec.targetRef → Target (Deployment/StatefulSet/etc.).
- spec.updatePolicy.updateMode → Off|Initial|Auto|Recreate.
- spec.resourcePolicy.containerPolicies[].minAllowed/maxAllowed → CPU/Memory bounds.
- status.recommendation.containerRecommendations[].target → Suggested requests/limits.

## Cluster Autoscaler (component, not an API object)
- Watches unschedulable Pods and scales node groups via cloud provider.
- Tuned via Deployment args (e.g., --balance-similar-node-groups, --expander).

## Deployment/StatefulSet (manual)
- spec.replicas → Desired Pod count.

# Connections to other object types (forward refs)
## HPA
- HPA -> Deployment/StatefulSet/ReplicaSet: spec.scaleTargetRef.
- HPA -> Metrics APIs: requires metrics-server (Resource); custom/external need adapters.

## VPA
- VPA -> Target workload: spec.targetRef.
- VPA -> Admission controller: mutates Pod requests on create (updateMode dependent).

## Cluster Autoscaler
- CA -> Node groups (cloud provider) based on pending Pods and scheduling signals.

# CKA tasks
- Manually scale a Deployment/StatefulSet (kubectl scale or edit spec.replicas).
- Create an HPA targeting 50% CPU with min/max bounds and verify scaling.
- Use custom HPA behavior (stabilizationWindowSeconds, policies) to control oscillations.
- Install/verify metrics-server so HPA has CPU/Memory metrics.
- Observe scaling under load and confirm Replica count changes.
