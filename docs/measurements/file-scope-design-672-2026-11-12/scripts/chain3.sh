#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# chain3.sh [REPETITIONS]: chain2.sh again with the prototype's third version, inside one hold of the lock, CPU 2: the
# second version's reach still walked, from each reached declaration, every later declarer of each name it declares
# (98 cycles a token on sqlite3.c with a warm memo, results/chain2); this one keeps two cursors a name and passes each
# declarer once. What follows is chain2.sh's text. The
# first version's reach walked a name's every declarer from each declaration that spells the name: 2 cycles a token on
# musl's small units, 337 on the frozen sqlite3.c, whose 2,674 bodies each spell the same names (results/chain). This
# one walks each declarer once (a mark a name) and does nothing in a unit without a hit; it also makes each
# declaration's lists itself from the tokens (--scan), which --check compares with the emulation's. Each of musl's
# command (1,336 units, one memo) and sqlite3.c (one unit): the dump's lists, the scan's, the scan's with a warm memo;
# 3 runs of REPETITIONS (default 21) each.
set -u
cd "$(dirname "$0")"
. ./common.sh
repetitions=${1:-21}
out=$PWD/results/chain3
mkdir -p "$out" scratch/chain-sqlite
status=0
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
clang -std=c17 -O2 -march=native -Wall -Wextra -Werror -o scratch/chain tools/chain.c > "$out/build.log" 2>&1 || status=1
(cd tools && python3 chain_dump.py --order ../scratch/musl-units.txt ../scratch/musl-i ../scratch/musl.bcd) > "$out/dump-musl.txt" 2>&1 || status=1
cp scratch/sqlite3.i scratch/chain-sqlite/sqlite3.i
(cd tools && python3 chain_dump.py ../scratch/chain-sqlite ../scratch/sqlite.bcd) > "$out/dump-sqlite.txt" 2>&1 || status=1
sha256sum scratch/chain scratch/musl.bcd scratch/sqlite.bcd > "$out/sha256.txt"
taskset -c 2 scratch/chain --check scratch/musl.bcd 1 > "$out/musl-check.txt" 2>&1 || status=1
taskset -c 2 scratch/chain --check scratch/sqlite.bcd 1 > "$out/sqlite-check.txt" 2>&1 || status=1
for r in 1 2 3; do
    for input in musl sqlite; do
        taskset -c 2 scratch/chain scratch/$input.bcd "$repetitions" > "$out/$input-lists-$r.txt" 2>&1 || status=1
        taskset -c 2 scratch/chain --scan scratch/$input.bcd "$repetitions" > "$out/$input-scan-$r.txt" 2>&1 || status=1
        taskset -c 2 scratch/chain --warm --scan scratch/$input.bcd "$repetitions" > "$out/$input-scan-warm-$r.txt" 2>&1 || status=1
    done
done
taskset -c 2 perf stat -x, -o "$out/stat-musl-scan.csv" -e '{cycles:u,instructions:u,ex_ret_brn_misp:u,ls_dmnd_fills_from_sys.all:u}' -- scratch/chain --scan scratch/musl.bcd 101 > /dev/null 2>&1 || status=1
taskset -c 2 perf stat -x, -o "$out/stat-musl-scan-1.csv" -e '{cycles:u,instructions:u,ex_ret_brn_misp:u,ls_dmnd_fills_from_sys.all:u}' -- scratch/chain --scan scratch/musl.bcd 1 > /dev/null 2>&1 || status=1
rm -f scratch/musl.bcd scratch/sqlite.bcd
if ((status == 0)); then date -u +%FT%TZ > "$out/.done"; fi
exit $status
