#!/bin/bash
# #877, second campaign: each hold builds the next pending offset of each of the three trees at once, as the first
# campaign's build2.sh did (znver5, Release, no debug information, every online CPU). Usage: v2-build.sh [hold]
set -u
export LC_ALL=C
R=$HOME/buster-fast-bench/877-claude; V=$R/v2; L=$V/logs
export EXCLUSIVE_OWNER=claude-877 EXCLUSIVE_TITLE="#877 local_map variants on the 9700X" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/877
export BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0
offsets="0 16 32 48 1040 2080 3120 4032"
trees="main b c"
next() {
    local n
    for n in $offsets; do if [ ! -e $V/bin/$1/compiler-$n ]; then echo $n; return; fi; done
}
one() {
    local tree=$1 n=$2
    (cd $V/trees/tree-$tree && BUSTER_BUILD_DEFINES="-DBUSTER_CHECKER_OFFSET=$n" taskset -c 0-9,11-15 ./build.sh --config Release) > $L/build-$tree-$n.log 2>&1
    local status=$?
    echo "tree-$tree $n build status $status" >> $L/receipts.txt
    if [ $status -eq 0 ]; then mkdir -p $V/bin/$tree; cp $V/trees/tree-$tree/build/compiler $V/bin/$tree/compiler-$n; sha256sum $V/bin/$tree/compiler-$n >> $L/receipts.txt; fi
}
if [ "${1:-}" = hold ]; then
    head -1 /var/lib/buster-9700x/owner >> $L/holds.txt
    for tree in $trees; do n=$(next $tree); if [ -n "$n" ]; then one $tree $n & fi; done
    wait
    exit 0
fi
exec 8> $V/build.lock
flock -n 8 || { echo "v2-build: another builder holds build.lock" >&2; exit 1; }
while :; do
    pending=""
    for tree in $trees; do pending="$pending$(next $tree)"; done
    [ -n "$pending" ] || break
    ~/buster-fast-bench/exclusive.sh $V/v2-build.sh hold
    if grep -q 'build status [^0]' $L/receipts.txt; then echo "v2-build: a build failed" >> $L/receipts.txt; exit 1; fi
done
for tree in $trees; do
    for n in $offsets; do
        printf 'tree-%s offset %s: %s\n' $tree $n "$(nm $V/bin/$tree/compiler-$n | awk '$3 == "check_input_run" || $3 == "check_program" || $3 == "check_lower_prepare" { printf "%s %s ", $3, $1 }')"
    done
done >> $L/placements.txt
echo done > $L/build-done
exec $V/v2-run.sh
