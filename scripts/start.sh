#!/bin/bash
#set -ex

ASUP_TIMESTAMP=$(date +%s)
GIT_USER_NAME="ASUP"
GIT_USER_EMAIL="asup@support.dazzle.be"
GIT_BRANCH_SOURCE="security/$ASUP_TIMESTAMP"

# If script runs on a CI environment set APP_CODE_DIRECTORY from CI_PROJECT_DIR.
#if ! [ -v ${CI_PROJECT_DIR+x} ]; then APP_CODE_DIRECTORY="$CI_PROJECT_DIR"
#  else APP_CODE_DIRECTORY="/code/project";
#fi
APP_CODE_DIRECTORY="/code/project";

# Load some building block functions.
source /code/app/sh/building_blocks.sh

# Check if we are locally developing and parse .env.
source /code/app/sh/check_env.sh

# Prerequisites checks and defaults.
source /code/app/sh/prerequisites.sh

# Before continuing, self-test. @todo: work with functions.
if [[ $SELF_TEST == 1 ]]; then
  source /code/app/sh/selftest.sh
fi

# Prepare SSH Keys
source /code/app/sh/ssh.sh
ssh_keys_install
ssh_keys_validate

# Configure git and create code dir.
source /code/app/sh/git.sh
git_configure
git_create_dir
git_get_code

# Provisioning functions.
source /code/app/sh/provisioning.sh
# Create Gitlab API configuration.
provisioning_write_vars_gitlab

# Composer functions.
source /code/app/sh/composer.sh

# Composer install packages.
composer_install

# Get updates and create a temporary file (outdated.txt).
composer_outdated

# Update constraint versions on composer.json.
if [[ $COMPOSER_UPDATE_CONSTRAINTS == 1 ]]; then
  composer_update_constraints
else
  echo -e "# \e[1;35mCOMPOSER_UPDATE_CONSTRAINTS is not 1. Skipping major versions during upgrade.\e[0m"
fi

# Do the actual update.
composer_update_all

# Commit and push our security branch to the origin.
git_commit_push

# Create MR and/or merge it.
git_branch_merge

# Write files for monitoring.
# provisioning_write_updated_date
# provisioning_writes_updates

# Configure git and create code dir.
source /code/app/sh/report.sh
report_mattermost

# Cleanup temporary files created in our composer operations.
composer_cleanup

if [[ $? == 0 ]]; then echo -e "# \e[1;35mMission accomplished.\e[0m"; else echo -e "# \e[1;31mSome failure occurred at the end. This is bad news.\e[0m"; fi

#while true; do echo "zZzZzZz"; sleep 2000; done

# Mail on error?
# Watcher in MR?
