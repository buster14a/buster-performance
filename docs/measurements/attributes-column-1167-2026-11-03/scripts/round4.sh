#!/bin/bash
# round4.sh: build the #1167 head (a hold), then objects.sh and ab.sh against main b70deb47.
set -u
cd ~/buster-fast-bench/claude-628 || exit 1
./build.sh head-ebd8cf4e
./objects.sh main-b70deb47 head-ebd8cf4e obj4
./ab.sh main-b70deb47 head-ebd8cf4e ab4
echo round4-done
