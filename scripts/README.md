# Baseline deploy loop

# 1) Build & push
docker build -t gcr.io/PROJ/app:v1 . && docker push gcr.io/PROJ/app:v1
# 2) Deploy
kubectl create deploy app --image=gcr.io/PROJ/app:v1
# 3) Stable name (Service)
kubectl expose deploy app --port=80 --target-port=8080
# 4) Route (Ingress)
# (apply a tiny ingress manifest mapping host/path → Service)
# 5) Scale policy (HPA)
kubectl autoscale deploy app --cpu-percent=50 --min=2 --max=10
# 6) Update
kubectl set image deploy/app app=gcr.io/PROJ/app:v2
# 7) Observe/rollback
kubectl rollout status deploy/app; kubectl rollout undo deploy/app

# Kubectl commands 
```
kubectl rollout status deploy/web          # watch progress
kubectl rollout history deploy/web         # list revisions
kubectl rollout undo deploy/web --to-revision=2
kubectl rollout pause deploy/web; kubectl rollout resume deploy/web
kubectl rollout restart deploy/web         # touches template → new rollout
```

# Doing rollouts
- kubectl rollout -> observe/control updates of Deployment-like objects -> status, history, pause/resume, undo, restart
- Rollout strategy -> how pods are replaced during a rollout
Strategies:
- RollingUpdate -> replace gradually
- Recreate -> delete all, then create new