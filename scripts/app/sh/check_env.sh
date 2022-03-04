#!/bin/bash

# Here we have the ability to set some variables via a local .env file. This is useful for development.
if [ -f /usr/local/bin/.env ]
then
  echo -e "# \e[1;31mCaution this docker image compiled with .env file and all variables that exist on .env are static. Do not push to gitlab.\e[0m";
  set -o allexport; source /usr/local/bin/.env; set +o allexport
fi
