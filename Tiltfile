print("""
Welcome to cncf

""")


config.define_string("cluster", args=False)
config.define_string("network", args=False)
config.define_string("observability", args=False)
config.define_string("cicd", args=False)
config.define_string("orchestration", args=False)
config.define_string("storage", args=False)
config.define_string("llm", args=False)
cfg = config.parse()

# cluster bootstrap
# one of default, cni-disable
cluster = cfg.get("cluster", "default")
CLUSTER_CONTEXT = "kind-cncflab-" + cluster
os.putenv("CLUSTER_CONFIG" , "k8s-distribution/kind/" + cluster + ".yml")
os.putenv("CLUSTER_CONTEXT" , CLUSTER_CONTEXT)
output = local("scripts/create-cluster.sh")

print("CLUSTER_CONTEXT: " + CLUSTER_CONTEXT)
# allow_k8s_contexts(CLUSTER_CONTEXT)

# Network section
network = cfg.get("network", "")

if network == "cilium":
  manifest = kustomize("network/cilium", flags = [
    "--enable-helm"
  ])
  k8s_yaml(manifest)

  
# observability section
observability = cfg.get("observability")

# signoz
if observability != "":
  manifest = kustomize("observability/" + observability, flags = [
    "--enable-helm"
  ])
  k8s_yaml(manifest)


# cicd section
cicd = cfg.get("cicd")

# argocd
if cicd == "argocd":
  manifest = kustomize("CICD/argocd", flags = [
    "--enable-helm"
  ])
  k8s_yaml(manifest)

# orchestration section
orchestration = cfg.get("orchestration")

# kubeflow
if orchestration == "kubeflow":
  local_resource(
    "orchestration-kubeflow",
    cmd="kustomize build orchestration/kubeflow --enable-helm | kubectl apply -f -",
    deps=["orchestration/kubeflow"],
    labels=["orchestration"]
  )

# storage section
storage = cfg.get("storage")

# goharbor
if storage == "goharbor":
  local_resource(
    "storage-goharbor",
    cmd="kustomize build storage/goharbor --enable-helm | kubectl apply -f -",
    deps=["storage/goharbor"],
    labels=["storage"]
  )

# llm section
llm = cfg.get("llm")

# envoy-ai-gateway
if llm == "envoy-ai-gateway":
  local_resource(
    "llm-envoy-ai-gateway",
    cmd="kustomize build LLM/envoy-ai-gateway --enable-helm | kubectl apply -f -",
    deps=["LLM/envoy-ai-gateway"],
    labels=["llm"]
  )