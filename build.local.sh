#!/bin/bash

GITHUB_ASUP_TOKEN="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"
MATTERMOST_HOOK="https://mattermost.dazzle.be/hooks/f8rb7d4fufnu3m4qbcdrauhuge"

source build.sh

for v in $(cat php_versions); do
  echo Using docker build with "-t asup:$v --build-arg PHP_VERSION=$v"
  docker build -t asup:dev-$v --build-arg PHP_VERSION=$v .
done