# Template syntax
- Helm uses Go template syntax
- Provides roughly same functionality as programming language: variables, conditions, loops, functions, helpers like 'quote'/'nindent'

Inject values from `values.yaml`
```
replicas: {{ .Values.replicaCount }}
image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
```

Access metadata
```
name: {{ .Release.Name }}         # release name (e.g., "my-app")
namespace: {{ .Release.Namespace }}
chart: {{ .Chart.Name }}-{{ .Chart.Version }}
```

Use conditionals
```
{{- if .Values.enabled }}
# render this section
{{- end }}
```

Use loops
```
{{- range .Values.ports }}
- containerPort: {{ . }}
{{- end }}
```

Provide default values
```
{{ .Values.env | default "production" }}
```

Surrounds values with quotes
```
replicas: {{ .Values.replicaCount | quote }}
```

# Useful HELM commands

# Working with charts made by others
helm repo add myrepo https://example.com/charts
helm repo update                              # refresh repo index
helm search repo nginx                        # find charts in added repos
helm show values myrepo/app > values.yaml     # get default values

# Build chart
helm create mychart                           # scaffold a new chart
helm lint .                                   # validate current chart
helm dependency update                        # pull subchart deps from Chart.yaml
helm template rel . -f values.yaml            # render manifests locally

# Create, upgrade, rollback and delete (CURD)
helm diff upgrade rel myrepo/app -n ns -f values.yaml  # preview changes
helm install rel myrepo/app -n ns --create-namespace -f values.yaml --wait --atomic
helm upgrade rel myrepo/app -n ns -f values.yaml --set image.tag=v2 --install --wait --atomic
helm upgrade rel . -n ns -f values.yaml --reuse-values --wait --atomic
helm status rel -n ns                         # rollout status/notes
helm get values rel -n ns                     # show live values (incl. overrides)
helm get manifest rel -n ns                   # show live rendered manifests
helm history rel -n ns                        # list revisions
helm rollback rel <REV> -n ns                 # revert to a revision
helm uninstall rel -n ns --keep-history       # delete release (keep history)

# Package and publish
helm package . -u -d dist/                    # package chart (update deps) to dist/
helm registry login REGISTRY                  # OCI auth
helm push dist/mychart-<VER>.tgz oci://REGISTRY/helm   # push OCI
helm pull oci://REGISTRY/helm/mychart --version <VER> --untar

# Misc 
helm version                                  # check client/server versions
helm test rel -n ns --logs                    # run chart tests
helm plugin install https://github.com/databus23/helm-diff
