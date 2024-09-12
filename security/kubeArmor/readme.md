# KubeArmor

### Motivation
When running a Kubernetes cluster, we have the need to enforce a strong security policy to workload running in the cluster. Ensuring least permissive access to files storage and protected endpoint in the cluster. 

### Getting started

Prepare your cluster with standard set up like file storage, CNI and CoreDNS. In this example, we will use `kind` to spin up a test cluster.

```shell
kind create create --confid k8s-distribution/kind/default.yml
```

Installing the Kubearmor into the cluster can be easily done by using helm chart. In this example, I create a kustomization folder for KubeArmor:

```yaml
# kustomization.yml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

namespace: kubearmor

helmCharts:
  - name: kubearmor-operator
    repo: https://kubearmor.github.io/charts
    releaseName: kubearmor-operator
    namespace: kubearmor
    includeCRDs: true
    version: v1.4.1
    valuesFile: value.yml
```

The values file will be
```yaml
# value.yml
# Tell kubearmor operator to install kubearmor controller and workload to cluster
autoDeploy: true

kubearmorConfig:
  # Allow karmor cli to logs the events for: process, network and file
  defaultVisibility: process,network,file
```

And then run:
```shell
kustomize build security/kubeArmor --enable-helm | kubectl apply -f -
```

In my example, you will encounter an error of CRD not installed yet. This is not a big problem. We will run the command once again later to create the KubeArmor policy.
After installation, we can verify by running:

```shell
kubectl get all -n kubearmor

NAME                                        READY   STATUS    RESTARTS   AGE
pod/kubearmor-bpf-containerd-98c2c-77svj    1/1     Running   0          6m31s
pod/kubearmor-bpf-containerd-98c2c-cltj5    1/1     Running   0          6m35s
pod/kubearmor-bpf-containerd-98c2c-lpq2d    1/1     Running   0          6m31s
pod/kubearmor-bpf-containerd-98c2c-thmhq    1/1     Running   0          6m35s
pod/kubearmor-controller-7dffb799cf-dtlpn   2/2     Running   0          6m23s
pod/kubearmor-operator-c47c4f75c-l58fs      1/1     Running   0          7m25s
pod/kubearmor-relay-8464877449-6rnwq        1/1     Running   0          7m5s

NAME                                           TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)     AGE
service/kubearmor                              ClusterIP   10.96.6.32      <none>        32767/TCP   7m5s
service/kubearmor-controller-metrics-service   ClusterIP   10.96.92.92     <none>        8443/TCP    7m5s
service/kubearmor-controller-webhook-service   ClusterIP   10.96.151.142   <none>        443/TCP     7m5s

NAME                                            DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR                                                                                                                                                                       AGE
daemonset.apps/kubearmor-bpf-containerd-98c2c   4         4         4       4            4           kubearmor.io/btf=yes,kubearmor.io/enforcer=bpf,kubearmor.io/runtime=containerd,kubearmor.io/seccomp=yes,kubearmor.io/socket=run_containerd_containerd.sock,kubernetes.io/os=linux   6m35s

NAME                                   READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/kubearmor-controller   1/1     1            1           7m5s
deployment.apps/kubearmor-operator     1/1     1            1           7m25s
deployment.apps/kubearmor-relay        1/1     1            1           7m5s

NAME                                              DESIRED   CURRENT   READY   AGE
replicaset.apps/kubearmor-controller-7dffb799cf   1         1         1       6m23s
replicaset.apps/kubearmor-controller-f65f7cdf5    0         0         0       7m5s
replicaset.apps/kubearmor-operator-c47c4f75c      1         1         1       7m25s
replicaset.apps/kubearmor-relay-8464877449        1         1         1       7m5s
```


Next step, we want to test out different policy feature provided by KubeArmor. To do this, we will spin up a pod playing at compromised workload

```shell
kustomize build usecases/malicious | kubectl apply -f -

kubectl get pods -n malicious

NAME            READY   STATUS              RESTARTS   AGE
pod/malicious   0/1     Running   0          2s
```

Now create a Cluster Policy in kubearmor namespace. This policy tell `kubearmor` to fire an alert when there is a process try to access folder `/var` or `/proc`

```yaml
apiVersion: security.kubearmor.com/v1
kind: KubeArmorClusterPolicy
metadata:
  name: restrict-file-access
  namespace: kubearmor
spec:
  tags: ["file", "process", "log"]
  message: "Alert! try to access restricted file"
  selector:
    matchExpressions:
      - key: namespace
        operator: NotIn
        values:
          - kube-system
  severity: 5
  file:
    matchDirectories:
      - dir: /var/
        recursive: true
      - dir: /proc/
        recursive: true
  action: Audit
```

In my cncflab example, you can rerun the command installation again to create the policy.
```shell
kustomize build security/kubeArmor --enable-helm | kubectl apply -f -
```

Open another terminal in the repo and run
```shell
karmor logs -n malicious --json --logFilter policy
```

Now we will monitor the events happen within namespace `malicious`. Let's perform some directory reading in `/proc` folder

```shell
ls /proc
```

In the terminal running the logs monitor, we should see something like:
```log
== Alert / 2024-09-12 13:13:43.592808 ==
ClusterName: default
HostName: cncflab-default-worker
NamespaceName: malicious
PodName: malicious
Labels: policy.network.restrict.ingress=true,policy.process.restrict=true,app.lang=golang,policy.files.restrict=true,policy.network.restrict.egress=true
ContainerName: malicious
ContainerID: fa84b37ac99d0627d0832a9ede627a8cd7c72d674890e6b9ecfec7a3c6f5bf63
ContainerImage: docker.io/library/golang:1.23.1-bullseye@sha256:45b43371f21ec51276118e6806a22cbb0bca087ddd54c491fdc7149be01035d5
Type: MatchedPolicy
PolicyName: restrict-file-access
Severity: 5
Message: Alert! try to access restricted file
Source: /bin/ls /proc
Resource: /proc
Operation: File
Action: Audit
Data: syscall=SYS_OPENAT fd=-100 flags=O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECT
Enforcer: eBPF Monitor
Result: Passed
ATags: [file process log]
Cwd: /go/
HostPID: 588338
HostPPID: 587776
Owner: map[Name:malicious Namespace:malicious Ref:Pod]
PID: 19
PPID: 10
ProcessName: /bin/ls
Tags: file,process,log
UID: 0
```

We can see that the KubeArmor has detected the activity event that violate the policy. A process in the container has try to listing all files in folder `/proc`. Here is the explaination of the alert in detail:

```yaml
# cluster's target
ClusterName: default
HostName: cncflab-default-worker
NamespaceName: malicious
PodName: malicious
Labels: policy.network.restrict.ingress=true,policy.process.restrict=true,app.lang=golang,policy.files.restrict=true,policy.network.restrict.egress=true
ContainerName: malicious

# policy detail
PolicyName: restrict-file-access
Severity: 5
Message: Alert! try to access restricted file
Resource: /proc
Operation: File
# Alerting but allow the action to performed, other value are: Allow,Audit,Block
Action: Audit 
Tags: file,process,log

# activity detail
Source: /bin/ls /proc
ProcessName: /bin/ls
---
```

With KubeArmor, we can create different type of policy to restrict our workload:
- Process: don't allow certain execution
- Network: resitrct ingress, egress
- File: prevent file access
- SYSCALL
- capability

We can enfore different security posture. Which mean, we can choose to allow by default of block by default. Beside, if we don't want to take risk of crashing a running application, we can choose action as `audit`. This will allow the policy to fire an alert only but still allow the suspicious action to be performed.

Fore more advance use case please visit: https://docs.kubearmor.io/kubearmor/use-cases/hardening_guide

### Further discussion

Integrate audit events with observability to create conprehensive security alerting and monitoring system via Kubearmor adaptor.

### Alternative solution
- Tetragon
- Falco


### refernce
Checkout my full set up in repo: https://github.com/dzungtr/cncflab