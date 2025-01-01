#!/usr/bin/env bash
## Run Git Bisect on NuttX

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
git bisect start
git bisect bad HEAD
git bisect good 656883fec5561ca91502a26bf018473ca0229aa4

## Run the Git Bisect automatically
## Bisect with our Simulated Test Script
git bisect run $script_dir/my-test-script.sh

## Or with our Actual Test Script
## git bisect run $script_dir/start-job-bisect.sh

## Visualise the Git Bisect
git bisect log
exit

## NOTUSED
function NOTUSED {
  ## TODO: Bisect CI Job
  job=risc-v-05

  ## NuttX Commit #1: Runs OK
  ## nuttx_hash=6554ed4d668e0c3982aaed8d8fb4b8ae81e5596c

  ## NuttX Commit #2: Runs OK
  ## nuttx_hash=656883fec5561ca91502a26bf018473ca0229aa4

  ## NuttX Commit #3: Fails at test_ltp_interfaces_pthread_barrierattr_init_2_1
  ## https://github.com/apache/nuttx/issues/14808#issuecomment-2518119367
  ## test_open_posix/test_openposix_.py::test_ltp_interfaces_pthread_barrierattr_init_2_1 FAILED   [ 17%]
  nuttx_hash=79a1ebb9cd0c13f48a57413fa4bc3950b2cd5e0b

  ## Apps Commit #1: Runs OK
  apps_hash=1c7a7f7529475b0d535e2088a9c4e1532c487156

  ## Apps Commit #2: ???
  ## apps_hash=1c7a7f7529475b0d535e2088a9c4e1532c487156

  ## Apps Commit #3: ???
  ## https://github.com/apache/nuttx/issues/14808#issuecomment-2518119367
  ## apps_hash=ce217b874437b2bd60ad2a2343442506cd8b50b8

  sudo ./run-job-bisect.sh $job $nuttx_hash $apps_hash   
}
