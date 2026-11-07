#!/bin/bash
# #877: the builds, each in its own hold of the lock, as the 9700X job's benchmarks build (znver5, Release, no debug
# information, CPUs 0-7). The driver once. Each measured tree first as it is (compiler-orig), then with #1233's
# BUSTER_CHECKER_OFFSET hunk of main.c (750f6d0b; these trees predate it) at eight offsets of the checker's code,
# #1233's (compiler-N). At offset 0 the hunk emits nothing, so compiler-0 must be compiler-orig byte for byte.
set -u
export LC_ALL=C
R=$HOME/buster-fast-bench/877-claude; L=$R/logs
echo $$ > $R/build.pid
export EXCLUSIVE_OWNER=claude-877 EXCLUSIVE_TITLE="#877 matched 9700X comparison of #1025 and #1067" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/877
export BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0
offsets="0 16 32 48 1040 2080 3120 4032"
build() { # tree name defines
    local tree=$1 name=$2
    (cd $R/trees/tree-$tree && BUSTER_BUILD_DEFINES="$3" ~/buster-fast-bench/exclusive.sh bash -c "head -1 /var/lib/buster-9700x/owner >> $L/holds.txt; taskset -c 0-7 ./build.sh --config Release" > $L/build-$tree-$name.log 2>&1)
    local status=$?
    echo "tree-$tree $name build status $status" >> $L/receipts.txt
    if [ $status -eq 0 ]; then
        mkdir -p $R/bin/$tree
        cp $R/trees/tree-$tree/build/compiler $R/bin/$tree/compiler-$name
        sha256sum $R/bin/$tree/compiler-$name >> $L/receipts.txt
    fi
}
mkdir -p $R/bin/driver
build ec5f0f6b driver ""
cp $R/bin/ec5f0f6b/compiler-driver $R/bin/driver/compiler
for tree in ebee03e2 2ffcd901 d3086da6 59a48a56; do
    git -C $R/trees/tree-$tree checkout -q -- src/buster/compiler/main.c
    build $tree orig ""
    git -C $R/trees/tree-$tree apply $R/checker-offset.patch
    for n in $offsets; do
        build $tree $n "-DBUSTER_CHECKER_OFFSET=$n"
    done
    if cmp -s $R/bin/$tree/compiler-orig $R/bin/$tree/compiler-0; then
        echo "tree-$tree compiler-0 is compiler-orig byte for byte" >> $L/receipts.txt
    else
        echo "tree-$tree compiler-0 DIFFERS from compiler-orig" >> $L/receipts.txt
    fi
    # Where the checker's code starts in each build: its section's first function's address, and check_input_run's.
    for n in $offsets; do
        printf 'tree-%s offset %s: %s\n' $tree $n "$(nm $R/bin/$tree/compiler-$n | awk '$3 == "check_input_run" || $3 == "check_program" { printf "%s %s ", $3, $1 }')"
    done >> $L/placements.txt
done
echo done > $L/build-done
