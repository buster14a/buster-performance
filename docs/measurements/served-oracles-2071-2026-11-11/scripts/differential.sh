#!/bin/bash
# Differential runs of every converted command (check mode, fresh cache each), served beside the spawned runs.
S=$SCRATCH
cd $BUSTER
compiler=build/served2/compiler
server=$PWD/build/served2/clang-server
out=$S/differential2
mkdir -p $out
run()
{
    local name=$1
    shift
    rm -rf $S/xdg-diff && mkdir -p $S/xdg-diff
    local start=$(date +%s.%N)
    env BUSTER_PARALLEL_CPUS=1 XDG_CACHE_HOME=$S/xdg-diff BUSTER_ORACLE_CACHE=check "$@" > $out/$name.log 2>&1
    local status=$?
    local end=$(date +%s.%N)
    printf '%s: status %d, %.1f s, %s\n' "$name" $status "$(echo "$end - $start" | bc)" "$(grep 'clang server (' $out/$name.log | sed 's/.*differential): //')" >> $out/summary.txt
}
: > $out/summary.txt
for part in 1 2 3 4; do
    run pp-part$part $compiler test-preprocessor --clang --jobs 1 --part $part/4 --clang-server $server --differential
done
run parser $compiler test-parser --clang --clang-server $server --differential
run parser-files $compiler test-parser --clang --files-only tests/parser-handoff/pragma-heavy.c --clang-server $server --differential
run pp-units $compiler test-preprocessor --clang -target x86_64-pc-linux-gnu -march=native -Isrc -fwrapv -funsigned-char -DBUSTER_COMPLETE_DRIVER=1 src/buster/compiler/main.c src/buster/compiler/*_benchmark.c --clang-server $server --differential
