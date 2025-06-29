# GPU Time-Slicing Configuration

This configuration enables GPU time-slicing on NVIDIA GPUs that don't support MIG (Multi-Instance GPU), allowing multiple pods to share a single GPU through time-based scheduling.

## Overview

- **GPU Model**: NVIDIA GeForce RTX 4070 Ti SUPER
- **Memory**: 16GB VRAM
- **Virtual GPUs**: 4 (configurable)
- **Sharing Method**: Time-slicing (no memory isolation)

## Configuration Details

The time-slicing configuration creates 4 virtual GPU instances from 1 physical GPU:
- Each pod requesting `nvidia.com/gpu: 1` gets exclusive access during its time slice
- All pods share the same 16GB GPU memory pool
- CUDA contexts are automatically switched between pods

## Deployment

### Apply the configuration:

```bash
# Apply GPU time-slicing configuration
kustomize build /home/tony/projects/cncflab/usecases/gpu-slicing --enable-helm | kubectl apply -f -

# Restart the device plugin to pick up the new configuration
kubectl rollout restart daemonset/nvidia-device-plugin-daemonset -n gpu-operator-resources
```

### Verify the configuration:

```bash
# Check if the node now reports 4 GPUs
kubectl get nodes -o json | jq '.items[].status.allocatable | ."nvidia.com/gpu"'

# Check device plugin logs
kubectl logs -n gpu-operator-resources -l app=nvidia-device-plugin-daemonset
```

## Usage Example

Create a test deployment that uses GPU resources:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: gpu-test
spec:
  replicas: 4  # Can run up to 4 replicas sharing the GPU
  selector:
    matchLabels:
      app: gpu-test
  template:
    metadata:
      labels:
        app: gpu-test
    spec:
      containers:
      - name: cuda-container
        image: nvcr.io/nvidia/cuda:12.6.1-base-ubuntu22.04
        command: ["sleep", "infinity"]
        resources:
          limits:
            nvidia.com/gpu: 1  # Each pod gets 1 virtual GPU
```

## Important Notes

1. **No Memory Isolation**: All pods share the 16GB GPU memory. Memory oversubscription can cause CUDA out-of-memory errors.

2. **Performance Impact**: Time-slicing adds context switching overhead. Performance depends on workload characteristics.

3. **Best Practices**:
   - Monitor GPU memory usage carefully
   - Use resource quotas to prevent oversubscription
   - Test workloads thoroughly before production use
   - Consider workload scheduling patterns

4. **Rollback**: To disable time-slicing:
   ```bash
   kubectl delete configmap time-slicing-config -n gpu-operator-resources
   kubectl patch clusterpolicy cluster-policy --type='json' -p='[{"op": "remove", "path": "/spec/devicePlugin/config"}]'
   kubectl rollout restart daemonset/nvidia-device-plugin-daemonset -n gpu-operator-resources
   ```

## Monitoring

Monitor GPU usage and performance:

```bash
# Check GPU utilization across all pods
kubectl exec -n gpu-operator-resources -it $(kubectl get pods -n gpu-operator-resources -l app=nvidia-dcgm-exporter -o name | head -1) -- nvidia-smi

# View DCGM metrics
kubectl port-forward -n gpu-operator-resources service/nvidia-dcgm-exporter 9400:9400
# Then access http://localhost:9400/metrics
```

## References

- [NVIDIA GPU Time-Slicing Documentation](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/gpu-sharing.html)
- [Kubernetes Device Plugin Configuration](https://github.com/NVIDIA/k8s-device-plugin#shared-access-to-gpus-with-cuda-time-slicing)