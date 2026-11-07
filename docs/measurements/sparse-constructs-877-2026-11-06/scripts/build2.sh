#!/bin/bash
# #877: the rest of build.sh's builds, after it had built the driver, ebee03e2 at every offset and 2ffcd901 as it is and
# at offset 0. Its holds, one a build, waited about 11 minutes each under the lock's contention, so each hold here
# builds the next pending build of each remaining tree at once, each in its own worktree, otherwise as build.sh builds
# them (znver5, Release, no debug information; on every online CPU, which changes no output). Then build.sh's checks.
# Usage: build2.sh, which runs build2.sh hold under the lock for each round.
set -u
export LC_ALL=C
R=$HOME/buster-fast-bench/877-claude; L=$R/logs
export EXCLUSIVE_OWNER=claude-877 EXCLUSIVE_TITLE="#877 matched 9700X comparison of #1025 and #1067" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/877
export BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0
offsets="0 16 32 48 1040 2080 3120 4032"
trees="2ffcd901 d3086da6 59a48a56"
next() { # TREE: its first build without an executable, orig then the offsets
    local name
    for name in orig $offsets; do
        if [ ! -e $R/bin/$1/compiler-$name ]; then echo $name; return; fi
    done
}
one() { # TREE NAME
    local tree=$1 name=$2 defines=""
    if [ $name = orig ]; then
        git -C $R/trees/tree-$tree checkout -q -- src/buster/compiler/main.c
    else
        grep -q BUSTER_CHECKER_OFFSET $R/trees/tree-$tree/src/buster/compiler/main.c || git -C $R/trees/tree-$tree apply $R/checker-offset.patch
        defines="-DBUSTER_CHECKER_OFFSET=$name"
    fi
    (cd $R/trees/tree-$tree && BUSTER_BUILD_DEFINES="$defines" taskset -c 0-9,11-15 ./build.sh --config Release) > $L/build-$tree-$name.log 2>&1
    local status=$?
    echo "tree-$tree $name build status $status" >> $L/receipts.txt
    if [ $status -eq 0 ]; then
        mkdir -p $R/bin/$tree
        cp $R/trees/tree-$tree/build/compiler $R/bin/$tree/compiler-$name
        sha256sum $R/bin/$tree/compiler-$name >> $L/receipts.txt
    fi
}
if [ "${1:-}" = hold ]; then
    head -1 /var/lib/buster-9700x/owner >> $L/holds.txt
    for tree in $trees; do
        name=$(next $tree)
        if [ -n "$name" ]; then one $tree $name & fi
    done
    wait
    exit 0
fi
echo $$ > $R/build.pid
while :; do
    pending=""
    for tree in $trees; do pending="$pending$(next $tree)"; done
    [ -n "$pending" ] || break
    ~/buster-fast-bench/exclusive.sh $R/build2.sh hold
    if grep -q 'build status [^0]' $L/receipts.txt; then
        echo "build2: a build failed" >> $L/receipts.txt
        break
    fi
done
for tree in $trees; do
    if cmp -s $R/bin/$tree/compiler-orig $R/bin/$tree/compiler-0; then
        echo "tree-$tree compiler-0 is compiler-orig byte for byte" >> $L/receipts.txt
    else
        echo "tree-$tree compiler-0 DIFFERS from compiler-orig" >> $L/receipts.txt
    fi
    for n in $offsets; do
        printf 'tree-%s offset %s: %s\n' $tree $n "$(nm $R/bin/$tree/compiler-$n | awk '$3 == "check_input_run" || $3 == "check_program" { printf "%s %s ", $3, $1 }')"
    done >> $L/placements.txt
done
echo done > $L/build-done
