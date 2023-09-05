#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLUSTER_NAME=carvel


if ! type kind 2>/dev/null; then
  echo -e "
!! kind is not installed, please install kind

See: https://kind.sigs.k8s.io/docs/user/quick-start/#installation

On macOS:

  brew install kind
"
  exit 1
fi

if ! type kapp 2>/dev/null; then
  echo -e "
!! kapp is not installed, please install kapp

See: https://carvel.dev/kapp/docs/v0.57.0/install/

On macOS:

  brew tap vmware-tanzu/carvel && brew install kapp
"
  exit 1
fi

if ! type vendir 2>/dev/null; then
  echo -e "
!! vendir is not installed, please install vendir

See: https://carvel.dev/vendir/docs/v0.34.x/install/

On macOS:

  brew tap vmware-tanzu/carvel && brew install vendir
"
  exit 1
fi

if ! kind get clusters | grep "$CLUSTER_NAME"; then
  echo "~~ Setting up kind cluster"
  kind create cluster --config "$SCRIPT_DIR/kind.yml" --name "$CLUSTER_NAME"
  echo "~~ Setting up kind cluster > done"
fi

echo "~~ Setting nginx ingress"
if kapp inspect --app nginx-ingress >/dev/null; then
  echo "~~ Setting nginx ingress > already installed, skipping"
else
  cd "$SCRIPT_DIR/.."
  vendir sync --locked
  kapp deploy --app nginx-ingress --file "$SCRIPT_DIR/nginx-ingress/deploy/static/provider/kind/deploy.yaml" --yes
  echo "~~ Setting nginx ingress > done"
fi

echo "~~ Setting kapp-controller"
if kapp inspect --app kapp-controller >/dev/null; then
  echo "~~ Setting kapp controller > already installed, skipping"
else
  cd "$SCRIPT_DIR/.."
  vendir sync --locked
  kapp deploy --app kapp-controller --file "$SCRIPT_DIR/kapp-controller/release.yml" --yes
  echo "~~ Setting kapp controller > done"
fi

echo "~~ Configuring CoreDNS for 127.0.0.1.nip.io"
kubectl get configmap coredns \
  --namespace kube-system \
  --output yaml |
    ytt \
      --file - \
      --file "$SCRIPT_DIR/coredns-overlay.yml" |
    kubectl apply --filename -
echo "~~ Configuring CoreDNS for 127.0.0.1.nip.io > done"
