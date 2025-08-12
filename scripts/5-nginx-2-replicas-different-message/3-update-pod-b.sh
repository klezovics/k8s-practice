kubectl apply -f nginx-two-pods.yaml   # reapply updated ConfigMap
kubectl rollout restart deployment/nginx-b
