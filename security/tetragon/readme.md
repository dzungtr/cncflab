# Tetragon - eBPF-based Security Observability and Runtime Enforcement

> Tetragon is a flexible Kubernetes-aware security observability and runtime enforcement tool that applies policy and filtering directly with eBPF, allowing for reduced observation overhead, tracking of any process, and real-time enforcement of policies.


## Getting started

#### 1. Create kind cluster with mounted volume

```shell
kind create cluster --config k8s-distribution/kind/host-access.yml
# or
tilt up -- --cluster host-access
```

This create a kind cluster with a single node. In the node, the `/proc` folder from host machine is mounted into `/procHost` in node container. Tetragon later will watch this folder to exec eBPF program.

#### 2. Install Tetragon

```shell
kustomize build security/tetragon --enable-helm | kubectl apply -f -


serviceaccount/tetragon configured
serviceaccount/tetragon-operator-service-account configured
clusterrole.rbac.authorization.k8s.io/tetragon configured
clusterrole.rbac.authorization.k8s.io/tetragon-operator configured
clusterrolebinding.rbac.authorization.k8s.io/tetragon configured
clusterrolebinding.rbac.authorization.k8s.io/tetragon-operator-rolebinding configured
configmap/tetragon-config configured
configmap/tetragon-operator-config configured
service/tetragon configured
service/tetragon-operator-metrics configured
deployment.apps/tetragon-operator configured
daemonset.apps/tetragon configured
```

#### 3. Test different functionality by modifying values.yml

```yaml
tetragon:
  hostProcPath: /procHost
```

