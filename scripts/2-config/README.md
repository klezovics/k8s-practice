# Object types
- ConfigMap → Non-sensitive key/values or config files.
- Secret → Sensitive data (base64-encoded); supports special types (tls, dockerconfigjson, etc.).

# Key fields
## ConfigMap
- metadata.name → Name.
- data → String key/value map.
- binaryData → Base64-encoded bytes.
- immutable → true/false (prevent updates).

## Secret
- metadata.name → Name.
- type → Opaque | kubernetes.io/tls | kubernetes.io/dockerconfigjson | kubernetes.io/basic-auth | kubernetes.io/ssh-auth | kubernetes.io/service-account-token.
- data → Base64-encoded key/value map.
- stringData → Plain strings (server-side encoded into data).
- immutable → true/false.

# Connections to other object types
## Pod
- Pod -> ConfigMap (all keys as env): spec.containers[].envFrom[].configMapRef.name
- Pod -> ConfigMap (single key env): spec.containers[].env[].valueFrom.configMapKeyRef.(name,key)
- Pod -> ConfigMap (files): spec.volumes[].configMap.name (+ items[].key,path)
- Pod -> Secret (all keys as env): spec.containers[].envFrom[].secretRef.name
- Pod -> Secret (single key env): spec.containers[].env[].valueFrom.secretKeyRef.(name,key)
- Pod -> Secret (files): spec.volumes[].secret.secretName (+ items, defaultMode)
- Pod -> ImagePullSecret: spec.imagePullSecrets[].name

## Deployment/StatefulSet/DaemonSet/Job/CronJob
- Controller -> Pod: same Pod fields via spec.template.

## ServiceAccount
- ServiceAccount -> ImagePullSecret: imagePullSecrets[].name

# CKA tasks
- Create a ConfigMap from literals/files and mount as env and as a volume.
- Create a Secret (Opaque) from literals/files; mount as env and as a volume.
- Create a TLS Secret from cert/key; use with Ingress.
- Create a Docker registry Secret (dockerconfigjson) and reference via imagePullSecrets.
- Use items[] to project specific keys and set file modes.
- Mark ConfigMap/Secret immutable; update by replacing and rolling Pods.
- Troubleshoot: verify env/volume injection and roll Pods to pick up changes.
