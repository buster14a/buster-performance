#!/bin/bash
# Builds each tree named on the command line (under the work directory), a lock hold each, as Buster's 9700X job does:
# without debug information, under the C locale's numbers.
D=~/buster-fast-bench/deferred-first-claude
export EXCLUSIVE_OWNER=claude-deferred-first
export EXCLUSIVE_TITLE="#113 deferred reader: the first lane reads the costliest part (builds)"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/113#issuecomment-6404376681"
for tree in "$@"; do
    ~/buster-fast-bench/exclusive.sh bash -c "cd $D/$tree && BUSTER_DEBUG_INFO=0 LC_NUMERIC=C ./build.sh" > "$D/build-$tree.txt" 2>&1
    echo "$tree exit=$? $(date -Is)" >> "$D/builds.txt"
done
echo done >> "$D/builds.txt"
