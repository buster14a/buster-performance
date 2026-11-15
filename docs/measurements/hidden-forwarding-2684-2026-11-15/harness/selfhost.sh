#!/bin/bash
# selfhost.sh: the self-host qualification (tools/ci/selfhost.c, as selfhost.yml runs it) of the head tree's Release
# compiler, in one hold of the 9700X lock (its gate runs one command at a time under its own deadlines).
set -uo pipefail
dir=~/buster-fast-bench/2684-claude
cd "$dir/head"
export EXCLUSIVE_OWNER=claude-2684 EXCLUSIVE_TITLE="#2684 self-host qualification" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2684
./build.sh print-sources > "$dir/selfhost-sources.argv"
BUSTER_DEBUG_INFO=0 ./build.sh print-compile-flags --config Release > "$dir/selfhost-flags.argv"
rm -rf "$dir/selfhost-result"
~/buster-fast-bench/exclusive.sh timeout -k 10 1500 bash -c 'clang -std=c17 -O2 -Wall -Wextra -Werror -fno-strict-aliasing tools/ci/selfhost.c -o "$1/qualify" && "$1/qualify" "$(./build.sh print-output --config Release)" "$1/selfhost-sources.argv" "$1/selfhost-flags.argv" "$1/selfhost-result" 900' _ "$dir" > "$dir/selfhost.log" 2>&1
echo "status $?" >> "$dir/selfhost.log"
touch "$dir/selfhost.done"
