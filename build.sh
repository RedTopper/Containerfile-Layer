#!/bin/bash
set -euo pipefail

if [ "$EUID" -ne 0 ]; then
  # rpm-ostree requires root for rebasing
  # rpm-ostree only looks at root's 'containers-storage' for images
  echo "Please run with sudo."; exit
fi

IMG=localhost/containerfile-layer
TAG=$(date '+%Y%m%d-%H%M')

echo ">> Building $IMG:$TAG"
podman build --tag "$IMG:$TAG" --tag "$IMG:latest" .

echo ">> Previously built images:"
buildah images --filter "reference=$IMG"

echo ">> Rebasing onto $IMG:$TAG"
rpm-ostree rebase "ostree-unverified-image:containers-storage:$IMG:$TAG"
