# cncflab

This is repo is created at education purpose. It contains the running example for every tool mentioned in [cncf landscape](https://landscape.cncf.io/guide#orchestration-management--api-gateway). 

## Getting started

### Prerequisite
These software need to be installed and well setup in local machine
- [Nix shell](https://nixos.org/download/#download-nix)
- [Direnv](https://direnv.net/)

### 1. Install software

Navigate to the repo folder, all software will be automatically installed by direnv and nix setup

```
~/p/dzungtr> cd cncflab/
direnv: loading ~/project/dzungtr/cncflab/.envrc
direnv: using nix
direnv: export <SOME env var>
```

List of softwares installed can be tracked in `default.nix` file. The lab uses `kind` as k8s cluster distribution to set up local easily. More information, you can reference here https://kind.sigs.k8s.io/

### 2. Start any applications

```shell
# To start the cluster with the set up you want:
tilt up -- <options>

# eg:

# default
tilt up
tilt up -- --cluser default # optional

# signoz as observability
tilt up -- --observability signoz

# Cilium run as primary network configuration
tilt up -- --cluster cni-disable --network cilium
```

![tilt up](./assets/tiltup.png)

## Project structure

#### 1. Use cases

This folder contains manifest of deployment for different application stacks. The example only using the interface following the standard like Open API spec (for REST API) or GraphQL spec to generate the mock server.
Some example include:
1. REST API micro service
2. SSO application
3. Single page webapp
4. Graphql micro services
5. Realtime streaming application


#### 2. Domain folder (APIGateway, ServiceMesh, ...)

These folder present for each domain mentioned in CNCF landscape. In each of domain contains the example usage of each software. Those can be documentation of getting start and running or the detail manifest of the software.

#### 3. Scripts

Predefined utitlity scripts