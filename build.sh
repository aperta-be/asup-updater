#!/bin/bash

### Write .env file
cat > .env <<EOL
GIT_AUTO_MERGE=0

CONSUMER="Aperta-Cloud-Build"

GIT_BRANCH_TARGET="test-branch-kevin"
COMPOSER_UPDATE_CONSTRAINTS=1
SELF_TEST=1
DRY_RUN=0
APP_PUBLIC_ROOT_DIRECTORY="web"

VCS_PROVIDER="github"

GIT_CLONE_URL="git@github.com:dazzletheweb/drupal-outdated-test.git"
GITHUB_HOST="https://github.com"
GITHUB_OWNER="dazzletheweb"
GITHUB_REPO="drupal-outdated-test"
GITHUB_ASUP_TOKEN=${GITHUB_ASUP_TOKEN}

MATTERMOST_HOOK=${MATTERMOST_HOOK}

EOL

phpVersions=("7.4" "8.1" "8.2")

for v in ${phpVersions[@]}; do
  echo Using docker build with "-t asup:$v --build-arg PHP_VERSION=$v"
  docker build -t asup:dev-$v --build-arg PHP_VERSION=$v .
done
