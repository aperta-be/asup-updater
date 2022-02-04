#!/bin/bash

# This file serves as building blocks for function that might (someday) be replaced.

function building_blocks_gitlab_api() {
  php /code/app/php/gitlab-api.php
}

function building_blocks_composer_update_constraints() {
  php /usr/local/bin/uv.php
}
