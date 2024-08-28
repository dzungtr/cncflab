with import <nixpkgs> {};

mkShell {
  name = "cncflab";
  packages = [
    argocd
    kustomize_4
    kubectl
    gnupg
    tilt
    openapi-generator-cli
    kubernetes-helm
    jq
    envsubst
    cilium-cli
    hubble
    kind
  ];
}