#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# state.sh [ROUNDS]: what selects a run's page state, inside one hold of the lock, CPU 2. skip2.sh's rounds are in one
# of two states whichever variant runs: the process is given some 311 huge pages at its faults (musl's command) or
# none, with none refused, and takes 75,000 more page faults without them. ROUNDS rounds (default 8) of musl's command
# (the clean build, -c of the sources on one lane), each round once as it is and once with the address space's
# randomization off (setarch -R), under perf stat, with /proc/vmstat's counts before and after each run and the
# process's layout as the compiler starts (the first lines of /proc/self/maps of a `cat` run the same two ways, for
# what the randomization moves).
set -u
cd "$(dirname "$0")"
. ./common.sh
rounds=${1:-8}
out=$PWD/results/state
here=$PWD
mkdir -p "$out" scratch/objects-state
compiler=$PWD/src/build/compiler
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
sha256sum "$compiler" > "$out/compiler.sha256"
cat /sys/kernel/mm/transparent_hugepage/enabled /sys/kernel/mm/transparent_hugepage/defrag /proc/sys/kernel/randomize_va_space > "$out/settings.txt" 2>&1
thp()
{
    grep -E '^(thp_fault_alloc|thp_fault_fallback|thp_fault_fallback_charge|thp_split_page|thp_split_pmd|thp_zero_page_alloc|pgfault) ' /proc/vmstat | tr '\n' ' '
    echo
}
mapfile -t sources < scratch/musl-units.txt
cd scratch/objects-state || exit 1
for ((r = 1; r <= rounds; r += 1)); do
    thp > "$out/vmstat-musl-random-$r.txt"
    taskset -c 2 perf stat -x, -o "$out/stat-musl-random-$r.csv" -e '{cycles:u,instructions:u,cycles:k,instructions:k}' -e task-clock,page-faults -- "$compiler" "${musl_options[@]}" --lanes 1 -c "${sources[@]}" > /dev/null 2>&1
    thp >> "$out/vmstat-musl-random-$r.txt"
    thp > "$out/vmstat-musl-fixed-$r.txt"
    taskset -c 2 perf stat -x, -o "$out/stat-musl-fixed-$r.csv" -e '{cycles:u,instructions:u,cycles:k,instructions:k}' -e task-clock,page-faults -- setarch "$(uname -m)" -R "$compiler" "${musl_options[@]}" --lanes 1 -c "${sources[@]}" > /dev/null 2>&1
    thp >> "$out/vmstat-musl-fixed-$r.txt"
done
cd "$here" || exit 1
rm -rf scratch/objects-state
{
    echo "variant	round	page faults	kernel cycles	user cycles	CPU ms	huge pages given at a fault	refused"
    for v in random fixed; do
        for ((r = 1; r <= rounds; r += 1)); do
            awk -F, -v v="$v" -v r="$r" '$3 == "page-faults" { f = $1 } $3 == "cycles:k" { k = $1 } $3 == "cycles:u" { u = $1 } $3 == "task-clock" { t = $1 } END { printf "%s\t%s\t%s\t%s\t%s\t%s\t", v, r, f, k, u, t }' "$out/stat-musl-$v-$r.csv"
            awk 'NR == 1 { for (i = 1; i < NF; i += 2) a[$i] = $(i + 1) } NR == 2 { for (i = 1; i < NF; i += 2) b[$i] = $(i + 1) } END { printf "%d\t%d\n", b["thp_fault_alloc"] - a["thp_fault_alloc"], b["thp_fault_fallback"] - a["thp_fault_fallback"] }' "$out/vmstat-musl-$v-$r.txt"
        done
    done
} > "$out/rounds.tsv"
date -u +%FT%TZ > "$out/.done"
