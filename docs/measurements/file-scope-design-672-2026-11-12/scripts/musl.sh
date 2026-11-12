#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# musl.sh [ROUNDS]: musl's 1,336 units as one command on one lane, pinned to CPU 2, inside one hold of the lock
# (after the first record's musl.sh): the command and its variants, ROUNDS rounds (default 5), each round every
# variant once in turn under `perf stat` (user and kernel cycles and instructions, the task clock, page faults), a run
# a process. The variants say which work a compile does:
#   c            -c of the sources (the baseline)
#   syntax       -fsyntax-only of the sources
#   i-c          -c of the preprocessed units (scratch/musl-i)
#   i-syntax     -fsyntax-only of the preprocessed units
#   spine-c      -c of the preprocessed units without their function bodies (scratch/musl-spine)
#   spine-syntax -fsyntax-only of them
#   one-c        -c of 1,336 units of one declaration each
#   empty-c      -c of 1,336 empty units
#   E            -E of each source to /dev/null, the 1,336 as 1,336 processes (a command of several files has no -E)
# and --time-stages once for `c` (the lanes' stage, the peak).
set -u
cd "$(dirname "$0")"
. ./common.sh
rounds=${1:-5}
out=$PWD/results/musl
here=$PWD
mkdir -p "$out" scratch/objects
compiler=$PWD/src/build/compiler
status=0
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
mapfile -t sources < scratch/musl-units.txt
names=("${sources[@]##*/}"); names=("${names[@]%.c}")
i_units=("${names[@]/#/$here/scratch/musl-i/}"); i_units=("${i_units[@]/%/.i}")
spine_units=("${names[@]/#/$here/scratch/musl-spine/}"); spine_units=("${spine_units[@]/%/.i}")
one_units=("${names[@]/#/$here/scratch/musl-one/}"); one_units=("${one_units[@]/%/.c}")
empty_units=("${names[@]/#/$here/scratch/musl-empty/}"); empty_units=("${empty_units[@]/%/.c}")
cd scratch/objects || exit 1
run()
{
    local name=$1 round=$2; shift 2
    taskset -c 2 perf stat -x, -o "$out/stat-$name-$round.csv" -e '{cycles:u,instructions:u,cycles:k,instructions:k}' -e task-clock,page-faults -- "$@" > /dev/null 2> "$out/stderr-$name-$round.txt"
    echo "$name $round status $?" >> "$out/status.txt"
}
: > "$out/status.txt"
for ((r = 1; r <= rounds; r += 1)); do
    run c $r "$compiler" "${musl_options[@]}" --lanes 1 -c "${sources[@]}"
    run syntax $r "$compiler" "${musl_options[@]}" --lanes 1 -fsyntax-only "${sources[@]}"
    run i-c $r "$compiler" "${musl_i_options[@]}" --lanes 1 -c "${i_units[@]}"
    run i-syntax $r "$compiler" "${musl_i_options[@]}" --lanes 1 -fsyntax-only "${i_units[@]}"
    run spine-c $r "$compiler" "${musl_i_options[@]}" --lanes 1 -c "${spine_units[@]}"
    run spine-syntax $r "$compiler" "${musl_i_options[@]}" --lanes 1 -fsyntax-only "${spine_units[@]}"
    run one-c $r "$compiler" "${musl_i_options[@]}" --lanes 1 -c "${one_units[@]}"
    run empty-c $r "$compiler" "${musl_i_options[@]}" --lanes 1 -c "${empty_units[@]}"
done
printf -v each '%q ' "$compiler" -E "${musl_options[@]}"
for ((r = 1; r <= 2; r += 1)); do
    taskset -c 2 perf stat -x, -o "$out/stat-E-$r.csv" -e '{cycles:u,instructions:u,cycles:k,instructions:k}' -e task-clock,page-faults -- \
        bash -c "while read -r f; do $each \"\$f\" -o /dev/null || exit 1; done < '$here/scratch/musl-units.txt'" > /dev/null 2> "$out/stderr-E-$r.txt"
    echo "E $r status $?" >> "$out/status.txt"
done
taskset -c 2 "$compiler" "${musl_options[@]}" --lanes 1 -c --time-stages "${sources[@]}" > /dev/null 2> "$out/c.stages.txt"; echo "stages status $?" >> "$out/status.txt"
ls | wc -l > "$out/objects.txt"
cd .. && rm -rf objects
grep -c 'warning:' "$out"/stderr-*-1.txt > "$out/warnings.txt"
date -u +%FT%TZ > "$out/.done"
exit $status
