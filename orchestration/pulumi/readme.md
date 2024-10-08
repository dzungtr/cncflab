# Pulumi

### Overview
Pulumi is an IaC stack. Distributed as both open source and Cloud solution. Pulumi offer engineer to write infrastructure code as familiar programming language like Typescript, Go, Python, ...

### Getting started

#### 1. installation

```shell
brew install pulumi/tap/pulumi
```

#### 2. Decide the state management approach

Pulumi need a backend for managing the resource generated by the stack. Metadata and name of resource is generated after the runned script. We need to design and make the decision for our backend before use Pulumi. More information can be found here https://www.pulumi.com/docs/pulumi-cloud/admin/self-hosted/

**Pulumi Cloud managed**

```shell
pulumi login
```

**Local file storage managed**

```shell
pulumi login file://$PWD
```

**Self hosted server managed**

```shell
pulumi login --endpoint
```

**S3 managed**

```shell
pulumi login s3://<bucket-name>
```

#### 3. Spin up the stack

```shell
# Start a new workspace with template aws eks
pulumi new aws-eks

# Run the stack
pulumi up

# destroy the stack
pulumi destroy
```

### Observation

#### Pros
- Pulumi offer a nice syntax to use. Remove the gap of learning a new IaC technology
- Pulumi offer both Cloud and Open source solution. Allow organization adopt but lock in to a vendor
- Cloud Provider support: Azure, AWS, Google
- Well build template. AWS EKS template create best pracitce network setup, remove overhead of configuration
- Many option for state management: S3, file storage, Selfhost, SaaS

#### Cons
- State management is critical
- Opt-in to SaaS by default