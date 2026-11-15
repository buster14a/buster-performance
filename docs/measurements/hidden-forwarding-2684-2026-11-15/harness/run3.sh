#!/bin/bash
# #2684 head3 tree (with the Tier 1 memmove fix): Develop build and the affected tests, each under its own hold; then the
# head3 record (harness3/record.sh) and the self-host qualification of head3.
set -uo pipefail
dir=~/buster-fast-bench/2684-claude
cd "$dir/head3"
export EXCLUSIVE_OWNER=claude-2684 EXCLUSIVE_TITLE="GitHub issue #2684 (head3)" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/2684"
X=~/buster-fast-bench/exclusive.sh
log="$dir/run3.log"
: > "$log"
step() { local name=$1; shift; echo "== $name start $(date -u +%T)" >> "$log"; "$@" > "$dir/3-$name.log" 2>&1; echo "== $name status $? $(date -u +%T)" >> "$log"; }
step build "$X" ./build.sh
test -x build/compiler || { echo "== no compiler" >> "$log"; touch "$dir/done3"; exit 1; }
step initializers "$X" timeout -k 5 1500 ./build/compiler test-checker --program-initializers
step ssa-typed "$X" timeout -k 5 600 ./build/compiler test-ssa-source --typed tests/interpreter/source.c
step ssa-tier1 "$X" timeout -k 5 600 ./build/compiler test-ssa-source --typed --tier1 -DBUSTER_INTERPRETER_LARGE_WORDS=64 tests/interpreter/source.c
step tier0 "$X" timeout -k 5 1500 ./build/compiler test-tier0 --cross-check
"$dir/harness3/record.sh" > "$dir/record3.log" 2>&1
echo "== record3 status $? $(date -u +%T)" >> "$log"
./build.sh print-sources > "$dir/selfhost3-sources.argv"
BUSTER_DEBUG_INFO=0 ./build.sh print-compile-flags --config Release > "$dir/selfhost3-flags.argv"
rm -rf "$dir/selfhost3-result"
"$X" timeout -k 10 1500 bash -c 'clang -std=c17 -O2 -Wall -Wextra -Werror -fno-strict-aliasing tools/ci/selfhost.c -o "$1/qualify3" && "$1/qualify3" "$(./build.sh print-output --config Release)" "$1/selfhost3-sources.argv" "$1/selfhost3-flags.argv" "$1/selfhost3-result" 900' _ "$dir" > "$dir/selfhost3.log" 2>&1
echo "== selfhost3 status $? $(date -u +%T)" >> "$log"
touch "$dir/done3"
