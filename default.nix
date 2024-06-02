with import <nixpkgs> {};

mkShell {
  name = "cncflab";
  packages = [
    argocd
    kustomize_4
    kubectl
    gnupg
  ];
}