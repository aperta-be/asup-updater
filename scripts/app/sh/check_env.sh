#!/bin/bash

# Here we have the ability to set some variables via a local .env file. This is useful for development.
if [ -f /usr/local/bin/.env ]
then
  export $(cat /usr/local/bin/.env | sed 's/#.*//g' | xargs)
fi
