#!/usr/bin/env bash
# install.sh — Deploy ClickStack on a local Kubernetes cluster via Helm (v2.x chart)
# Ref: https://clickhouse.com/docs/use-cases/observability/clickstack/deployment/helm
set -euo pipefail

NAMESPACE="clickstack"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Adding ClickStack Helm repository..."
helm repo add clickstack https://clickhouse.github.io/ClickStack-helm-charts
helm repo update

# ---------------------------------------------------------------------------
# Phase 1: Install operators and CRDs
# The v2.x chart requires operators to be installed before the main chart.
# ---------------------------------------------------------------------------
echo ""
echo "==> Installing ClickStack operators (ClickHouse Operator, MongoDB Operator, OTel Operator)..."
helm upgrade --install clickstack-operators clickstack/clickstack-operators \
  --wait \
  --timeout 5m

echo ""
echo "==> Waiting for operator pods to become ready..."
kubectl wait pods \
  -l app.kubernetes.io/instance=clickstack-operators \
  --for=condition=Ready \
  --timeout=300s \
  --all-namespaces 2>/dev/null || true

# ---------------------------------------------------------------------------
# Phase 2: Install the main ClickStack chart
# ---------------------------------------------------------------------------
echo ""
echo "==> Creating namespace '${NAMESPACE}'..."
kubectl create namespace "${NAMESPACE}" --dry-run=client -o yaml | kubectl apply -f -

echo ""
echo "==> Installing ClickStack (main chart) with local-dev values..."
helm upgrade --install clickstack clickstack/clickstack \
  --namespace "${NAMESPACE}" \
  --values "${SCRIPT_DIR}/values.yaml" \
  --wait \
  --timeout 10m

echo ""
echo "==> Verifying pods..."
kubectl get pods -n "${NAMESPACE}" -l "app.kubernetes.io/name=clickstack"

# ---------------------------------------------------------------------------
# Access instructions
# ---------------------------------------------------------------------------
cat <<'EOF'

==========================================================================
  ClickStack deployed successfully!
==========================================================================

  Access HyperDX UI:
    kubectl port-forward \
      pod/$(kubectl get pod -n clickstack -l app.kubernetes.io/name=clickstack \
        -o jsonpath='{.items[0].metadata.name}') \
      8080:3000 -n clickstack
    Then open: http://localhost:8080

  Access ClickHouse (native protocol, port 9000):
    kubectl port-forward svc/clickhouse-clickstack 9000:9000 -n clickstack

  Access ClickHouse (HTTP interface, port 8123):
    kubectl port-forward svc/clickhouse-clickstack 8123:8123 -n clickstack
    Then: curl "http://localhost:8123/?query=SELECT+1"

  Send telemetry via OTLP gRPC (port 4317):
    kubectl port-forward svc/clickstack-otelcollector 4317:4317 -n clickstack

  Uninstall:
    helm uninstall clickstack -n clickstack
    helm uninstall clickstack-operators
    kubectl delete namespace clickstack
==========================================================================
EOF
