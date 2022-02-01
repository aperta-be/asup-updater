#!/bin/bash
#set -ex

# Here we have the ability to set some variables via a local .env file. This is useful for development.
if [ -f /code/.env ]
then
  export $(cat /code/.env | sed 's/#.*//g' | xargs)
fi

ASUP_TIMESTAMP=$(date +%s)
if ! [ -v ${GIT_AUTO_MERGE+x} ]; then echo "GIT_AUTO_MERGE provided with value: $GIT_AUTO_MERGE"; else GIT_AUTO_MERGE=0; fi
if ! [ -v ${GITLAB_HOST+x} ]; then echo "GITLAB_HOST provided with value: $GITLAB_HOST"; else GITLAB_HOST="https://gitlab.dazzle.be"; fi
if ! [ -v ${GITLAB_TOKEN+x} ]; then echo "GITLAB_TOKEN provided with value: $GITLAB_TOKEN"; else echo -e "# \e[1;31mGITLAB_TOKEN not provided.\e[0m"; exit 1; fi
if ! [ -v ${GITLAB_PROJECT_ID+x} ]; then echo "GITLAB_PROJECT_ID provided with value: $GITLAB_PROJECT_ID"; else echo -e "# \e[1;31mGITLAB_PROJECT_ID not provided.\e[0m"; exit 1; fi
if ! [ -v ${GIT_BRANCH_TARGET+x} ]; then echo "GIT_BRANCH_TARGET provided with value: $GIT_BRANCH_TARGET"; else echo -e "# \e[1;31mGIT_BRANCH_TARGET not provided.\e[0m"; exit 1; fi

GIT_USER_NAME="ASUP"
GIT_USER_EMAIL="asup@support.dazzle.be"
GIT_BRANCH_SOURCE="security/$ASUP_TIMESTAMP"

# Write PHP variables file.
cat > /code/gitlab-api/variables.php <<EOL
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

  const MERGE_REQUEST_TITLE = 'Automated security MR $ASUP_TIMESTAMP';
  const MERGE_REQUEST_DESCRIPTION = 'Automated MR by ASUP';
EOL

composer --version
php --version
patch --version

# Before continuing, selftest.
selftest.sh

# Install keys
mkdir -p ~/.ssh
#echo "$SSH_PRIVATE_KEY" | tr -d '\r' > ~/.ssh/id_rsa
mv /mount/ssh/* ~/.ssh/
chmod 600 ~/.ssh/id_asup
eval `ssh-agent -s`
ssh-add ~/.ssh/id_asup
#ssh-keyscan -H $ssh_port "$ssh_host" >> ~/.ssh/known_hosts
ssh-keyscan -H 22 "gitlab.dazzle.be" >> ~/.ssh/known_hosts

mkdir -p /code/project
cd /code/project

git clone --branch $GIT_BRANCH_TARGET --progress --verbose git@gitlab.dazzle.be:dazzle/brrc-geoportal.git .

# Move to an security branch:
git checkout -b $GIT_BRANCH_SOURCE

composer install --dry-run
if [[ $(composer install) ]]; then echo -e "# \e[1;35mComposer install succesfully!\e[0m"; else echo -e "# \e[1;31mComposer install failed... That's bad news.\e[0m"; exit 1; fi

echo -e "# \e[1;35mCheck if newer version is available\e[0m"
composer outdated --direct > outdated.txt
#echo -e "# \e[1;35mUpdate contraints\e[0m"
#php /usr/local/bin/uv.php
echo -e "# \e[1;35mActual update via composer\e[0m"
composer update drupal/core "drupal/core-*" --with-all-dependencies --dry-run
if [[ $(composer update drupal/core "drupal/core-*" --with-all-dependencies) == *"Could not apply patch!"* ]]; then echo -e "# \e[1;31mCould not apply patch!\e[0m"; exit 1; else echo -e "# \e[1;35mCore update OK\e[0m"; fi

composer update --with-all-dependencies --dry-run
if [[ $(composer update --with-all-dependencies) == *"Could not apply patch!"* ]]; then echo -e "# \e[1;31mCould not apply patch!\e[0m"; exit 1; else echo -e "# \e[1;35mAll updates OK\e[0m"; fi

# Cleanup.
rm outdated.txt

# Configure GIT client.
git config --global user.email "${GIT_USER_EMAIL}"
git config --global user.name "${GIT_USER_NAME}"
# Start pushing back to Gitlab.
git branch -v
git status
git add .
git commit -m "Security: Automatic update on ${date}"
if [[ $DRY_RUN == 1 ]]; then echo -e "# \e[1;33mDRYRUN: Normally a GIT push would have happened.\e[0m"; else git push origin $GIT_BRANCH_SOURCE; fi

# Create MR and/or merge it.
if [[ $DRY_RUN == 1 ]]; then echo -e "# \e[1;33mDRYRUN: Normally a GIT MR/merge would have happened.\e[0m"; else php /usr/local/bin/gitlab-api.php; fi

if [[ $? == 0 ]]; then echo -e "# \e[1;35mMission accomplished.\e[0m"; else echo -e "# \e[1;31mSome last minute failure occurred. This is bad news.\e[0m"; fi

#while true; do echo "zZzZzZz"; sleep 2000; done

# Mail on error?
# Watcher in MR?
