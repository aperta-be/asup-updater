#!/bin/bash

# Configure GIT client.
function git_configure() {
  git config --global user.email "${GIT_USER_EMAIL}"
  git config --global user.name "${GIT_USER_NAME}"
}

# Create GIT directory.
function git_create_dir() {
  mkdir -p APP_CODE_DIRECTORY
  cd APP_CODE_DIRECTORY
}

function git_get_code() {
  git clone --branch $GIT_BRANCH_TARGET --progress --verbose $GIT_CLONE_URL .
  # Move to an security branch:
  git checkout -b $GIT_BRANCH_SOURCE
}

function git_commit_push() {
  # Start pushing back to Gitlab.
  git branch -v
  git status
  git add .
  git commit -m "Security: Automatic update on ${date}"
  if [[ $DRY_RUN == 1 ]]; then echo -e "# \e[1;33mDRYRUN: Normally a GIT push would have happened.\e[0m"; else git push origin $GIT_BRANCH_SOURCE; fi
}

function git_branch_merge() {
  if [[ $DRY_RUN == 1 ]]; then echo -e "# \e[1;33mDRYRUN: Normally a GIT MR/merge would have happened.\e[0m"; else building_blocks_gitlab_api; fi
}
