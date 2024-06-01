# devopslab


### Cluster include these setup:
1. Microk8s as kubenertes engine
2. Argocd for gitops
3. Add 1 API service app


## Getting started

### 1. Installing Microk8s

Following the instruction in installing microk8s
https://ubuntu.com/tutorials/install-microk8s-on-mac-os


Verify successful install by running

```shell
microk8s status --wait-ready
```

### 2. Enable CoreDNS

```shell
microk8s enable dns
```

### 3. Start any applications

```shell
# start argocd
kubectl apply -k argocd
# start demo app
kubectl apply -k applications/guestbook
```