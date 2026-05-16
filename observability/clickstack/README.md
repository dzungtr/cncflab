# ClickStack Observability

ClickStack is ClickHouse's unified observability stack that bundles:

- **ClickHouse** — columnar database for storing logs, traces, and metrics at scale, managed by the ClickHouse Operator
- **HyperDX** — the observability UI and API (formerly HouseWatch), for querying and visualising telemetry data
- **OpenTelemetry Collector** — ingestion layer, deployed via the official OTel Collector Helm chart subchart
- **MongoDB** — backing store for HyperDX metadata, managed by the MongoDB Community Kubernetes Operator

The v2.x Helm chart uses a two-phase installation: operators/CRDs first, then the main chart which creates operator-managed custom resources.

## Prerequisites

- Helm v3+
- Kubernetes cluster (v1.20+, e.g. kind, k3s, minikube)
- `kubectl` configured and pointing at your cluster

## Deploy

```bash
bash install.sh
```

The script will:
1. Add the ClickStack Helm repository
2. Install the `clickstack-operators` chart (ClickHouse Operator + MongoDB Operator + OTel Operator CRDs)
3. Wait for operator pods to become ready
4. Create the `clickstack` namespace
5. Install the main `clickstack` chart with local-dev overrides from `values.yaml`

## Access

### HyperDX UI

```bash
kubectl port-forward \
  pod/$(kubectl get pod -n clickstack -l app.kubernetes.io/name=clickstack -o jsonpath='{.items[0].metadata.name}') \
  8080:3000 -n clickstack
```

Open http://localhost:8080 in your browser.
Create a user account on first launch — data sources for the bundled ClickHouse instance are auto-configured.

### ClickHouse (native protocol)

```bash
kubectl port-forward svc/clickhouse-clickstack 9000:9000 -n clickstack
```

Connect with any ClickHouse client at `localhost:9000`.

### ClickHouse (HTTP interface)

```bash
kubectl port-forward svc/clickhouse-clickstack 8123:8123 -n clickstack
```

Query via `curl http://localhost:8123/?query=SELECT+1`.

### OpenTelemetry Collector (OTLP gRPC)

```bash
kubectl port-forward svc/clickstack-otelcollector 4317:4317 -n clickstack
```

Point your OTLP exporters at `localhost:4317`.

## Uninstall

```bash
helm uninstall clickstack -n clickstack
helm uninstall clickstack-operators
kubectl delete namespace clickstack
```

## References

- [ClickStack Helm deployment guide](https://clickhouse.com/docs/use-cases/observability/clickstack/deployment/helm)
- [ClickStack architecture overview](https://clickhouse.com/docs/use-cases/observability/clickstack)
- [Helm chart source](https://github.com/ClickHouse/ClickStack-helm-charts)
