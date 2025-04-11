#!/bin/bash
set -euo pipefail

if [ "$EUID" -ne 0 ]; then
  # build caches have been created by root
  echo "Please run with sudo."; exit
fi

IMG=localhost/containerfile-layer

buildah images --filter "reference=$IMG"

read -er -p "Remove old builds? [y/N] " choice
[[ "$choice" == [Yy] ]] && (
  echo "Cleaning non-latest builds..."
  REMOVE=$(buildah images --filter "reference=localhost/containerfile-layer,before=localhost/containerfile-layer:latest" --format '{{.ID}}')
  [[ -n "$REMOVE" ]] && (buildah rmi $REMOVE && buildah rmi --prune) || exit 0
)

tree "/var/tmp/buildah-cache-$EUID" -P "*.rpm" --prune -h --du || true

read -er -p "Clear cache (including above RPMs) for user $EUID? [y/N] " choice
[[ "$choice" == [Yy] ]] && (
  echo "Clearing cache..."
  rm -rf "/var/tmp/buildah-cache-$EUID/"*
)

exit 0
