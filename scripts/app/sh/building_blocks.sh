#!/bin/bash

# This file serves as building blocks for function that might (someday) be replaced.

# Unified VCS API integration (supports GitLab, GitHub, and other providers)
function building_blocks_vcs_api() {
  SCRIPT_LOCATION="/code/app/php/vcs-api.php"
  if [ -f $SCRIPT_LOCATION ]; then
    API_OUTPUT=$(php $SCRIPT_LOCATION)
    exit_code=$?
    if [ $exit_code -ne 0 ]; then
      echo "$API_OUTPUT"
      echo -e "# \e[1;31mVCS API request exited with a non-zero status code: $exit_code\e[0m"
      exit 1
    fi
    # Extract the request URL from output (works for both GitLab and GitHub)
    MERGE_REQUEST_URL=$(echo "$API_OUTPUT" | grep "# Request URL: " | sed 's/# Request URL: //g')
    echo "$API_OUTPUT"
  else
    echo -e "# \e[1;31mVCS API script not found: $SCRIPT_LOCATION\e[0m"
    exit 1
  fi
}

# Legacy GitLab API function (deprecated - use building_blocks_vcs_api instead)
function building_blocks_gitlab_api() {
  echo -e "# \e[1;33mWarning: building_blocks_gitlab_api is deprecated. Use building_blocks_vcs_api instead.\e[0m"
  building_blocks_vcs_api
}

# Legacy GitHub API function (deprecated - use building_blocks_vcs_api instead)
function building_blocks_github_api() {
  echo -e "# \e[1;33mWarning: building_blocks_github_api is deprecated. Use building_blocks_vcs_api instead.\e[0m"
  building_blocks_vcs_api
}

# Update composer.json constraints to be able to updated to the actual latest version later.
function building_blocks_composer_update_constraints() {
  SCRIPT_LOCATION="/code/app/php/uv.php"
  if [ -f $SCRIPT_LOCATION ]; then php $SCRIPT_LOCATION; else exit 1; fi
}
