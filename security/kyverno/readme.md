# Admission Controll Best practices

### 1. Well configured RBAC

- Cluster Admin
- Cluster operator: Permission in infrastructure application
- Application Developer: Permission in business application 


### 2. Cluster wide Policy
- Enfore policy across all namespace
- Whitelist namespace if needed: kube-system, ebpf agent

### 3. Reuse template
- baseline template provided by security best practice provider
- reuse monitor template to reduce building effort