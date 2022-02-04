#!/bin/bash

function ssh_keys_install() {
  # Install keys
  mkdir -p ~/.ssh
  #echo "$SSH_PRIVATE_KEY" | tr -d '\r' > ~/.ssh/id_rsa
  mv /mount/ssh/* ~/.ssh/
  chmod 600 ~/.ssh/id_asup
  eval `ssh-agent -s`
  ssh-add ~/.ssh/id_asup
}

function ssh_keys_validate() {
  #ssh-keyscan -H $ssh_port "$ssh_host" >> ~/.ssh/known_hosts
  ssh-keyscan -H 22 "gitlab.dazzle.be" >> ~/.ssh/known_hosts
}
