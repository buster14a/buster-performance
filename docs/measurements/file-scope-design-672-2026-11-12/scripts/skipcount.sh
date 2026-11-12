#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# skipcount.sh: what skip.sh's runs skipped, by the patch's own count, inside one hold of the lock: skip.sh's skipped
# runs again, once each, with BUSTER_PROBE_SKIP_REPORT set (the counts on standard error at each unit's end: the units
# the reader saw, those whose count of top-level declarations wasn't the emulation's and so skipped nothing, those the
# file doesn't list, and the declarations and tokens skipped). skip.sh's build registered the report for the process's
# exit, which a compile leaves without running its exit handlers, so its runs have no count; this build is that one
# with the report moved (probe.patch as it is here). Every object is compared with skip.sh's again.
set -u
cd "$(dirname "$0")"
. ./common.sh
out=$PWD/results/skipcount
here=$PWD
mkdir -p "$out" scratch/objects-count-a scratch/objects-count-b
probe=$PWD/src-probe/build/compiler
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
sha256sum "$probe" scratch/musl.skips scratch/glibc.skips scratch/sqlite.skips > "$out/sha256.txt"
: > "$out/counts.txt"
count()
{
    local label=$1 skips=$2 names_file=$3; shift 3
    local same=0 different=0 missing=0 n
    (cd scratch/objects-count-a && rm -f ./*.o && taskset -c 2 "$probe" "$@" > /dev/null 2> /dev/null)
    (cd scratch/objects-count-b && rm -f ./*.o && BUSTER_PROBE_SKIPS="$skips" BUSTER_PROBE_SKIP_REPORT=1 taskset -c 2 "$probe" "$@" > /dev/null 2> "$out/$label.stderr.txt")
    while read -r n; do
        if [[ ! -f scratch/objects-count-a/$n.o || ! -f scratch/objects-count-b/$n.o ]]; then missing=$((missing + 1))
        elif cmp -s "scratch/objects-count-a/$n.o" "scratch/objects-count-b/$n.o"; then same=$((same + 1))
        else different=$((different + 1)); fi
    done < "$names_file"
    echo "$label: $(grep '^probe-skip' "$out/$label.stderr.txt" | tail -n 1); objects: $same the same bytes, $different different, $missing missing" >> "$out/counts.txt"
    grep -v '^probe-skip' "$out/$label.stderr.txt" | sha256sum >> "$out/counts.txt"
    rm -f "$out/$label.stderr.txt"
}
mapfile -t sources < scratch/musl-units.txt
mapfile -t names < scratch/musl-names.txt
i_units=("${names[@]/#/$here/scratch/musl-i/}"); i_units=("${i_units[@]/%/.i}")
count musl-c "$here/scratch/musl.skips" scratch/musl-names.txt "${musl_options[@]}" --lanes 1 -c "${sources[@]}"
count musl-i "$here/scratch/musl.skips" scratch/musl-names.txt "${musl_i_options[@]}" --lanes 1 -c "${i_units[@]}"
mapfile -t gnames < scratch/glibc-names.txt
gsources=("${gnames[@]/#/$here/scratch/glibc-src/}"); gsources=("${gsources[@]/%/.c}")
count glibc-c "$here/scratch/glibc.skips" scratch/glibc-names.txt --lanes 1 -c "${gsources[@]}"
count sqlite-warm "$here/scratch/sqlite.skips" scratch/sqlite-names.txt -c "$here/scratch/skip-sqlite/sqlite3.i"
rm -rf scratch/objects-count-a scratch/objects-count-b
date -u +%FT%TZ > "$out/.done"
