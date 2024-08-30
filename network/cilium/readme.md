# Cilium network


Cilium is a software powered by eBPF technology. A Cluster can use cilium as CNI controller and replace almost every network management tool need to installed in cluster:
- Service mesh
- API Gateway 
- Ingress/Gateway Controller
- Kube proxy
- Load balancer
- Observability collector


The manifest in this folder contains the example of using cilium for the above purpose (except kube proxy replacment). You can refer to the configuration avaiable in charts/values.yml to explore more configuation.
