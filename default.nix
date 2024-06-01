with import <nixpkgs> {};

mkShell {
  name = "devopslab";
  packages = [
    argocd
    kustomize_4
    kubectl
  ];
}