#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test environment variables
export SELF_TEST=1
export DRY_RUN=1
export VERBOSE=1
export VCS_PROVIDER="github"
export GIT_AUTO_MERGE=0
export GIT_HOST="github.com"
export GIT_NAMESPACE="test-org"
export GIT_PROJECT="test-project"
export GIT_BRANCH_TARGET="develop"
export GIT_USER="test-user"
export GIT_TOKEN="test-token"
export COMPOSER_UPDATE_CONSTRAINTS=1
export APP_PUBLIC_ROOT_DIRECTORY="web"
export MATTERMOST_HOOK="https://example.com/hooks/test-hook"

# Construct Git clone URL based on provider
if [ "$VCS_PROVIDER" = "github" ]; then
    export GIT_CLONE_URL="https://github.com/${GIT_NAMESPACE}/${GIT_PROJECT}.git"
else
    export GIT_CLONE_URL="https://${GIT_HOST}/${GIT_NAMESPACE}/${GIT_PROJECT}.git"
fi

# Function to run tests for a specific PHP version
run_test() {
    local PHP_VERSION=$1
    echo -e "${YELLOW}Testing PHP ${PHP_VERSION}${NC}"
    
    # Run the container with test environment
    echo -e "Using docker run with asup:${PHP_VERSION}"
    docker run \
        -e SELF_TEST \
        -e DRY_RUN \
        -e VERBOSE \
        -e VCS_PROVIDER \
        -e GIT_AUTO_MERGE \
        -e GIT_HOST \
        -e GIT_NAMESPACE \
        -e GIT_PROJECT \
        -e GIT_BRANCH_TARGET \
        -e GIT_USER \
        -e GIT_TOKEN \
        -e GIT_CLONE_URL \
        -e COMPOSER_UPDATE_CONSTRAINTS \
        -e APP_PUBLIC_ROOT_DIRECTORY \
        -e MATTERMOST_HOOK \
        asup:dev-${PHP_VERSION}
}

# Run tests for each PHP version
for v in $(cat php_versions); do
    run_test $v
done