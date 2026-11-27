#!/bin/bash
# run-builds.sh NAME:PATCHES... : each variant built under its own hold of the lock.
d=~/buster-fast-bench/3586-claude2
export EXCLUSIVE_OWNER=claude-3586 EXCLUSIVE_TITLE="Direct path arena tables (#3586)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3586
for spec in "$@"; do
    name=${spec%%:*}; rest=${spec#*:}
    [ "$rest" = "$spec" ] && rest=""
    IFS=',' read -r -a patches <<< "$rest"
    ~/buster-fast-bench/exclusive.sh timeout -k 5 1200 $d/build-variant.sh "$name" "${patches[@]}"
done
echo ALL-BUILDS-DONE
