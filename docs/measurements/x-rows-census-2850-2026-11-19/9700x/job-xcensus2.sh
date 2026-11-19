#!/bin/bash
# job-xcensus.sh REVISION: the X census on the 9700X: a Release build of main REVISION with the census's patch
# (census-x2.patch), and its lines on the three corpora (BUSTER_CENSUS_X=1, the reader-time sweeps of
# --window-contexts), aggregated to unique rows (aggregate-x2.py). Each run its own hold of the lock. No timing is read.
cd "$(dirname "$0")"
bench=$PWD
./build-label.sh xc2 "$1" census-x2.patch || exit 1
out=$bench/results/xc2
. ./corpora.sh
for c in sqlite3 lua musl; do
    case $c in
        sqlite3) arguments=$sqlite_arguments ;;
        lua) arguments=$lua_arguments ;;
        musl) arguments=$musl_arguments ;;
    esac
    ./lock.sh bash -c "BUSTER_CENSUS_X=1 taskset -c 2 $out/compiler measure-node-machine --shadow --passes 0 --window-contexts $arguments 2> $out/census-$c.err | python3 $bench/aggregate-x2.py $out/census-$c.tsv 2> $out/census-$c.log; echo status \${PIPESTATUS[0]} >> $out/census-$c.log"
done
echo job finished
