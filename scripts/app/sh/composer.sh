#!/bin/bash

# Executes composer install with a dry-run first.
function composer_install() {
  composer install --dry-run
  if [[ $(composer install) ]]; then echo -e "# \e[1;35mComposer install succesfully!\e[0m"; else echo -e "# \e[1;31mComposer install failed... That's bad news.\e[0m"; exit 1; fi
}

# Stores the result of outdated libaries in a file.
function composer_outdated() {
  echo -e "# \e[1;35mCheck if newer version is available\e[0m"
  composer outdated --direct > outdated.txt
  cat outdated.txt
}

function composer_update_constraints() {
  # Update composer.json constraints
  if [[ $COMPOSER_UPDATE_CONSTRAINTS == 1 ]]; then
    echo -e "# \e[1;35mUpdate contraints\e[0m"
    cat composer.json > composer.json.before
    php /usr/local/bin/uv.php
    diff composer.json.before composer.json
  else
    echo "# COMPOSER_UPDATE_CONSTRAINTS is not 1. Skipping."
  fi
}

function composer_update_drupal_core() {
  echo -e "# \e[1;35mActual update via composer\e[0m"
  composer update drupal/core "drupal/core-*" --with-all-dependencies --dry-run
  # If a patch can not be applied. Back off.
  if [[ $(composer update drupal/core "drupal/core-*" --with-all-dependencies) == *"Could not apply patch!"* ]]; then echo -e "# \e[1;31mCould not apply patch!\e[0m"; exit 1; else echo -e "# \e[1;35mCore update OK\e[0m"; fi
}

function composer_update_drupal_contrib() {
  composer update --with-all-dependencies --dry-run
  # If a patch can not be applied. Back off.
  if [[ $(composer update --with-all-dependencies) == *"Could not apply patch!"* ]]; then echo -e "# \e[1;31mCould not apply patch!\e[0m"; exit 1; else echo -e "# \e[1;35mAll updates OK\e[0m"; fi
}

# Cleans up files and or folders created during composer actions
function composer_cleanup() {
  rm -rf \
  outdated.txt \
  composer.json.before \
  ;
}
