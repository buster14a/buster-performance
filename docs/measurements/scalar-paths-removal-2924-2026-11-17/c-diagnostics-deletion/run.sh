#!/bin/bash
# #2924 C6, diagnostics' deletion (with #2959's fix): head (c6-diagnostics) against main caa8f6a3e (after #2956) on the
# 9700X, Release, every run under the lock on CPU 2. test-diagnostics by head; benchmark-diagnostics, main's default
# (the twin interleaved with the selected path) and head's (its one path), three processes each, and head's after 100 ms
# of scalar work; the disassembly by function, the sections and the functions in the start order.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: diagnostics' deletion" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
BASE=caa8f6a3e
mkdir -p compilers logs
for side in base head; do
    if [ ! -d src-$side ]; then git clone -q ../c6gate/src src-$side || exit 1; fi
    git -C src-$side fetch -q https://github.com/buster14a/buster main || { echo "fetch failed" >> logs/status.txt; exit 1; }
    git -C src-$side fetch -q "$D/c6del.bundle" "+refs/heads/c6-diagnostics:refs/heads/c6-diagnostics" || { echo "bundle failed" >> logs/status.txt; exit 1; }
done
git -C src-base checkout -q --detach "$BASE"
git -C src-head checkout -q --detach c6-diagnostics
printf 'base %s\nhead %s\n' "$(git -C src-base rev-parse HEAD)" "$(git -C src-head rev-parse HEAD)" > logs/commits.txt
for side in base head; do
    (cd src-$side && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/build-$side.log" 2>&1) || { echo "build $side failed" >> logs/status.txt; exit 1; }
    cp src-$side/build/compiler compilers/$side
done
sha256sum compilers/* > logs/compilers.sha256
(cd src-head && $L timeout -k 5 900 ../compilers/head test-diagnostics > "$D/logs/test-diagnostics.log" 2>&1; echo "test-diagnostics: $?" >> "$D/logs/status.txt")
for round in 1 2 3; do
    $L timeout -k 5 300 taskset -c 2 ./compilers/base benchmark-diagnostics > logs/bench-base-$round.log 2>&1; echo "bench base $round: $?" >> logs/status.txt
    $L timeout -k 5 300 taskset -c 2 ./compilers/head benchmark-diagnostics > logs/bench-head-$round.log 2>&1; echo "bench head $round: $?" >> logs/status.txt
    $L timeout -k 5 300 taskset -c 2 ./compilers/head benchmark-diagnostics --after-scalar 100 > logs/bench-head-after-$round.log 2>&1; echo "bench head after $round: $?" >> logs/status.txt
done
for side in base head; do
    objdump -d --no-show-raw-insn compilers/$side > /dev/shm/claude-2924-c6del-$side.s && python3 disassembly/split.py /dev/shm/claude-2924-c6del-$side.s /dev/shm/claude-2924-c6del-$side.json
    rm -f /dev/shm/claude-2924-c6del-$side.s
done
python3 disassembly/compare.py /dev/shm/claude-2924-c6del-base.json /dev/shm/claude-2924-c6del-head.json > logs/compare.txt
rm -f /dev/shm/claude-2924-c6del-*.json
for side in base head; do
    readelf -sW compilers/$side | awk '$4 == "FUNC"' > logs/$side-functions.txt
    readelf -SW compilers/$side > logs/$side-sections.txt
done
date -u +%FT%TZ > logs/.done
