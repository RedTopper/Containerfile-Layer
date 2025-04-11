#!/bin/bash
set -euo pipefail

if [ "$EUID" -ne 0 ]; then
  # bootc requires root for rebasing
  # bootc only looks at root's 'containers-storage' for images
  echo "Please run with sudo."; exit
fi

IMG=localhost/containerfile-layer
TAG=$(date '+%Y%m%d-%H%M')

podman build --tag "$IMG:$TAG" --tag "$IMG:latest" --pull=always .
bootc switch --transport containers-storage "$IMG:$TAG"
