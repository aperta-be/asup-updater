#!/usr/bin/env bash

# If no release tag provided fallback to 0.0
[ -z "$1" ] && export RELEASE="0.0" || RELEASE="$1"
[ -z "$2" ] && export DEV="" || DEV=$2

for PHP_VERSION in $(cat php_versions); do
  # Check if a dedicated Dockerfile exist.
  DOCKERFILE="Dockerfile"
  if test -f "Dockerfile-${PHP_VERSION}"; then
    DOCKERFILE="Dockerfile-${PHP_VERSION}"
  fi

  cat .gitlab-ci-child-build-template.yml |
    sed "s/<PHP_VERSION>/${PHP_VERSION}/g" |
    sed "s/<DEV>/${DEV}/g" |
    sed "s/<TAG>/${RELEASE}/g" |
    sed "s/<DOCKERFILE>/${DOCKERFILE}/g" >> .gitlab-ci-child-build-dynamic.yml

  cat .gitlab-ci-child-test-template.yml |
    sed "s/<PHP_VERSION>/${PHP_VERSION}/g" |
    sed "s/<DEV>/${DEV}/g" |
    sed "s/<TAG>/${RELEASE}/g" |
    sed "s/<DOCKERFILE>/${DOCKERFILE}/g" >> .gitlab-ci-child-test-dynamic.yml

done
