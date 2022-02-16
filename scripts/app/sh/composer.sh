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
    building_blocks_composer_update_constraints
    diff composer.json.before composer.json
    # After the constraints are updated, we need to update the lock file.
    echo -e "# \e[1;35mUpdate composer.lock and run install --with-all-dependencies\e[0m"
    composer update --lock
  else
    echo "# COMPOSER_UPDATE_CONSTRAINTS is not 1. Skipping."
  fi
}

function composer_update_drupal_core() {
  echo -e "# \e[1;35mCore update via composer\e[0m"
  composer update drupal/core "drupal/core-*" --with-all-dependencies --dry-run
  COMPOSER_UPDATE_CMD=$(composer update drupal/core "drupal/core-*" --with-all-dependencies)
  # If a patch can not be applied. Back off.
  if [[ $COMPOSER_UPDATE_CMD == *"Your requirements could not be resolved"* ]] || [[ $COMPOSER_UPDATE_CMD == *"Could not apply patch!"* ]]; then echo -e "# \e[1;31mComposer requirements check failed or could not apply patch!\e[0m"; exit 1; else echo -e "# \e[1;35mCore update OK\e[0m"; fi
}

function composer_update_drupal_contrib() {
  echo -e "# \e[1;35mContrib update via composer\e[0m"
  composer update --with-all-dependencies --dry-run
  # If a patch can not be applied. Back off.
  if [[ $(composer update drupal/* --with-all-dependencies) == *"Could not apply patch!"* ]]; then echo -e "# \e[1;31mCould not apply patch!\e[0m"; exit 1; else echo -e "# \e[1;35mAll updates OK\e[0m"; fi
}

function composer_update_all() {
  echo -e "# \e[1;35mFull update via composer\e[0m"
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
