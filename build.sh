#!/bin/bash

### Write .env file
cat > .env <<EOL
GIT_AUTO_MERGE=0

CONSUMER="Aperta-Cloud-Build"

GIT_BRANCH_TARGET="develop"
COMPOSER_UPDATE_CONSTRAINTS=1
VERBOSE=1
SELF_TEST=1
SKIP_AFTER_SELF_TEST=1
DRY_RUN=0
APP_PUBLIC_ROOT_DIRECTORY="web"

VCS_PROVIDER="github"

GIT_CLONE_URL="git@github.com:dazzletheweb/composer-outdated-project.git"
GITHUB_HOST="https://github.com"
GITHUB_OWNER="dazzletheweb"
GITHUB_REPO="composer-outdated-project"
GITHUB_ASUP_TOKEN=${GITHUB_ASUP_TOKEN}

MATTERMOST_HOOK=${MATTERMOST_HOOK}

EOL
