K8S security = Principals (Users + SA) + Roles + Principal-to-Role bindings
K8S security also = Network policies(restrict comms) + Namespace security policies

# Realistics security config
- Assign some roles to users who manage/monitor the cluster.
- Lock down the pod comms with NetworkPolicies.

# Concepts
- Pod `securityContext` is basically the per-pod / per-container security settings bucket in Kubernetes.
- Pod Security Standard (PSS) → Determines how rooty a Pod can be.
- Pod Security Admission (PSA) → Determines max level of privilege pods can have in a specific namespace

# Object types
- ServiceAccount → Identity for Pods to access the API.
- Role → Namespaced RBAC permissions.
- ClusterRole → Cluster-wide/non-namespaced RBAC permissions.
- RoleBinding → Binds a Role/ClusterRole to subjects in a namespace.
- ClusterRoleBinding → Binds a ClusterRole to subjects cluster-wide.
- NetworkPolicy → L3/4 traffic policy for selected Pods.
- Namespace (Pod Security Admission) → Holds PSA labels that enforce pod security levels.

# Key fields
## ServiceAccount
- metadata.name → Name.
- automountServiceAccountToken → true/false.
- imagePullSecrets[].name → Registry creds.
- secrets[] → Auto-generated tokens (projected).

## Role / ClusterRole
- rules[].apiGroups → e.g., "", apps, batch.
- rules[].resources → e.g., pods, deployments.
- rules[].verbs → get, list, watch, create, update, delete, patch.
- rules[].resourceNames → Optional object names.
- rules[].nonResourceURLs → For ClusterRole (e.g., /healthz).
- aggregationRule → For aggregated ClusterRoles.

## RoleBinding / ClusterRoleBinding
- subjects[].kind/name/namespace → ServiceAccount/User/Group.
- roleRef.kind/name/apiGroup → Role or ClusterRole to bind.

## NetworkPolicy
- metadata.name → Name.
- spec.podSelector → Target Pods.
- spec.policyTypes → Ingress, Egress.
- spec.ingress[].from[].podSelector/namespaceSelector/ipBlock → Allowed sources.
- spec.ingress[].ports[].port/protocol → Allowed ports.
- spec.egress[].to[].podSelector/namespaceSelector/ipBlock → Allowed destinations.
- spec.egress[].ports[].port/protocol → Allowed ports.

## Namespace (Pod Security Admission)
- metadata.labels.pod-security.kubernetes.io/enforce → privileged|baseline|restricted.
- …/enforce-version → e.g., v1.30.
- …/warn, …/audit → Optional warn/audit levels.

## Pod/Container securityContext (spec fields, not objects)
- runAsNonRoot, runAsUser, runAsGroup, fsGroup.
- allowPrivilegeEscalation.
- capabilities.add/drop.
- readOnlyRootFilesystem.
- seccompProfile.type (RuntimeDefault|Localhost).
- seLinuxOptions (if applicable).

# Connections to other object types (forward references)
## Pod
- Pod -> ServiceAccount: spec.serviceAccountName (token auto-mounted unless disabled).
- Pod -> securityContext: spec.securityContext / containers[].securityContext.

## RoleBinding / ClusterRoleBinding
- RoleBinding -> Role/ClusterRole: roleRef.kind/name.
- *Binding* -> Subjects: subjects[].(kind,name,namespace).

## NetworkPolicy
- NetworkPolicy -> Pod: spec.podSelector selects targets.
- NetworkPolicy -> Peers: from/to via podSelector/namespaceSelector/ipBlock.

## Namespace (PSA)
- Namespace -> Pod admission: PSA labels enforce allowed security settings.

# CKA tasks
- Create a ServiceAccount and bind least-privilege access with Role + RoleBinding.
- Grant cluster-wide read with ClusterRole (view) + ClusterRoleBinding to a ServiceAccount.
- Disable token automount on a Pod/ServiceAccount; use projected token only if needed.
- Create a default-deny NetworkPolicy and an allow policy for specific Pods/ports.
- Run Pods as non-root: set runAsNonRoot, runAsUser, drop NET_RAW, readOnlyRootFilesystem, seccompProfile: RuntimeDefault.
- Set Namespace PSA to restricted via labels and deploy a compliant Pod.
- Verify permissions with `kubectl auth can-i` using the ServiceAccount.
