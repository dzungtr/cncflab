# CNCF Lab

> A hands-on learning lab for operating the cloud-native stack — built and maintained by a Platform Engineer on the journey from full-stack development to principal-level infrastructure.

## Who built this and why

I'm a Platform Engineer based in Melbourne, Australia. My background is unusual for infrastructure: I started as a React Native developer, moved through full-stack engineering, and transitioned into platform and infrastructure work around late 2022.

That path gave me something most platform engineers don't have — I've felt the developer experience from inside the application layer. I know what it's like to wait on a slow deploy, hit a confusing network policy, or debug an opaque observability stack. That perspective shapes how I think about platform engineering: the platform exists to serve developers, not the other way around.

This lab exists because I believe the only way to truly understand cloud-native infrastructure is to operate it yourself — not just read the docs, not just watch tutorials, but run it, break it, fix it, and do it again.

**What I'm exploring here:**

- **Networking**: Cilium as CNI and service mesh — network policies, eBPF-based observability, identity-aware traffic control
- **GitOps & CI/CD**: ArgoCD — App of Apps pattern, ApplicationSets, multi-tenant isolation
- **Security**: Kyverno admission control, Falco runtime threat detection, Tetragon eBPF enforcement
- **Observability**: The LGTM stack (Loki, Grafana, Tempo, Mimir) and SigNoz as an alternative
- **Orchestration**: KEDA event-driven autoscaling, Argo Workflows
- **AI/LLM Infrastructure**: Running LLM workloads on Kubernetes — the `LLM/` folder is where this is growing

The toolchain itself is intentional: `kind` for reproducible local clusters, `Tilt` for fast feedback loops, `Nix` + `direnv` for hermetic environments. Every tool choice has a reason.

## What this is not

This is not a polished framework or a production blueprint. It's a living laboratory. Some things are half-finished. Some experiments failed and stayed in the repo as evidence of that. The ROADMAP and COVERAGE files track what's done and what's next.

If you're a fellow engineer learning this stack, I hope something here saves you an hour of confusion. If you're evaluating my work, this represents real hands-on depth — not just knowledge of what these tools do, but experience with how they actually behave.

---
