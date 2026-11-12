#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# syscalls.sh: the system calls of musl's command and of its variants, counted by strace -c (its times are strace's,
# not the compile's: only the counts are used), and each one's page faults and peak, inside one hold of the lock.
set -u
cd "$(dirname "$0")"
. ./common.sh
out=$PWD/results/syscalls
here=$PWD
mkdir -p "$out" scratch/objects-sys
compiler=$PWD/src/build/compiler
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
mapfile -t sources < scratch/musl-units.txt
names=("${sources[@]##*/}"); names=("${names[@]%.c}")
i_units=("${names[@]/#/$here/scratch/musl-i/}"); i_units=("${i_units[@]/%/.i}")
spine_units=("${names[@]/#/$here/scratch/musl-spine/}"); spine_units=("${spine_units[@]/%/.i}")
empty_units=("${names[@]/#/$here/scratch/musl-empty/}"); empty_units=("${empty_units[@]/%/.c}")
cd scratch/objects-sys || exit 1
count()
{
    local name=$1; shift
    taskset -c 2 strace -f -c -o "$out/$name.strace.txt" "$compiler" "$@" > /dev/null 2>&1
    echo "$name status $?" >> "$out/status.txt"
    taskset -c 2 "$compiler" --time-stages "$@" > /dev/null 2> "$out/$name.stages.txt"
}
: > "$out/status.txt"
count c "${musl_options[@]}" --lanes 1 -c "${sources[@]}"
count i-c "${musl_i_options[@]}" --lanes 1 -c "${i_units[@]}"
count spine-c "${musl_i_options[@]}" --lanes 1 -c "${spine_units[@]}"
count empty-c "${musl_i_options[@]}" --lanes 1 -c "${empty_units[@]}"
count syntax "${musl_options[@]}" --lanes 1 -fsyntax-only "${sources[@]}"
cd "$here" && rm -rf scratch/objects-sys
date -u +%FT%TZ > "$out/.done"
