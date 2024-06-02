# cncflab

This is repo is created at education purpose. It contains the running example for every tool mentioned in [cncf landscape](https://landscape.cncf.io/guide#orchestration-management--api-gateway). 

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
## Project structure

#### 1. Use cases

This folder contains manifest of deployment for different application stacks. The example only using the interface following the standard like Open API spec (for REST API) or GraphQL spec to generate the mock server.
Some example include:
1. REST API micro service
2. SSO application
3. Single page webapp
4. Graphql micro services
5. Realtime streaming application


#### 2. Helms

This folder define the list of helm chart for each software mentioned in Roadmap. it showcase the installation in the Kubernetes cluster and example configuration

#### 3. Domain folder (APIGateway, ServiceMesh, ...)

These folder present for each domain mentioned in CNCF landscape. In each of domain contains the example usage of each software. Those can be documentation of getting start and running or the detail manifest of the software.