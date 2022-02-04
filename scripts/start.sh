#!/bin/bash
set -ex

# Load some building block functions.
source /code/app/sh/building_blocks.sh

# Check if we are locally developing.
source /code/app/sh/check_env.sh

ASUP_TIMESTAMP=$(date +%s)
GIT_USER_NAME="ASUP"
GIT_USER_EMAIL="asup@support.dazzle.be"
GIT_BRANCH_SOURCE="security/$ASUP_TIMESTAMP"

# Prerequisites checks and defaults
source /code/app/sh/prerequisites.sh

# Provisioning. Gitlab API only for now:
source /code/app/sh/provisioning.sh
provisioning_write_vars_gitlab

# Before continuing, selftest. @todo: work with functions.
if [[ $COMPOSER_UPDATE_CONSTRAINTS == 1 ]]; then
  source /code/app/sh/selftest.sh
fi

source /code/app/sh/ssh.sh
ssh_keys_install
ssh_keys_validate

source /code/app/sh/git.sh
git_configure
git_create_dir
git_get_code

source /code/app/sh/composer.sh
composer_outdated
composer_update_constraints
composer_update_drupal_core
composer_update_drupal_contrib

# Cleanup temporary files created in our composer operations.
composer_cleanup

# Commit and push our security branch to the origin.
git_commit_push
# Create MR and/or merge it.
git_branch_merge

if [[ $? == 0 ]]; then echo -e "# \e[1;35mMission accomplished.\e[0m"; else echo -e "# \e[1;31mSome failure occurred at the end. This is bad news.\e[0m"; fi

#while true; do echo "zZzZzZz"; sleep 2000; done

# Mail on error?
# Watcher in MR?
