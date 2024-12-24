#!/usr/bin/env bash
## Test a NuttX Commit for Git Bisect

echo ; echo ; echo "--------------------------------------------------------------------------------"
echo "Testing Commit $(git rev-parse HEAD)"
echo "Running https://github.com/lupyuen/nuttx-bisect/blob/main/my-test-script.sh"
echo "Called by https://github.com/lupyuen/nuttx-bisect/blob/main/run.sh"
date -u

set -e  ## Exit when any command fails
set -x  ## Echo commands

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

## Randomly simulate OK or Error
random_0_or_1=$(( $RANDOM % 2 ))
if (( "$random_0_or_1" == "0" )); then
  set +x ; echo "**** Simulate OK" ; set -x
  exit 0
else
  set +x ; echo "**** Simulate Error" ; set -x
  exit 1
fi

## Or to simulate the article: Comment out the above chunk and Uncomment the chunk below...
## Commit #234 is Good
# if [[ "$nuttx_hash" == "94a2ce3641213cc702abc5c17b0f81a50c714a2e" ]]; then
#   set +x ; echo "**** Simulate OK" ; set -x
#   exit 0
## Commit #351 is Bad
# elif [[ "$nuttx_hash" == "1cfaff011ea5178ba3faffc10a33d9f52de80bfc" ]]; then
#   set +x ; echo "**** Simulate Error" ; set -x
#   exit 1
## Commit #292 is Bad
# elif [[ "$nuttx_hash" == "65a93e972cdc224bae1b47ee329727f51d18679b" ]]; then
#   set +x ; echo "**** Simulate Error" ; set -x
#   exit 1
## Commit #263 is Bad
# elif [[ "$nuttx_hash" == "1e265af8ebc90ed3353614300640abeda08a80b6" ]]; then
#   set +x ; echo "**** Simulate Error" ; set -x
#   exit 1
## Commit #248 is Bad
# elif [[ "$nuttx_hash" == "c70f3e3f984f1e837d03bca5444373d6ff94e96d" ]]; then
#   set +x ; echo "**** Simulate Error" ; set -x
#   exit 1
## Commit #241 is Bad
# elif [[ "$nuttx_hash" == "5d86bee5c7102b90a4376e630bd7c3cdf5e8395e" ]]; then
#   set +x ; echo "**** Simulate Error" ; set -x
#   exit 1
## Commit #237 is Bad
# elif [[ "$nuttx_hash" == "e7c2e7c5760bc3166192473347ecc71d16255d94" ]]; then
#   set +x ; echo "**** Simulate Error" ; set -x
#   exit 1
## Commit #236 is Bad
# elif [[ "$nuttx_hash" == "68d47ee8473bad7461e3ce53194afde089f8a033" ]]; then
#   set +x ; echo "**** Simulate Error" ; set -x
#   exit 1
## Commit #235 is Bad
# elif [[ "$nuttx_hash" == "74bac565397dea37ebfc3ac0b7b7532737738279" ]]; then
#   set +x ; echo "**** Simulate Error" ; set -x
#   exit 1
## All Other Commits are Bad (shouldn't come here)
# else
#   set +x ; echo "**** Simulate Error" ; set -x
#   exit 1
# fi
