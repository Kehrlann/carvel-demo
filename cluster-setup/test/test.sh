#!/usr/bin/env bash

# Small script to test the NGINX Ingress deployment

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NGINX_YML="$SCRIPT_DIR/nginx.yml"

kubectl apply --filename "$NGINX_YML"

kubectl wait --namespace nginx \
  --for=condition=ready pod \
  --selector=app=nginx \
  --timeout=90s

for i in {1..5}; do
  s=0
  curl nginx.127.0.0.1.nip.io --fail && break ||
    s=$? && echo "Waiting for nginx to come up ..." && sleep 1
done

if [[ $s != 0 ]]; then
  echo "Could not reach nginx deployment..."
  exit $s
fi


kubectl delete --filename "$NGINX_YML"

echo -e "\n~~ Success!"

