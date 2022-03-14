#!/bin/bash

# Executes composer install with a dry-run first.
function composer_install() {
  echo -e "# \e[1;35mComposer install...\e[0m"
  args=()
  [[ $VERBOSE -eq 0 ]] && args+=( '--quiet' )
  composer install "${args[@]}"
  if [[ $? -eq 0 ]]; then echo -e "# \e[1;35mComposer install successfully!\e[0m";
    else
      echo -e "# \e[1;31mComposer install failed... That's bad news.\e[0m";
    exit 1;
  fi
}

# Stores the result of outdated libraries in a file.
function composer_outdated() {
  echo -e "# \e[1;35mCheck if newer version is available...\e[0m"
  composer outdated --direct > outdated.txt
  cat outdated.txt
}

# Update composer.json constraints
function composer_update_constraints() {
  echo -e "# \e[1;35mUpdate constraints\e[0m"
  cat composer.json > composer.json.before
  building_blocks_composer_update_constraints
  diff composer.json.before composer.json
  # After the constraints are updated, we need to update the lock file.
  echo -e "# \e[1;35mUpdate composer.lock and run install --with-all-dependencies\e[0m"
  composer update --lock
}

function composer_update_all() {
  echo -e "# \e[1;35mFull update via composer...\e[0m"
  args=()
  [[ $VERBOSE -eq 0 ]] && args+=( '--quiet' )
  COMPOSER_UPDATE_CMD=$(composer update --with-all-dependencies "${args[@]}" 2>&1)
  [[ $VERBOSE -eq 0 ]] && echo "$COMPOSER_UPDATE_CMD"
  # If a patch can not be applied. Back off.
  if echo "$COMPOSER_UPDATE_CMD" | grep -q "Your requirements could not be resolved\|Could not apply patch!"; then
    COMPOSER_REPORT="Composer requirements check failed or could not apply patch!"
    echo -e "# \e[1;31m$COMPOSER_REPORT\e[0m"; #exit 1;
    else
      if echo "$COMPOSER_UPDATE_CMD" | grep -q "Nothing to install, update or remove"; then
        COMPOSER_REPORT="No updates required OK."
        echo -e "# \e[1;35m$COMPOSER_REPORT\e[0m";
        else
          COMPOSER_REPORT="Core update OK."
          echo -e "# \e[1;35m$COMPOSER_REPORT\e[0m";
      fi
  fi
}
