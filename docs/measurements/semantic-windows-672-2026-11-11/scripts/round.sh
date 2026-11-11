#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# round.sh ROUND: one round of buster#672's falsifying experiment, run inside one hold of
# the 9700X's lock. For every unit size (rotated by ROUND) it measures LOOPS fresh
# compiles on one worker (CPU 2) and LOOPS compiles on each of eight workers (CPUs 0-7,
# one per physical core): user and kernel cycles and instructions of every compile
# (perf stat, inherited), then the same batch again under system-wide UMC CAS counters.
# Results go to results/rROUND/; a round's .done file is written last.
set -u
cd "$(dirname "$0")"
round=$1
dir=results/r$round
mkdir -p "$dir" out
CORE=task-clock,cycles:u,cycles:k,instructions:u,instructions:k,page-faults
UMC=amd_umc/umc_cas_cmd.rd/,amd_umc/umc_cas_cmd.wr/,amd_umc/umc_act_cmd.all/,amd_umc/umc_mem_clk/
SIZES=(0 1 4 16 64 350)
loops() { case $1 in 0|1) echo 200 ;; 4) echo 100 ;; 16) echo 40 ;; 64) echo 12 ;; 350) echo 4 ;; esac; }
export LC_ALL=C
status=0
head -1 /var/lib/buster-9700x/owner > "$dir/holder.txt"
measure()
{
    # measure NAME COMMAND...: core counters, then UMC, with each batch's wall time.
    local name=$1 t0 t1; shift
    t0=$(date +%s%N)
    perf stat -x, -o "$dir/$name.core.csv" -e "$CORE" -- "$@" || return 1
    t1=$(date +%s%N)
    echo "$(( (t1 - t0) / 1000 ))" > "$dir/$name.core.us"
    t0=$(date +%s%N)
    perf stat -a -x, -o "$dir/$name.umc.csv" -e "$UMC" -- "$@" || return 1
    t1=$(date +%s%N)
    echo "$(( (t1 - t0) / 1000 ))" > "$dir/$name.umc.us"
}
t0=$(date +%s%N)
perf stat -a -x, -o "$dir/idle.umc.csv" -e "$UMC" -- sleep 2 || status=1
t1=$(date +%s%N)
echo "$(( (t1 - t0) / 1000 ))" > "$dir/idle.umc.us"
n=${#SIZES[@]}
for ((s = 0; s < n; s += 1)); do
    copies=${SIZES[(s + round) % n]}
    l=$(loops "$copies")
    echo "$l" > "$dir/u$copies.loops"
    measure "u$copies.w1" taskset -c 2 ./worker.sh "$copies" "$l" c2 || { status=1; echo "u$copies w1 failed" >&2; }
    measure "u$copies.w8" ./fan.sh "$copies" "$l" 0 1 2 3 4 5 6 7 || { status=1; echo "u$copies w8 failed" >&2; }
done
if ((status == 0)); then date -u +%FT%TZ > "$dir/.done"; fi
exit $status
