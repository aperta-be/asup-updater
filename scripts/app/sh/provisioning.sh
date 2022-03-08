#!/bin/bash

# Write Gitlab PHP variables file.
function provisioning_write_vars_gitlab() {
  cat > /code/gitlab-api/variables.php <<EOL
    <?php
    /**
     * @file
     *
     * This file is generated.
     */
    const GITLAB_HOST = '$GITLAB_HOST';
    const GITLAB_TOKEN = '$GITLAB_TOKEN';

    const GITLAB_PROJECT_ID = '$GITLAB_PROJECT_ID';
    const GIT_BRANCH_SOURCE = '$GIT_BRANCH_SOURCE';
    const GIT_BRANCH_TARGET = '$GIT_BRANCH_TARGET';

    const GIT_AUTO_MERGE = $GIT_AUTO_MERGE;

    const MERGE_REQUEST_TITLE = 'Automated security MR $ASUP_TIMESTAMP';
    const MERGE_REQUEST_DESCRIPTION = 'Automated MR by ASUP';
EOL
}

# Provide the date as this is the moment. This is needed for the monitoring system.
function provisioning_write_updated_date() {
  echo date > $APP_PUBLIC_ROOT_DIRECTORY/asup-date.txt
}

# Provide the updates file. This is needed for the monitoring system.
function provisioning_write_to_updates_file() {
  if [ $# -eq 0 ]
    then
      echo "# \e[1;31mNo arguments supplied to write updates file.\e[0m"
  fi
  echo $1 >> $APP_PUBLIC_ROOT_DIRECTORY/asup-up.txt
}

function provisioning_writes_updates() {
  # Check if there are updates.
  composer_outdated
  if [ -s $APP_CODE_DIRECTORY/outdated.txt ]; then
    echo "Outdated.txt exists."
    cat $APP_CODE_DIRECTORY/outdated.txt

    # If we have results and it's drupal/core.
    if grep -q "drupal/core" $APP_CODE_DIRECTORY/outdated.txt; then
      echo "drupal/core found!"
      provisioning_write_to_updates_file "ALPHA"
    fi
    # If we didn't find drupal/core but we do find drupal/ it's most likely contrib.
    if grep -q "drupal/" $APP_CODE_DIRECTORY/outdated.txt; then
      echo "drupal/ found!"
      provisioning_write_to_updates_file "BETA"
    fi
    # Other updates.
    if grep -q " " $APP_CODE_DIRECTORY/outdated.txt; then
      echo "Omega found!"
      provisioning_write_to_updates_file "OMEGA"
    # When composer outdated returns empty, so do we.
    else
      provisioning_write_to_updates_file ""
    fi
  fi
}
