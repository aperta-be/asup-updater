#!/bin/bash
#set -ex

ASUP_TIMESTAMP=$(date +%s)
GIT_USER_NAME="ASUP"
GIT_USER_EMAIL="asup@support.dazzle.be"
GIT_BRANCH_SOURCE="security/$ASUP_TIMESTAMP"
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

# Configure git and get code.
source /code/app/sh/git.sh
git_configure
git_create_dir
git_get_code

# Create VCS API configuration.
git_write_vars_vcs

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

if [[ "$COMPOSER_REPORT" == "Core update OK." ]]; then
  # Commit and push our security branch to the origin.
  git_commit_push

  # Create MR and/or merge it.
  git_branch_merge
fi

# Report results.
source /code/app/sh/report.sh
report_mattermost

if [[ $? == 0 ]]; then echo -e "# \e[1;35mMission accomplished.\e[0m"; else echo -e "# \e[1;31mSome failure occurred at the end. This is bad news.\e[0m"; fi

#while true; do echo "zZzZzZz"; sleep 2000; done

# Mail on error?
# Watcher in MR?
