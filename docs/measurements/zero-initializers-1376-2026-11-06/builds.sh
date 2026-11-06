#!/bin/bash
# The three builds, each its own lock hold, one after another.
cd ~/buster-fast-bench/1376-opencode
for t in base head fill8; do echo "== $t"; ./build.sh $t; done
echo done
