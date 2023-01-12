#!/bin/bash

# This file serves as building blocks for function that might (someday) be replaced.

# API integration with GitLab.
function building_blocks_gitlab_api() {
  SCRIPT_LOCATION="/code/app/php/gitlab-api.php"
  if [ -f $SCRIPT_LOCATION ];
    then API_OUTPUT=$(php $SCRIPT_LOCATION);
    # Catch PHP Output
    MERGE_REQUEST_URL=$(echo "$API_OUTPUT" | grep "# Merge request URL: " | sed 's/# Merge request URL: //g')
    echo "$API_OUTPUT"
    else exit 1;
  fi
}

# API integration with GitHub.
function building_blocks_github_api() {
  SCRIPT_LOCATION="/code/app/php/github-api.php"
  if [ -f $SCRIPT_LOCATION ];
    then API_OUTPUT=$(php $SCRIPT_LOCATION);
    # Catch PHP Output
    MERGE_REQUEST_URL=$(echo "$API_OUTPUT" | grep "# Pull request URL: " | sed 's/# Pull request URL: //g')
    echo "$API_OUTPUT"
    else exit 1;
  fi
}

# Update composer.json constraints to be able to updated to the actual latest version later.
function building_blocks_composer_update_constraints() {
  SCRIPT_LOCATION="/code/app/php/uv.php"
  if [ -f $SCRIPT_LOCATION ]; then php $SCRIPT_LOCATION; else exit 1; fi
}
