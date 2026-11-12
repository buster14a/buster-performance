#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# chain.sh [REPETITIONS]: the design's own passes, timed by a prototype over the command's real units (tools/chain.c
# on tools/chain_dump.py's columns), inside one hold of the lock, CPU 2: musl's 1,336 preprocessed units with one memo
# for the command, and the frozen sqlite3.c as one unit (an empty memo: every declaration a miss). The prototype's
# counts must be tools/attest.py's.
set -u
cd "$(dirname "$0")"
. ./common.sh
repetitions=${1:-21}
out=$PWD/results/chain
mkdir -p "$out" scratch/chain-sqlite
status=0
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
clang -std=c17 -O2 -march=native -Wall -Wextra -Werror -o scratch/chain tools/chain.c > "$out/build.log" 2>&1 || status=1
(cd tools && python3 chain_dump.py --order ../scratch/musl-units.txt ../scratch/musl-i ../scratch/musl.bcd) > "$out/dump-musl.txt" 2>&1 || status=1
cp scratch/sqlite3.i scratch/chain-sqlite/sqlite3.i
(cd tools && python3 chain_dump.py ../scratch/chain-sqlite ../scratch/sqlite.bcd) > "$out/dump-sqlite.txt" 2>&1 || status=1
sha256sum scratch/chain scratch/musl.bcd scratch/sqlite.bcd > "$out/sha256.txt"
for r in 1 2 3; do
    taskset -c 2 scratch/chain scratch/musl.bcd "$repetitions" > "$out/musl-$r.txt" 2>&1 || status=1
    taskset -c 2 scratch/chain scratch/sqlite.bcd "$repetitions" > "$out/sqlite-$r.txt" 2>&1 || status=1
done
taskset -c 2 perf stat -x, -o "$out/stat-musl.csv" -e '{cycles:u,instructions:u,ex_ret_brn_misp:u,ls_dmnd_fills_from_sys.all:u}' -- scratch/chain scratch/musl.bcd 101 > /dev/null 2>&1 || status=1
taskset -c 2 perf stat -x, -o "$out/stat-musl-1.csv" -e '{cycles:u,instructions:u,ex_ret_brn_misp:u,ls_dmnd_fills_from_sys.all:u}' -- scratch/chain scratch/musl.bcd 1 > /dev/null 2>&1 || status=1
rm -f scratch/musl.bcd scratch/sqlite.bcd
if ((status == 0)); then date -u +%FT%TZ > "$out/.done"; fi
exit $status
