#!/bin/bash
# round2.sh: build both trees (a hold each), then objects.sh and ab.sh on them.
set -u
cd ~/buster-fast-bench/claude-628 || exit 1
./build.sh main-dac5b770
./build.sh head-67f7bf51
./objects.sh main-dac5b770 head-67f7bf51 obj2
./ab.sh main-dac5b770 head-67f7bf51 ab2
echo round2-done
