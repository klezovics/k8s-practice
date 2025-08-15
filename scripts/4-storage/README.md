# Object types
- PersistentVolume -> virtual disk
- PersistentVolumeClaim -> request for storage
- StorageClass -> provisions storage based on PVC -> PV factory

# Key fields
## PersistentVolume
- metadata.name → Unique PV name.
- spec.capacity.storage → Size (e.g., 10Gi).
- spec.accessModes → Allowed modes: ReadWriteOnce (RWO), ReadOnlyMany (ROX), ReadWriteMany (RWX), ReadWriteOncePod (RWOP).
- spec.persistentVolumeReclaimPolicy → What happens when PVC is released (Retain, Recycle [deprecated], Delete).
- spec.storageClassName → Storage class this PV belongs to.
- spec.volumeMode → Filesystem (default) or Block.
- spec.nodeAffinity → Node scheduling constraints.
- spec.mountOptions → Mount flags (e.g., noatime).
- spec.csi / spec.hostPath / spec.nfs / ... → Backend volume source details.

## PersistentVolumeClaim
- metadata.name → PVC name.
- spec.accessModes → Requested access mode(s): ReadWriteOnce, ReadOnlyMany, ReadWriteMany, ReadWriteOncePod.
- spec.resources.requests.storage → Requested storage size (e.g., 10Gi).
- spec.storageClassName → Storage class to use (or "" for no class).
- spec.volumeMode → Filesystem (default) or Block.
- spec.selector → Label selector to match a specific PV.
- spec.volumeName → Bind to a specific PV by name.

## StorageClass
- metadata.name → StorageClass name (referenced by PVCs).
- provisioner → Name of the CSI or in-tree volume plugin (e.g., kubernetes.io/aws-ebs, csi.gce-pd).
- parameters → Key/value options for the provisioner (e.g., type: gp2 for AWS EBS).
- reclaimPolicy → Retain or Delete after PVC is released.
- volumeBindingMode → Immediate (default) or WaitForFirstConsumer.
- allowVolumeExpansion → true/false for resizing.
- mountOptions → List of mount flags (e.g., noatime).


# Connections to other object types
## PV
- PV -> PVC: spec.claimRef (auto-set by k8s on bind)
- PV -> StorageClass: spec.storageClassName

## PVC
- PVC -> StorageClass: spec.storageClassName
- PVC -> PV: spec.volumeName (optional; usually auto-set on bind)

## Pod
- Pod -> PVC: spec.volumes[].persistentVolumeClaim.claimName (same namespace)

## StorageClass
- Doesn’t reference others; PVCs/PVs reference it.

# PVC access modes — MMM: Who can mount the volume, and how.
- RWO (ReadWriteOnce): One node can mount read-write. Many pods on that same node can use it.
- ROX (ReadOnlyMany): Many nodes, but read-only.
- RWX (ReadWriteMany): Many nodes, read-write (needs shared FS like NFS/EFS/CephFS).
- RWO-Pod (ReadWriteOncePod): Exactly one pod in the whole cluster may mount read-write (stricter than RWO).

# CKA tasks
- Create a PersistentVolume (static provisioning).
- Create a PersistentVolumeClaim that binds to an existing PV.
- Mount a PVC into a Pod and verify persistence.
- Create a StorageClass for dynamic provisioning.
- Create a PVC that uses a StorageClass (dynamic provisioning).
- Resize a PVC (when allowVolumeExpansion: true).
- Change persistentVolumeReclaimPolicy on an existing PV.
- Use spec.selector on PVC to bind to a specific PV by label.
- Manually bind a PVC to a PV using spec.volumeName.
- Create a Pod that uses a block volume (spec.volumeMode: Block).
- Use nodeAffinity in a PV to restrict which nodes can use it.
- Verify PV/PVC status and troubleshoot binding issues.
