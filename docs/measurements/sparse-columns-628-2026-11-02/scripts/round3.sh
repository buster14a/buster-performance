#!/bin/bash
# round3.sh: build the review fix, then objects.sh and ab.sh against main dac5b770.
set -u
cd ~/buster-fast-bench/claude-628 || exit 1
./build.sh head-3950f15b
./objects.sh main-dac5b770 head-3950f15b obj3
./ab.sh main-dac5b770 head-3950f15b ab3
echo round3-done
