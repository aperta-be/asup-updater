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
  git clone --branch $GIT_BRANCH_TARGET --progress --verbose $GIT_CLONE_URL .
  # Move to an security branch:
  git checkout -b $GIT_BRANCH_SOURCE
}

function git_commit_push() {
  # Start pushing back to Gitlab.
  git branch -v
  git status
  git add .
  git reset -- outdated.txt composer.json.before
  git commit -m "ASUP: Automatic update on $(date)"
  if [[ $DRY_RUN == 1 ]]; then echo -e "# \e[1;33mDRYRUN: Normally a GIT push would have happened.\e[0m";
  else echo -e "# \e[1;33mPush repository back to VCS.\e[0m";
    git push origin $GIT_BRANCH_SOURCE;
  fi
}

function git_branch_merge() {
  if [[ $DRY_RUN == 1 ]]; then echo -e "# \e[1;33mDRYRUN: Normally a GIT MR/merge would have happened.\e[0m";
  else echo -e "# \e[1;33mCreate a MR/merge.\e[0m";
    case $VCS_PROVIDER in
      gitlab)
        building_blocks_gitlab_api
        ;;
      github)
        building_blocks_github_api
        ;;
    esac
  fi
}

# Write VCS PHP variables file.
function git_write_vars_vcs() {
  cat > /code/api/variables.php <<EOL
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

    const GITHUB_HOST = '$GITHUB_HOST';
    const GITHUB_OWNER = '$GITHUB_OWNER';
    const GITHUB_REPO = '$GITHUB_REPO';
    const GITHUB_ASUP_TOKEN = '$GITHUB_ASUP_TOKEN';

    const MERGE_REQUEST_TITLE = 'Automated security MR $ASUP_TIMESTAMP';
    const MERGE_REQUEST_DESCRIPTION = 'Automated MR by ASUP';
EOL
}