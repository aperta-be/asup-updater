#!/bin/bash
#set -ex

GIT_BRANCH="master"

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

git clone --branch $GIT_BRANCH --progress --verbose git@gitlab.dazzle.be:dazzle/brrc-geoportal.git .

# Move to an security branch:
git checkout -b security/$(date +%s)

composer install --dry-run
if [[ $(composer install) ]]; then echo -e "# \e[1;35mComposer install succesfully!\e[0m"; else echo -e "# \e[1;31mComposer install failed... That's bad news.\e[0m"; exit 1; fi

echo -e "# \e[1;35mCheck if newer version is available\e[0m"
composer outdated --direct > outdated.txt
#echo -e "# \e[1;35mUpdate contraints\e[0m"
#php /usr/local/bin/uv.php
echo -e "# \e[1;35mActual update via composer\e[0m"
composer update drupal/core "drupal/core-*" --with-all-dependencies --dry-run
if [[ $(composer update drupal/core "drupal/core-*" --with-all-dependencies) == *"Could not apply patch!"* ]]; then echo -e "# \e[1;31mCould not apply patch!\e[0m"; exit 1; else echo "Core update OK"; fi

composer update --with-all-dependencies --dry-run
if [[ $(composer update --with-all-dependencies) == *"Could not apply patch!"* ]]; then echo -e "# \e[1;31mCould not apply patch!\e[0m"; exit 1; else echo "All updates OK"; fi

git branch -v
git status
git add .
git commit -m "Security: Automatic update"

# Cleanup.
rm outdated.txt

#while true; do echo "zZzZzZz"; sleep 2000; done

#####
# ssh xx@xxx -s "bash drush sql-dump"
# ssh xx@xxx -s "bash composer update"
# ssh xx@xxx -s "bash behat"
# If fails
# ssh xx@xxx -s "bash composer update"

# Mail on error?
# Watcher in MR?
