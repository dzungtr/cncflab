#!/bin/bash

echo "Checking Istio installation status..."
echo "===================================="

# Check if istio-system namespace exists
echo -n "Istio namespace: "
if kubectl get namespace istio-system &>/dev/null; then
    echo "✓ exists"
else
    echo "✗ missing"
    exit 1
fi

# Check Istio CRDs
echo -n "Istio CRDs: "
CRD_COUNT=$(kubectl get crd | grep -c istio.io)
if [ $CRD_COUNT -gt 0 ]; then
    echo "✓ $CRD_COUNT CRDs found"
else
    echo "✗ no CRDs found"
fi

# Check Istiod deployment
echo -n "Istiod control plane: "
if kubectl get deployment -n istio-system istiod &>/dev/null; then
    READY=$(kubectl get deployment -n istio-system istiod -o jsonpath='{.status.readyReplicas}')
    DESIRED=$(kubectl get deployment -n istio-system istiod -o jsonpath='{.spec.replicas}')
    if [ "$READY" == "$DESIRED" ]; then
        echo "✓ ready ($READY/$DESIRED)"
    else
        echo "⚠ not ready ($READY/$DESIRED)"
    fi
else
    echo "✗ not found"
fi

# Check Ingress Gateway
echo -n "Ingress Gateway: "
if kubectl get deployment -n istio-system istio-ingress &>/dev/null; then
    READY=$(kubectl get deployment -n istio-system istio-ingress -o jsonpath='{.status.readyReplicas}')
    DESIRED=$(kubectl get deployment -n istio-system istio-ingress -o jsonpath='{.spec.replicas}')
    if [ "$READY" == "$DESIRED" ]; then
        echo "✓ ready ($READY/$DESIRED)"
    else
        echo "⚠ not ready ($READY/$DESIRED)"
    fi
else
    echo "✗ not found (may be intentionally disabled)"
fi

# Check pods
echo -e "\nIstio Pods:"
kubectl get pods -n istio-system

# Check services
echo -e "\nIstio Services:"
kubectl get svc -n istio-system

# Version info
echo -e "\nIstio Version:"
kubectl get deployment -n istio-system istiod -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null || echo "Istiod not found"