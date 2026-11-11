#!/bin/bash
# Times each converted command before (main's executable, oracle clang as traced children) and after (this branch's,
# its clang runs served), in check mode with a fresh cache each, one CPU each as CI's parts have, interleaved.
S=$SCRATCH
cd $BUSTER
base=build/base/compiler
after=build/served2/compiler
server=$PWD/build/served2/clang-server
out=$S/timing
mkdir -p $out
TIMEFORMAT='%R %U %S'
measure()
{
    local name=$1
    shift
    rm -rf $S/xdg-time && mkdir -p $S/xdg-time
    local times
    times=$( { time env BUSTER_PARALLEL_CPUS=1 XDG_CACHE_HOME=$S/xdg-time BUSTER_ORACLE_CACHE=check "$@" > $out/$name.log 2>&1; echo "status $?" > $out/$name.status; } 2>&1 )
    printf '%s %s %s %s\n' "$name" "$(cat $out/$name.status)" "$times" "$(uptime | sed 's/.*load average: //')" >> $out/times.txt
}
: > $out/times.txt
for round in 1 2; do
    for part in 1 2 3 4; do
        measure pp-part$part-base-$round $base test-preprocessor --clang --jobs 1 --part $part/4
        measure pp-part$part-served-$round $after test-preprocessor --clang --jobs 1 --part $part/4 --clang-server $server
    done
    measure parser-base-$round $base test-parser --clang
    measure parser-served-$round $after test-parser --clang --clang-server $server
done
