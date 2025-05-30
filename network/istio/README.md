# Istio Installation with Helm and Kustomize

This directory contains the configuration for installing Istio using Helm charts managed by Kustomize.

## Prerequisites

- Kubernetes cluster (1.27+)
- kubectl configured to access your cluster
- kustomize (or kubectl with kustomize support)

## Components

1. **Istio Base** - CRDs and cluster-wide resources
2. **Istiod** - The Istio control plane
3. **Istio Ingress Gateway** - Optional ingress gateway for external traffic

## Installation

```bash
# Build and apply the manifests
kustomize build --enable-helm . | kubectl apply -f -

# Or using kubectl (v1.14+)
kubectl apply -k . --enable-helm
```

## Verification

```bash
# Check if all pods are running
kubectl get pods -n istio-system

# Verify Istio is installed
kubectl get crd | grep istio

# Check the ingress gateway service
kubectl get svc -n istio-system
```

## Configuration Files

- `base-values.yaml` - Configuration for Istio base chart (CRDs)
- `istiod-values.yaml` - Configuration for Istio control plane
- `gateway-values.yaml` - Configuration for Istio ingress gateway

## Customization

To customize the installation, modify the values files:
- Adjust resource limits in `istiod-values.yaml`
- Configure gateway ports in `gateway-values.yaml`
- Enable/disable components as needed

## Uninstallation

```bash
# Remove Istio
kustomize build --enable-helm . | kubectl delete -f -

# Or using kubectl
kubectl delete -k . --enable-helm

# Remove namespace (if not needed)
kubectl delete namespace istio-system
```

## Integration with Knative

If you're using this with Knative, you may want to disable the Istio ingress gateway
and use Knative's networking layer instead. To do this:
1. Comment out the gateway chart in `kustomization.yaml`
2. Configure Knative to use Istio for internal networking only