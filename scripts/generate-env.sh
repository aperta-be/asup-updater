#!/bin/bash
# ##################################################
# Create .env files for Github and Gitlab testing.
# This script requires certain environment variables to be set.
# See .env.example for required variables.
# ##################################################

# Function to check if required environment variables are set
check_required_vars() {
    local provider=$1
    local missing=0
    
    # Common required variables
    declare -a required_vars=(
        "GIT_APERTA_USER"
        "GIT_APERTA_TOKEN"
        "MATTERMOST_HOOK"
    )
    
    for var in "${required_vars[@]}"; do
        if [[ -z "${!var}" ]]; then
            echo "Error: $var is not set"
            missing=1
        fi
    done
    
    if [[ $missing -eq 1 ]]; then
        echo "Please set all required environment variables first."
        echo "You can copy .env.example to .env and fill in the values."
        exit 1
    fi
}

# Check if a branch name is provided or use default value
if [[ -z ${1} ]]; then
    if [[ -z ${GIT_BRANCH_TARGET} ]]; then
        echo "Please provide a branch name as argument."
        exit 1
    else
        GIT_BRANCH_TARGET=develop
        echo "Using default branch name: ${GIT_BRANCH_TARGET}"
    fi
else
    GIT_BRANCH_TARGET=${1}
    echo "Using branch name: ${GIT_BRANCH_TARGET}"
fi

# Check for required environment variables
check_required_vars

### Write Github .env file
cat > .env_github <<EOL
# General settings
CONSUMER=ASUP-Build
SELF_TEST=0
DRY_RUN=0
VERBOSE=1
COMPOSER_UPDATE_CONSTRAINTS=1
APP_PUBLIC_ROOT_DIRECTORY=web

# Notification settings
MATTERMOST_HOOK=${MATTERMOST_HOOK}

# GitHub specific settings
VCS_PROVIDER=github
GIT_AUTO_MERGE=0
GIT_HOST=https://github.com
GIT_CLONE_URL=${GITHUB_CLONE_URL:-https://github.com/your-org/your-project.git}
GIT_NAMESPACE=${GITHUB_NAMESPACE:-your-org}
GIT_PROJECT=${GITHUB_PROJECT:-your-project}
GIT_BRANCH_TARGET=${GIT_BRANCH_TARGET}
GIT_APERTA_USER=${GIT_APERTA_USER}
GIT_APERTA_TOKEN=${GIT_APERTA_TOKEN}
EOL

### Write Gitlab .env file
cat > .env_gitlab <<EOL
# General settings
CONSUMER=ASUP-Build
SELF_TEST=0
DRY_RUN=0
VERBOSE=1
COMPOSER_UPDATE_CONSTRAINTS=1
APP_PUBLIC_ROOT_DIRECTORY=web

# Notification settings
MATTERMOST_HOOK=${MATTERMOST_HOOK}

# GitLab specific settings
VCS_PROVIDER=gitlab
GIT_AUTO_MERGE=0
GIT_HOST=${GITLAB_HOST:-https://gitlab.com}
GIT_CLONE_URL=${GITLAB_CLONE_URL:-https://gitlab.com/your-org/your-project.git}
GIT_NAMESPACE=${GITLAB_NAMESPACE:-your-org}
GIT_PROJECT=${GITLAB_PROJECT:-your-project}
GIT_BRANCH_TARGET=${GIT_BRANCH_TARGET}
GIT_APERTA_USER=${GIT_APERTA_USER}
GIT_APERTA_TOKEN=${GIT_APERTA_TOKEN}
EOL

echo "Environment files generated successfully!"
echo "Note: Make sure to review the generated .env files and update any placeholder values."
echo "Warning: Never commit these .env files to version control!"
