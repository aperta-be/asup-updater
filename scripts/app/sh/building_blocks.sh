#!/bin/bash

# This file serves as building blocks for function that might (someday) be replaced.

# API integration with Gitlab.
function building_blocks_gitlab_api() {
  SCRIPT_LOCATION="/code/app/php/gitlab-api.php"
  if [ -f $SCRIPT_LOCATION ]; then php $SCRIPT_LOCATION; else exit 1; fi
}

# Update composer.json constraints to be able to updated to the actual latest version later.
function building_blocks_composer_update_constraints() {
  SCRIPT_LOCATION="/code/app/php/uv.php"
  if [ -f $SCRIPT_LOCATION ]; then php $SCRIPT_LOCATION; else exit 1; fi
}
