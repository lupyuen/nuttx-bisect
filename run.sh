#!/usr/bin/env bash
## Run Git Bisect on NuttX

set -e  ## Exit when any command fails
set -x  ## Echo commands

## TODO: Bisect CI Job
job=risc-v-05
nuttx_hash=6554ed4d668e0c3982aaed8d8fb4b8ae81e5596c
apps_hash=1c7a7f7529475b0d535e2088a9c4e1532c487156
sudo ./run-job-bisect.sh $job $nuttx_hash $apps_hash
exit

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
git bisect start
git bisect bad HEAD
git bisect good 656883fec5561ca91502a26bf018473ca0229aa4

## Run the Git Bisect automatically
git bisect run $script_dir/my-test-script.sh

## Visualise the Git Bisect
git bisect log
