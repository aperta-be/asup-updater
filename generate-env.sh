#!/bin/bash
# ##################################################
# Create .env files for Github and Gitlab testing.
# ##################################################

# Check if a branch name is provided or a default value.
if [[ -z ${1} ]]; then
  if [[ -z ${GIT_BRANCH_TARGET} ]]; then
    echo Please provide a branch name as argument.
    exit 1
  else
    GIT_BRANCH_TARGET=develop
    echo Using default branch name: ${GIT_BRANCH_TARGET}
  fi
else
    GIT_BRANCH_TARGET=${1}
  echo Using branch name: ${GIT_BRANCH_TARGET}
fi

### Write Github .env file
cat > .env_github <<EOL
CONSUMER=Aperta-Cloud-Build
SELF_TEST=0
DRY_RUN=0
VERBOSE=1
COMPOSER_UPDATE_CONSTRAINTS=1
APP_PUBLIC_ROOT_DIRECTORY=web
MATTERMOST_HOOK=https://mattermost.dazzle.be/hooks/f8rb7d4fufnu3m4qbcdrauhuge
VCS_PROVIDER=github
GIT_AUTO_MERGE=0
GIT_HOST=https://github.com
GIT_CLONE_URL=https://github.com/dazzletheweb/composer-outdated-project.git
GIT_NAMESPACE=dazzletheweb
GIT_PROJECT=composer-outdated-project
GIT_BRANCH_TARGET=${GIT_BRANCH_TARGET}
GIT_APERTA_USER=dazzletheweb
GIT_APERTA_TOKEN=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
EOL

### Write Gitlab .env file
cat > .env_gitlab <<EOL
CONSUMER=Aperta-Cloud-Build
SELF_TEST=0
DRY_RUN=0
VERBOSE=1
COMPOSER_UPDATE_CONSTRAINTS=1
APP_PUBLIC_ROOT_DIRECTORY=web
MATTERMOST_HOOK=https://mattermost.dazzle.be/hooks/f8rb7d4fufnu3m4qbcdrauhuge
VCS_PROVIDER=gitlab
GIT_AUTO_MERGE=0
GIT_CLONE_URL=https://gitlab.dazzle.be/aperta/composer-outdated-project.git
GIT_HOST=https://gitlab.dazzle.be
GIT_NAMESPACE=dazzletheweb
GIT_PROJECT=composer-outdated-project
GIT_BRANCH_TARGET=${GIT_BRANCH_TARGET}
GIT_APERTA_USER=apertatester
GIT_APERTA_TOKEN=glpat-AxkR9s4tu2y97sEsKYxy
EOL
