# Notes
- Services and Ingresses are just named routers
- Service routes based on labels -> Map service name to pod
- Ingress routes based on input (host/path) and service name -> Map (host/path) to service name

# Object types
- Service → Stable virtual IP / DNS name that routes to one or more Pods (load-balancing, discovery).
- Ingress → HTTP/HTTPS routing at the cluster edge; maps external hosts/paths to Services, can terminate TLS.

# Key fields
## Pod (networking-related)
- metadata.name → Pod name.
- metadata.labels → Used by Services to select Pods.
- spec.containers[].ports → Container ports.
- spec.nodeName / nodeSelector / affinity → Pod placement (affects network locality).

## Service
- metadata.name → Service name (DNS name inside cluster).
- spec.selector → Labels to match Pods.
- spec.ports[].port → Service port.
- spec.ports[].targetPort → Pod container port.
- spec.type → ClusterIP (default), NodePort, LoadBalancer, ExternalName.
- spec.clusterIP → Internal virtual IP (auto-assigned unless set).
- spec.externalIPs → External IPs mapped to the Service.

## Ingress
- metadata.name → Ingress name.
- spec.rules[].host → Hostname to match.
- spec.rules[].http.paths[].path → Path to match.
- spec.rules[].http.paths[].backend.service.name → Target Service name.
- spec.rules[].http.paths[].backend.service.port.number → Target Service port.
- spec.tls → TLS settings (hosts, secretName).

# Connections to other object types
## Service
- Service -> Pod: spec.selector selects Pods to send traffic to.
## Ingress
- Ingress -> Service: spec.rules[].http.paths[].backend.service.name

# CKA tasks
- Create a Service to expose a Pod internally (ClusterIP).
- Create a Service to expose a Pod externally (NodePort).
- Create a LoadBalancer Service (if supported by the environment).
- Map a Service to a specific Pod using label selectors.
- Create an Ingress to route HTTP traffic to a Service.
- Configure Ingress TLS termination with a Secret.
- Test connectivity between Pods using Service DNS names.
- Restrict traffic with a NetworkPolicy (allow/deny).
- Verify Service and Ingress functionality using curl from within the cluster.
