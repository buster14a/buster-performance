#!/usr/bin/env bash
# #520's stage clock on the switch build, per mode: measure-compile's medians of 11 rounds, default and --time-stages.
set -u
source ./common.sh
for m in full vector scalar; do
    echo "## mode $m"
    BUSTER_532_CHECK=$m taskset -c 2 ./switch/build/compiler measure-compile --runs 11 -- "${options[@]}"
    echo "## mode $m status $?"
done
