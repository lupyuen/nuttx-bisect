#!/usr/bin/env bash
## Test a NuttX Commit for Git Bisect

echo ; echo ; echo "--------------------------------------------------------------------------------"
echo "Testing Commit $(git rev-parse HEAD)"
echo "Running https://github.com/lupyuen/nuttx-bisect/blob/main/start-job-bisect.sh"
echo "Called by https://github.com/lupyuen/nuttx-bisect/blob/main/run.sh"
date -u

set -e  ## Exit when any command fails
set -x  ## Echo commands

## Get the Script Directory
script_path="${BASH_SOURCE}"
script_dir="$(cd -P "$(dirname -- "${script_path}")" >/dev/null 2>&1 && pwd)"

## Get the NuttX Hash (Commit ID)
nuttx_hash=$(git rev-parse HEAD)
git status
TZ=UTC0 \
  git --no-pager \
  log -1 \
  --date='format-local:%Y-%m-%dT%H:%M:%S' \
  --format="%cd | %H | %s"

## Visualise the Git Bisect
git bisect log

## Run the CI Job for the NuttX Commit
job=risc-v-05
apps_hash=1c7a7f7529475b0d535e2088a9c4e1532c487156
$script_dir/run-job-bisect.sh $job $nuttx_hash $apps_hash
