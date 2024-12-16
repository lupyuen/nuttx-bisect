#!/usr/bin/env bash

set -e  ## Exit when any command fails
set -x  ## Echo commands

git status
TZ=UTC0 \
  git --no-pager \
  log -1 \
  --date='format-local:%Y-%m-%dT%H:%M:%S' \
  --format="%cd | %H | %s"
nuttx_hash=$(git rev-parse HEAD)

random_0_or_1=$(( $RANDOM % 2 ))
if (( "$random_0_or_1" == "0" )); then
  exit 0
else
  exit 1
fi
