#!/bin/bash

GITHUB_ASUP_TOKEN="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"
MATTERMOST_HOOK="https://mattermost.dazzle.be/hooks/f8rb7d4fufnu3m4qbcdrauhuge"

for v in $(cat php_versions); do
  source build.sh "develop-${v}"
  # Check if a dedicated Dockerfile exist.
    DOCKERFILE="Dockerfile"
    if test -f "Dockerfile-${v}"; then
      DOCKERFILE="Dockerfile-${v}"
      echo Using specific Dockerfile "Dockerfile-${v}"
    fi
  echo Using docker build with "-t asup:$v --build-arg PHP_VERSION=$v"
  docker build -t asup:dev-$v --build-arg PHP_VERSION=$v . -f $DOCKERFILE
done
