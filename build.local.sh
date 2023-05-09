#!/bin/bash
# ##################################################
# Build Docker images for all PHP versions.
# ##################################################

for v in $(cat php_versions); do
  # Generate test .env file for each PHP version.
  source generate-env.sh "develop-${v}"
  # Check if a dedicated Dockerfile exist.
    DOCKERFILE="Dockerfile"
    if test -f DOCKERFILE; then
      echo There is a Dockerfile. It needs to be removed.
    fi
    if test -f "Dockerfile-${v}"; then
      DOCKERFILE="Dockerfile-${v}"
      echo Using specific Dockerfile "Dockerfile-${v}"
      echo Using docker build with "-t asup:$v --build-arg PHP_VERSION=$v"
      docker build -t asup:dev-$v --build-arg PHP_VERSION=$v . -f $DOCKERFILE
    else
      echo "Dockerfile-${v} not found"
      exit 1
    fi
done
