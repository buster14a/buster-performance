#!/usr/bin/env bash
# #456: builds of the trees, each under the shared lock on its own, without debug info as the 9700X job builds.
cd "$(dirname "$0")" || exit 1
root="$(pwd)"
export EXCLUSIVE_OWNER=claude-perf-456 EXCLUSIVE_TITLE="#456 debug-row emission overhead" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/456
for tree in "$@"; do
    echo "== build $tree $(date +%T)"
    (cd "$root/$tree" && ~/buster-fast-bench/exclusive.sh env BUSTER_DEBUG_INFO=0 LC_NUMERIC=C ./build.sh > "$root/build-$tree.log" 2>&1)
    echo "== build $tree status $? $(date +%T)"
done
echo "== builds done $(date +%T)"
