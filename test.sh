#!/bin/bash

phpVersions=("7.4" "8.1" "8.2")

for v in ${phpVersions[@]}; do
  echo Using docker run with "asup:$v"
  docker run asup:dev-$v
done