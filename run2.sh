#!/usr/bin/env bash
## Run Git Bisect on NuttX
## Must be run as `sudo`! (Because of Docker)

set -e  ## Exit when any command fails
set -x  ## Echo commands

## Get the Script Directory
script_path="${BASH_SOURCE}"
script_dir="$(cd -P "$(dirname -- "${script_path}")" >/dev/null 2>&1 && pwd)"

## Create the Temp Folder
tmp_dir=/tmp/nuttx-bisect
rm -rf $tmp_dir
mkdir $tmp_dir
cd $tmp_dir

## Checkout the NuttX Repo and NuttX Apps
git clone https://github.com/apache/nuttx
git clone https://github.com/apache/nuttx-apps apps
cd nuttx

## Define the Git Bisect boundaries
## Good Commit Runs OK: nuttx_hash=6554ed4d668e0c3982aaed8d8fb4b8ae81e5596c
## Bad Commit Fails: nuttx_hash=79a1ebb9cd0c13f48a57413fa4bc3950b2cd5e0b
git bisect start
git bisect good 6554ed4d668e0c3982aaed8d8fb4b8ae81e5596c
git bisect bad  79a1ebb9cd0c13f48a57413fa4bc3950b2cd5e0b

## Run the Git Bisect automatically
git bisect run $script_dir/start-job-bisect.sh

## Visualise the Git Bisect
git bisect log
