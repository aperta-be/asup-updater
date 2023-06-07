#!/bin/bash

# Check or fall back and set those values.
echo -e "# \e[1;35mEnvironment variables.\e[0m"
echo "SELF_TEST provided with value: $SELF_TEST"
echo "DRY_RUN provided with value: $DRY_RUN"
echo "VERBOSE provided with value: $VERBOSE"

if ! [ -v ${COMPOSER_UPDATE_CONSTRAINTS+x} ]; then
  echo "COMPOSER_UPDATE_CONSTRAINTS provided with value: $COMPOSER_UPDATE_CONSTRAINTS"
else
  echo -e "# \e[1;31mCOMPOSER_UPDATE_CONSTRAINTS not provided. Assuming 0.\e[0m"
  COMPOSER_UPDATE_CONSTRAINTS=0
fi

if ! [ -v ${APP_PUBLIC_ROOT_DIRECTORY+x} ]; then
  if [[ $APP_PUBLIC_ROOT_DIRECTORY == 0 ]]; then
    echo "APP_PUBLIC_ROOT_DIRECTORY (0) default to GIT root: $APP_CODE_DIRECTORY"
    APP_PUBLIC_ROOT_DIRECTORY=$APP_CODE_DIRECTORY
  else
    echo "APP_PUBLIC_ROOT_DIRECTORY provided with value: $APP_PUBLIC_ROOT_DIRECTORY"
    APP_PUBLIC_ROOT_DIRECTORY=$APP_CODE_DIRECTORY/$APP_PUBLIC_ROOT_DIRECTORY
  fi
else
  echo -e "# \e[1;31mAPP_PUBLIC_ROOT_DIRECTORY not provided. Assuming web.\e[0m"
  APP_PUBLIC_ROOT_DIRECTORY="web"
fi

if ! [ -v ${MATTERMOST_HOOK+x} ]; then
  echo "MATTERMOST_HOOK provided with value: ${MATTERMOST_HOOK::-18}..."
else
  MATTERMOST_HOOK='https://mattermost.dazzle.be/hooks/33akt56za7gu7dmxg1wa5bedtr'
  echo "MATTERMOST_HOOK provided with value: ${MATTERMOST_HOOK::-18}..."
fi

if ! [ -v ${GIT_AUTO_MERGE+x} ]; then
  echo "GIT_AUTO_MERGE provided with value: $GIT_AUTO_MERGE"
else
  GIT_AUTO_MERGE=0
  echo "GIT_AUTO_MERGE not provided fallback to: $GIT_AUTO_MERGE"
fi

if ! [ -v ${VCS_PROVIDER+x} ]; then
  echo "VCS_PROVIDER provided with value: $VCS_PROVIDER"
else
  if ! [ -v ${CI+x} ]; then
    VCS_PROVIDER="gitlab"
    echo "VCS_PROVIDER not provided. Assuming VCS is gitlab as the container executed from a pipeline: $VCS_PROVIDER"
  else
    echo -e "# \e[1;31mVCS_PROVIDER not provided. This is fatal.\e[0m"
    exit 1
  fi
fi

if ! [ -v ${GIT_HOST+x} ]; then
  echo "GIT_HOST provided with value: $GIT_HOST"
else
  if ! [ -v ${CI_SERVER_HOST+x} ]; then
    GIT_HOST=$CI_SERVER_HOST
    echo "GIT_HOST provided by gitlab CI with value: $CI_SERVER_HOST"
  else
    echo -e "# \e[1;31mGIT_HOST not provided. This is fatal.\e[0m"
    exit 1
  fi
fi

if ! [ -v ${GIT_NAMESPACE+x} ]; then
  echo "GIT_NAMESPACE provided with value: $GIT_NAMESPACE"
else
  if ! [ -v ${CI_PROJECT_NAMESPACE+x} ]; then
    GIT_NAMESPACE=$CI_PROJECT_NAMESPACE
    echo "GIT_NAMESPACE provided by gitlab CI with value: $GIT_NAMESPACE"
  else
    echo -e "# \e[1;31GIT_NAMESPACE not provided. This is fatal.\e[0m"
    exit 1
  fi
fi

if ! [ -v ${GIT_PROJECT+x} ]; then
  echo "GIT_PROJECT provided with value: $GIT_PROJECT"
else
  if ! [ -v ${CI_PROJECT_NAME+x} ]; then
    GIT_PROJECT=$CI_PROJECT_NAME
    echo "GIT_PROJECT provided by gitlab CI with value: $CI_PROJECT_NAME"
  else
    echo -e "# \e[1;31mGIT_PROJECT not provided. This is fatal.\e[0m"
    exit 1
  fi
fi

if ! [ -v ${GIT_BRANCH_TARGET+x} ]; then
  echo "GIT_BRANCH_TARGET provided with value: $GIT_BRANCH_TARGET"
else
  if ! [ -v ${CI_COMMIT_BRANCH+x} ]; then
    GIT_BRANCH_TARGET=$CI_COMMIT_BRANCH
    echo "GIT_BRANCH_TARGET provided by gitlab CI with value: $CI_COMMIT_BRANCH"
  else
    echo -e "# \e[1;31mGIT_BRANCH_TARGET not provided. This is fatal.\e[0m"
    exit 1
  fi
fi

if ! [ -v ${GIT_CLONE_URL+x} ]; then
  echo "GIT_CLONE_URL provided with value: $GIT_CLONE_URL"
else
  if ! [ -v ${CI_SERVER_HOST+x} ] && ! [ -v ${CI_PROJECT_PATH+x} ]; then
    GIT_CLONE_URL="git@"$CI_SERVER_HOST":"$CI_PROJECT_PATH".git"
    echo "GIT_CLONE_URL was built by gitlab CI with value: $GIT_CLONE_URL"
  else
    echo -e "# \e[1;31mGIT_CLONE_URL not provided. This is fatal.\e[0m"
    exit 1
  fi
fi

if ! [ -v ${GIT_APERTA_USER+x} ]; then
  echo "GIT_APERTA_USER provided with value: $GIT_APERTA_USER"
else
  GIT_APERTA_USER="apertabot"
  echo "GIT_APERTA_USER fallback to CI user: $GIT_APERTA_USER"
fi

if ! [ -v ${GIT_APERTA_TOKEN+x} ]; then
  echo "GIT_APERTA_TOKEN provided with value: $GIT_APERTA_TOKEN"
else
  echo -e "# \e[1;31mGIT_APERTA_TOKEN not provided. This is fatal.\e[0m"
  exit 1
fi

if ! [ -v ${SSH_PUBLIC_KEY+x} ]; then echo "SSH_PUBLIC_KEY provided with value: $SSH_PUBLIC_KEY"; else
  echo -e "# \e[1;31mSSH_PUBLIC_KEY not provided. Assuming default.\e[0m"
  SSH_PUBLIC_KEY=0
fi
if ! [ -v ${SSH_PRIVATE_KEY+x} ]; then echo "SSH_PRIVATE_KEY provided, but not printing here for security reasons."; else
  echo -e "# \e[1;31mSSH_PRIVATE_KEY not provided. Assuming default.\e[0m"
  SSH_PRIVATE_KEY=0
fi

# Output the version of software we need. This will fail if not installed and it is what we want.
echo -e "# \e[1;35mEnvironment applications.\e[0m"
php --version
composer --version
patch --version
