#!/bin/bash

# Check or set these values.
if ! [ -v ${GIT_AUTO_MERGE+x} ]; then echo "GIT_AUTO_MERGE provided with value: $GIT_AUTO_MERGE"; else GIT_AUTO_MERGE=0; fi
if ! [ -v ${GITLAB_HOST+x} ]; then echo "GITLAB_HOST provided with value: $GITLAB_HOST"; else GITLAB_HOST="https://gitlab.dazzle.be"; fi
if ! [ -v ${GITLAB_TOKEN+x} ]; then echo "GITLAB_TOKEN provided with value: $GITLAB_TOKEN"; else echo -e "# \e[1;31mGITLAB_TOKEN not provided.\e[0m"; exit 1; fi
if ! [ -v ${GITLAB_PROJECT_ID+x} ]; then echo "GITLAB_PROJECT_ID provided with value: $GITLAB_PROJECT_ID"; else echo -e "# \e[1;31mGITLAB_PROJECT_ID not provided.\e[0m"; exit 1; fi
if ! [ -v ${GIT_BRANCH_TARGET+x} ]; then echo "GIT_BRANCH_TARGET provided with value: $GIT_BRANCH_TARGET"; else echo -e "# \e[1;31mGIT_BRANCH_TARGET not provided.\e[0m"; exit 1; fi
if ! [ -v ${GIT_CLONE_URL+x} ]; then echo "GIT_CLONE_URL provided with value: $GIT_CLONE_URL"; else echo -e "# \e[1;31mGIT_CLONE_URL not provided.\e[0m"; exit 1; fi
if ! [ -v ${COMPOSER_UPDATE_CONSTRAINTS+x} ]; then echo "COMPOSER_UPDATE_CONSTRAINTS provided with value: $COMPOSER_UPDATE_CONSTRAINTS"; else echo -e "# \e[1;31mCOMPOSER_UPDATE_CONSTRAINTS not provided. Assuming 0.\e[0m"; COMPOSER_UPDATE_CONSTRAINTS=0; fi

# Output the version of software we need. This will fail if not installed and it is what we want.
composer --version
php --version
patch --version
