#!/bin/bash

function ssh_keys_install() {
  echo -e "# \e[1;35mInstall SSH keys.\e[0m"
  # Install keys
  mkdir -p ~/.ssh

  # If no public/private keys are provided, use the default ones.
  if [ "$SSH_PUBLIC_KEY" == 0 ] && [ "$SSH_PRIVATE_KEY" == 0 ]; then
    mv /mount/ssh/* ~/.ssh/
  else
    echo "$SSH_PUBLIC_KEY" | tr -d '\r' > ~/.ssh/id_asup.pub
    echo "$SSH_PRIVATE_KEY" | tr -d '\r' > ~/.ssh/id_asup
  fi

  chmod 600 ~/.ssh/id_asup
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_asup
}

function ssh_keys_validate() {
  echo -e "# \e[1;35mScan $GITLAB_HOST SSH keys.\e[0m"
  ssh-keyscan -H $GITLAB_HOST >> ~/.ssh/known_hosts
}
