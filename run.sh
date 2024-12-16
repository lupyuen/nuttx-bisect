#!/usr/bin/env bash

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
git bisect run $script_dir/my-test-script.sh
