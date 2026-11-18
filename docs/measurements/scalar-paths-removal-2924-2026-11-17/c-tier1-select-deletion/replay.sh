#!/bin/bash
# The 09:13 run's selection benchmarks again, in run.sh's order and environment, five rounds; then fresh copies of each
# executable (a file's page-cache state can change its rate); then the rebased head (head2) built, and its source
# benchmark on sqlite3.c and Lua, whose bottom-up rewrite check now includes the links' definition.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: Tier 1's selection" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
mkdir -p replay
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
lua=$D/../c3pr/inputs/lua-5.4.8/src
H=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
for round in 1 2 3 4 5; do
    $L timeout -k 5 900 taskset -c 2 ./compilers/base benchmark-tier1-select-source --only select "${H[@]}" "$sqlite/sqlite3.c" > replay/source-base-$round.log 2>&1
    echo "source base $round: $?" >> replay/status.txt
    $L timeout -k 5 900 taskset -c 2 ./compilers/head benchmark-tier1-select-source "${H[@]}" "$sqlite/sqlite3.c" > replay/source-head-$round.log 2>&1
    echo "source head $round: $?" >> replay/status.txt
    for side in base head; do
        $L timeout -k 5 900 taskset -c 2 ./compilers/$side benchmark-tier1-select --only vector > replay/select-$side-$round.log 2>&1
        echo "select $side $round: $?" >> replay/status.txt
    done
done
for copy in 1 2 3; do
    for side in base head; do
        cp compilers/$side replay/$side-copy-$copy
        $L timeout -k 5 900 taskset -c 2 ./replay/$side-copy-$copy benchmark-tier1-select --only vector > replay/select-$side-copy-$copy.log 2>&1
        echo "select $side copy $copy: $?" >> replay/status.txt
        rm -f replay/$side-copy-$copy
    done
done
git -C src-head fetch -q https://github.com/buster14a/buster main || { echo "fetch failed" >> replay/status.txt; exit 1; }
git -C src-head fetch -q "$D/c7b2.bundle" "+refs/heads/c7b-final:refs/heads/c7b-final2" || { echo "bundle failed" >> replay/status.txt; exit 1; }
git -C src-head checkout -q --detach c7b-final2 && git -C src-head reset -q --hard
git -C src-head rev-parse HEAD > replay/head2.txt
(cd src-head && $L timeout -k 5 1500 ./build.sh --config Release > "$D/replay/build-head2.log" 2>&1) || { echo "build head2 failed" >> replay/status.txt; exit 1; }
cp src-head/build/compiler compilers/head2
$L timeout -k 5 900 taskset -c 2 ./compilers/head2 benchmark-tier1-select-source "${H[@]}" "$sqlite/sqlite3.c" > replay/source-head2-sqlite.log 2>&1
echo "source head2 sqlite: $?" >> replay/status.txt
$L timeout -k 5 900 taskset -c 2 ./compilers/head2 benchmark-tier1-select-source "${H[@]}" "$lua"/*.c > replay/source-head2-lua.log 2>&1
echo "source head2 lua: $?" >> replay/status.txt
$L timeout -k 5 900 taskset -c 2 ./compilers/head2 benchmark-tier1-select --only vector > replay/select-head2.log 2>&1
echo "select head2: $?" >> replay/status.txt
date -u +%FT%TZ > replay/.done
