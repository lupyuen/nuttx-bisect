#!/usr/bin/env bash
## Run a NuttX CI Job with Docker
## Read the article: https://lupyuen.codeberg.page/articles/ci2.html

echo "Now running https://github.com/lupyuen/nuttx-bisect/blob/main/run-job-bisect.sh $1 $2 $3"
echo "Called by https://github.com/lupyuen/nuttx-bisect/blob/main/start-job-bisect.sh"
date -u

set -e  ## Exit when any command fails
set -x  ## Echo commands

# First Parameter is CI Job, like "risc-v-05"
job=$1
if [[ "$job" == "" ]]; then
  echo "ERROR: Job Parameter is missing (e.g. risc-v-05)"
  exit 1
fi

# Second Parameter is NuttX Repo Hash
nuttx_hash=$2
if [[ "$nuttx_hash" == "" ]]; then
  echo "ERROR: NuttX Repo Hash Parameter is missing"
  exit 1
fi

# Third Parameter is Apps Apps Hash
apps_hash=$3
if [[ "$apps_hash" == "" ]]; then
  echo "ERROR: NuttX Apps Hash Parameter is missing"
  exit 1
fi

## Download the Docker Image
sudo docker pull \
  ghcr.io/apache/nuttx/apache-nuttx-ci-linux:latest

## Run the CI in Docker Container
## If CI Test Hangs: Kill it after 1 hour
set +e  ## Ignore errors
sudo docker run -it \
  ghcr.io/apache/nuttx/apache-nuttx-ci-linux:latest \
  /bin/bash -c "
  set -e ;
  set -x ;
  uname -a ;
  cd ;
  pwd ;
  git clone https://github.com/apache/nuttx ;
  git clone https://github.com/apache/nuttx-apps apps ;
  echo Building nuttx @ $nuttx_hash / nuttx-apps @ $apps_hash ;
  pushd nuttx ; git reset --hard $nuttx_hash ; popd ;
  pushd apps  ; git reset --hard $apps_hash  ; popd ;
  pushd nuttx ; echo NuttX Source: https://github.com/apache/nuttx/tree/\$(git rev-parse HEAD)    ; popd ;
  pushd apps  ; echo NuttX Apps: https://github.com/apache/nuttx-apps/tree/\$(git rev-parse HEAD) ; popd ;
  sleep 10 ;
  cd nuttx/tools/ci ;
  ( sleep 3600 ; echo Killing pytest after timeout... ; pkill -f pytest )&
  (
    (./cibuild.sh -c -A -N -R testlist/$job.dat) || (res=\$? ; echo '***** JOB FAILED' ; exit \$res)
  )
"
res=$?
set -e  ## Exit when any command fails
set +x ; echo res=$res ; set -x

## Result the result to the caller
if [[ "$res" == "0" ]] ; then
  set +x ; echo "**** Return OK" ; set -x
  exit 0
else
  set +x ; echo "**** Return Error" ; set -x
  exit 1
fi
