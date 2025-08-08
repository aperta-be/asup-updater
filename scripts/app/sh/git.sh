#!/bin/bash

# Configure GIT client.
function git_configure() {
  git config --global user.email "${GIT_USER_EMAIL}"
  git config --global user.name "${GIT_USER_NAME}"
}

# Create GIT directory.
function git_create_dir() {
  mkdir -p $APP_CODE_DIRECTORY
  cd $APP_CODE_DIRECTORY
}

function git_get_code() {
  echo -e "# \e[1;35mClone repository $GIT_CLONE_URL branch $GIT_BRANCH_TARGET.\e[0m"
  # Add token to clone URL.
  GIT_CLONE_URL_WITH_TOKEN=$(echo $GIT_CLONE_URL | sed "s#https\?://#https://${GIT_USER}:${GIT_TOKEN}@#g" | tr -d \")
  if [ "$GIT_CLONE_URL" != "$GIT_CLONE_URL_WITH_TOKEN" ]; then
    echo "Clone URL use https protocol. Add token to clone URL."
  fi
  GCM_INTERACTIVE=never GIT_TERMINAL_PROMPT=0 git clone --branch $GIT_BRANCH_TARGET -q $GIT_CLONE_URL_WITH_TOKEN . || exit_code=$?
  if [[ $exit_code -gt 0 ]]; then
    echo -e "# \e[1;31mGit clone command exited with a non-zero status code: $exit_code\e[0m"
    echo $GIT_CLONE_URL_WITH_TOKEN
    exit 1
  fi
  # Move to an asup branch:
  git checkout -b $GIT_BRANCH_SOURCE
}

function git_commit_push() {
  # Start pushing back to Gitlab.
  git branch -v
  git status
  git add .
  git reset -- outdated.txt composer.json.before
  git commit -m "ASUP: Automatic update on $(date)"
  if [[ $DRY_RUN == 1 ]]; then
    echo -e "# \e[1;33mDRYRUN: Normally a GIT push would have happened.\e[0m"
  else
    echo -e "# \e[1;33mPush repository back to VCS.\e[0m"
    git push origin $GIT_BRANCH_SOURCE
  fi
}

function git_branch_merge() {
  if [[ $DRY_RUN == 1 ]]; then
    echo -e "# \e[1;33mDRYRUN: Normally a GIT MR/merge would have happened.\e[0m"
  else
    echo -e "# \e[1;33mCreate a MR/merge.\e[0m"
    # Use unified VCS API that supports multiple providers
    building_blocks_vcs_api
  fi
}

# Write VCS PHP variables file.
function git_write_vars_vcs() {
  cat >/code/api/variables.php <<EOL
    <?php
    /**
     * @file
     *
     * This file is generated.
     */
    const VCS_PROVIDER = '$VCS_PROVIDER';
    const GIT_HOST = '$GIT_HOST';
    const GIT_USER = '$GIT_USER';
    const GIT_TOKEN = '$GIT_TOKEN';
    const GIT_NAMESPACE = '$GIT_NAMESPACE';
    const GIT_PROJECT = '$GIT_PROJECT';
    const GIT_BRANCH_SOURCE = '$GIT_BRANCH_SOURCE';
    const GIT_BRANCH_TARGET = '$GIT_BRANCH_TARGET';
    const GIT_AUTO_MERGE = $GIT_AUTO_MERGE;
    const MERGE_REQUEST_TITLE = 'Automated ASUP Update $ASUP_TIMESTAMP';
    const MERGE_REQUEST_DESCRIPTION = 'Automated dependency updates by ASUP.\n\nThis merge request contains automated updates to project dependencies.';
EOL
}
