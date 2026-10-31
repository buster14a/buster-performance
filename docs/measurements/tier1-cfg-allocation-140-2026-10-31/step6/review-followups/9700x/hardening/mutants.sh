#!/usr/bin/env bash
# mutants.sh TREE...: #989's review's mutants (apply.py), each applied to a copy of each TREE's sources, built and run
# against its test, each build and test one hold of the shared lock. Each mutant's line gives its test's exit status
# (non-zero: the test caught it) and its first failure lines.
set -u
export LC_ALL=C
cd ~/buster-fast-bench/claude-140-cfg || exit 1
export EXCLUSIVE_OWNER=claude-140-cfg
export EXCLUSIVE_TITLE="Tier 1 #141: #989 review's mutants"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/989
lock=~/buster-fast-bench/exclusive.sh
for tree in "$@"; do
    for m in request emit fit straight branch cfg; do
        case $m in
        request | emit | fit) t=test-tier1-select ;;
        *) t=test-tier1-emit ;;
        esac
        d=$PWD/mut-$tree-$m
        rm -rf "$d" && mkdir -p "$d"
        tar -C "$tree" --exclude=./build -cf - . | tar -C "$d" -xf -
        if ! python3 mutants-apply.py "$d" $m > "$d/apply.log" 2>&1; then
            echo "$tree $m: not applied: $(cat "$d/apply.log")"
            continue
        fi
        "$lock" bash -c "cd $d && BUSTER_DEBUG_INFO=0 ./build.sh > build.log 2>&1; echo \"exit \$?\" >> build.log"
        if grep -q '^exit 0' "$d/build.log"; then
            "$lock" bash -c "cd $d && ./build/compiler $t > test.log 2>&1; echo \"exit \$?\" >> test.log"
            echo "$tree $m $t: $(tail -1 "$d/test.log"); $(grep -v 'operand cases' "$d/test.log" | grep -m4 -E 'tier1|failures' | tr '\n' '|' | cut -c1-400)"
        else
            echo "$tree $m: build failed: $(grep -m3 -E 'error|exit' "$d/build.log" | tr '\n' '|' | cut -c1-300)"
        fi
        rm -rf "$d/build"
    done
done
echo done
