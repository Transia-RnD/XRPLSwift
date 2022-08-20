#!/usr/bin/env bash

# Credit: https://zwbetz.com/set-environment-variables-in-your-bash-shell-from-a-env-file/

# Show env vars
grep -v '^#' .env

# Export env vars
export $(grep -v '^#' .env | xargs)