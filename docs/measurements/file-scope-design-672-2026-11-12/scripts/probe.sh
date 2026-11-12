#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# probe.sh [RUNS]: counters by stage, read in the process (probe.patch's build, src-probe: rdpmc at every lap of the
# stage clock; a many-unit command's units share one clock on one lane), inside one hold of the lock, CPU 2:
#   musl's 1,336 units as one command: c, i-c, spine-c, one-c, empty-c (musl.sh's variants), RUNS runs each
#   (default 3) with BUSTER_PROBE=1, and one with BUSTER_PROBE=2 (the marks' minor faults too);
#   the frozen sqlite3.c: its source, its preprocessed text and that without bodies, --time-stages, RUNS runs each.
# The patched build without BUSTER_PROBE runs `c` once beside the clean build, for the patch's own cost.
set -u
cd "$(dirname "$0")"
. ./common.sh
runs=${1:-3}
out=$PWD/results/probe
here=$PWD
mkdir -p "$out" scratch/objects
clean=$PWD/src/build/compiler
probe=$PWD/src-probe/build/compiler
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
mapfile -t sources < scratch/musl-units.txt
names=("${sources[@]##*/}"); names=("${names[@]%.c}")
i_units=("${names[@]/#/$here/scratch/musl-i/}"); i_units=("${i_units[@]/%/.i}")
spine_units=("${names[@]/#/$here/scratch/musl-spine/}"); spine_units=("${spine_units[@]/%/.i}")
one_units=("${names[@]/#/$here/scratch/musl-one/}"); one_units=("${one_units[@]/%/.c}")
empty_units=("${names[@]/#/$here/scratch/musl-empty/}"); empty_units=("${empty_units[@]/%/.c}")
cd scratch/objects || exit 1
: > "$out/status.txt"
unit_run()
{
    local name=$1 mode=$2 r=$3; shift 3
    BUSTER_PROBE=$mode taskset -c 2 "$probe" "$@" > /dev/null 2> "$out/musl-$name-p$mode-$r.txt"
    echo "musl-$name p$mode $r status $?" >> "$out/status.txt"
}
for ((r = 1; r <= runs; r += 1)); do
    unit_run c 1 $r "${musl_options[@]}" --lanes 1 -c "${sources[@]}"
    unit_run i-c 1 $r "${musl_i_options[@]}" --lanes 1 -c "${i_units[@]}"
    unit_run spine-c 1 $r "${musl_i_options[@]}" --lanes 1 -c "${spine_units[@]}"
    unit_run one-c 1 $r "${musl_i_options[@]}" --lanes 1 -c "${one_units[@]}"
    unit_run empty-c 1 $r "${musl_i_options[@]}" --lanes 1 -c "${empty_units[@]}"
done
unit_run c 2 1 "${musl_options[@]}" --lanes 1 -c "${sources[@]}"
unit_run i-c 2 1 "${musl_i_options[@]}" --lanes 1 -c "${i_units[@]}"
unit_run spine-c 2 1 "${musl_i_options[@]}" --lanes 1 -c "${spine_units[@]}"
unit_run empty-c 2 1 "${musl_i_options[@]}" --lanes 1 -c "${empty_units[@]}"
for ((r = 1; r <= 3; r += 1)); do
    taskset -c 2 perf stat -x, -o "$out/stat-clean-$r.csv" -e '{cycles:u,instructions:u,cycles:k,instructions:k}' -e task-clock -- "$clean" "${musl_options[@]}" --lanes 1 -c "${sources[@]}" > /dev/null 2>&1
    taskset -c 2 perf stat -x, -o "$out/stat-patched-$r.csv" -e '{cycles:u,instructions:u,cycles:k,instructions:k}' -e task-clock -- "$probe" "${musl_options[@]}" --lanes 1 -c "${sources[@]}" > /dev/null 2>&1
done
cd "$here" || exit 1
rm -rf scratch/objects
sqlite_run()
{
    local name=$1 r=$2; shift 2
    BUSTER_PROBE=1 taskset -c 2 "$probe" --time-stages "$@" -o scratch/probe.o > /dev/null 2> "$out/sqlite-$name-$r.txt"
    echo "sqlite-$name $r status $?" >> "$out/status.txt"
}
for ((r = 1; r <= runs + 2; r += 1)); do
    sqlite_run source $r -c "${sqlite_options[@]}" "$sqlite/sqlite3.c"
    sqlite_run i $r -c scratch/sqlite3.i
    sqlite_run spine $r -c scratch/sqlite3-spine.i
done
date -u +%FT%TZ > "$out/.done"
