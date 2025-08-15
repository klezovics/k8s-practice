# Useful HELM commands

helm version                                  # check client/server versions
helm repo add myrepo https://example.com/charts
helm repo update                              # refresh repo index
helm search repo nginx                        # find charts in added repos
helm show values myrepo/app > values.yaml     # get default values
helm create mychart                           # scaffold a new chart
helm lint .                                   # validate current chart
helm dependency update                        # pull subchart deps from Chart.yaml
helm template rel . -f values.yaml            # render manifests locally
helm install rel myrepo/app -n ns --create-namespace -f values.yaml --wait --atomic
helm upgrade rel myrepo/app -n ns -f values.yaml --set image.tag=v2 --install --wait --atomic
helm upgrade rel . -n ns -f values.yaml --reuse-values --wait --atomic
helm status rel -n ns                         # rollout status/notes
helm get values rel -n ns                     # show live values (incl. overrides)
helm get manifest rel -n ns                   # show live rendered manifests
helm history rel -n ns                        # list revisions
helm rollback rel <REV> -n ns                 # revert to a revision
helm test rel -n ns --logs                    # run chart tests
helm uninstall rel -n ns --keep-history       # delete release (keep history)
helm plugin install https://github.com/databus23/helm-diff
helm diff upgrade rel myrepo/app -n ns -f values.yaml  # preview changes
helm package . -u -d dist/                    # package chart (update deps) to dist/
helm registry login REGISTRY                  # OCI auth
helm push dist/mychart-<VER>.tgz oci://REGISTRY/helm   # push OCI
helm pull oci://REGISTRY/helm/mychart --version <VER> --untar
