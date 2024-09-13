export SIGNOZ_NAMESPACE=observability

curl -sL https://github.com/SigNoz/signoz/raw/develop/sample-apps/hotrod/hotrod-install.sh \
  | HELM_RELEASE=signoz-obs SIGNOZ_NAMESPACE=observability bash
