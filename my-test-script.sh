#!/usr/bin/env bash
## Test a NuttX Commit for Git Bisect

echo ; echo ; echo "--------------------------------------------------------------------------------"
echo "Testing Commit $(git rev-parse HEAD)"
echo "Running https://github.com/lupyuen/nuttx-bisect/blob/main/my-test-script.sh"
echo "Called by https://github.com/lupyuen/nuttx-bisect/blob/main/run.sh"
date -u

set -e  ## Exit when any command fails
set -x  ## Echo commands

git status
TZ=UTC0 \
  git --no-pager \
  log -1 \
  --date='format-local:%Y-%m-%dT%H:%M:%S' \
  --format="%cd | %H | %s"
nuttx_hash=$(git rev-parse HEAD)

## Visualise the Git Bisect
git bisect log

random_0_or_1=$(( $RANDOM % 2 ))
if (( "$random_0_or_1" == "0" )); then
  set +x ; echo "**** Simulate Error" ; set -x
  exit 0
else
  set +x ; echo "**** Simulate OK" ; set -x
  exit 1
fi
