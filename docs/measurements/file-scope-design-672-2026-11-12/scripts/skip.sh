#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# skip.sh [ROUNDS]: the skip in the compiler's own reader, the decisions made outside, inside one hold of the lock,
# CPU 2. The patched build (probe.patch) takes BUSTER_PROBE_SKIPS, a file of each unit's top-level declarations to pass
# unread (tools/attest.py --skips: the emulation's skipped declarations, by their ordinal in the unit); the reader's
# walk then gets no visit mark at their tokens, which are ignored, as the design's skip would leave them. The tokens
# stay: lexed, parsed, and seen by every unit-wide pass. For each of musl's command (the sources, and the preprocessed
# units), the generated glibc units (the sources) and the frozen sqlite3.c (preprocessed, a warm memo's skips):
#   - every object and the diagnostics, read against skipped (the same build, the same input, the variable alone);
#   - ROUNDS rounds (default 5) each way in turn under perf stat;
#   - the probe's stages each way (3 runs).
# What it doesn't have: the design's passes, whose cost the prototype has (chain3.sh), and the memo, whose decisions
# are the emulation's.
set -u
cd "$(dirname "$0")"
. ./common.sh
rounds=${1:-5}
out=$PWD/results/skip
here=$PWD
mkdir -p "$out" scratch/objects-skip-a scratch/objects-skip-b scratch/skip-sqlite scratch/skip-tmp
probe=$PWD/src-probe/build/compiler
status=0
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
sha256sum "$probe" > "$out/compiler.sha256"
python3 tools/attest.py --order scratch/musl-units.txt --skips scratch/musl.skips scratch/musl-i scratch/skip-tmp/musl "$out/attest-musl.tsv" > "$out/attest.log" 2>&1 || status=1
python3 tools/attest.py --order scratch/glibc-units.txt --skips scratch/glibc.skips scratch/glibc-i scratch/skip-tmp/glibc "$out/attest-glibc.tsv" >> "$out/attest.log" 2>&1 || status=1
cp scratch/sqlite3.i scratch/skip-sqlite/sqlite3.i
python3 tools/attest.py --warm --skips scratch/sqlite.skips scratch/skip-sqlite scratch/skip-tmp/sqlite "$out/attest-sqlite-warm.tsv" >> "$out/attest.log" 2>&1 || status=1
rm -rf scratch/skip-tmp
sha256sum scratch/musl.skips scratch/glibc.skips scratch/sqlite.skips > "$out/skips.sha256"
: > "$out/status.txt"
: > "$out/objects.txt"
compare()
{
    # compare LABEL SKIPS NAMES OPTIONS... -- UNITS...: every object and the diagnostics, read and skipped.
    local label=$1 skips=$2 names_file=$3; shift 3
    local arguments=("$@")
    local same=0 different=0 missing=0 n
    (cd scratch/objects-skip-a && rm -f ./*.o && taskset -c 2 "$probe" "${arguments[@]}" > /dev/null 2> "$out/$label.read.stderr.txt"; echo "$label read status $?" >> "$out/status.txt")
    (cd scratch/objects-skip-b && rm -f ./*.o && BUSTER_PROBE_SKIPS="$skips" taskset -c 2 "$probe" "${arguments[@]}" > /dev/null 2> "$out/$label.skipped.stderr.txt"; echo "$label skipped status $?" >> "$out/status.txt")
    grep '^probe-skip' "$out/$label.skipped.stderr.txt" > "$out/$label.probe-skip.txt"
    grep -v '^probe-skip' "$out/$label.skipped.stderr.txt" > "$out/$label.skipped.diagnostics.txt"
    : > "$out/$label.objects-different.txt"
    while read -r n; do
        if [[ ! -f scratch/objects-skip-a/$n.o || ! -f scratch/objects-skip-b/$n.o ]]; then missing=$((missing + 1)); echo "missing $n" >> "$out/$label.objects-different.txt"
        elif cmp -s "scratch/objects-skip-a/$n.o" "scratch/objects-skip-b/$n.o"; then same=$((same + 1))
        else different=$((different + 1)); echo "different $n" >> "$out/$label.objects-different.txt"; fi
    done < "$names_file"
    echo "$label objects: $same the same bytes, $different different, $missing missing; $(cat "$out/$label.probe-skip.txt")" >> "$out/objects.txt"
    if cmp -s "$out/$label.read.stderr.txt" "$out/$label.skipped.diagnostics.txt"; then
        echo "$label diagnostics: the same bytes ($(wc -c < "$out/$label.read.stderr.txt") bytes, $(grep -c 'warning:' "$out/$label.read.stderr.txt") warnings, $(grep -c 'error:' "$out/$label.read.stderr.txt") errors)" >> "$out/objects.txt"
    else
        echo "$label diagnostics: different" >> "$out/objects.txt"; diff "$out/$label.read.stderr.txt" "$out/$label.skipped.diagnostics.txt" | head -60 > "$out/$label.diagnostics.diff"
    fi
}
timed()
{
    local label=$1 skips=$2; shift 2
    local arguments=("$@")
    local r
    for ((r = 1; r <= rounds; r += 1)); do
        (cd scratch/objects-skip-a && taskset -c 2 perf stat -x, -o "$out/stat-$label-read-$r.csv" -e '{cycles:u,instructions:u,cycles:k,instructions:k}' -e task-clock,page-faults -- "$probe" "${arguments[@]}" > /dev/null 2>&1)
        (cd scratch/objects-skip-b && BUSTER_PROBE_SKIPS="$skips" taskset -c 2 perf stat -x, -o "$out/stat-$label-skipped-$r.csv" -e '{cycles:u,instructions:u,cycles:k,instructions:k}' -e task-clock,page-faults -- "$probe" "${arguments[@]}" > /dev/null 2>&1)
    done
    for r in 1 2 3; do
        (cd scratch/objects-skip-a && BUSTER_PROBE=1 taskset -c 2 "$probe" "${arguments[@]}" > /dev/null 2> "$out/$label-read-p1-$r.txt")
        (cd scratch/objects-skip-b && BUSTER_PROBE=1 BUSTER_PROBE_SKIPS="$skips" taskset -c 2 "$probe" "${arguments[@]}" > /dev/null 2> "$out/$label-skipped-p1-$r.txt")
    done
}
mapfile -t sources < scratch/musl-units.txt
sed 's|.*/||; s|\.c$||' scratch/musl-units.txt > scratch/musl-names.txt
mapfile -t names < scratch/musl-names.txt
i_units=("${names[@]/#/$here/scratch/musl-i/}"); i_units=("${i_units[@]/%/.i}")
compare musl-c "$here/scratch/musl.skips" scratch/musl-names.txt "${musl_options[@]}" --lanes 1 -c "${sources[@]}"
compare musl-i "$here/scratch/musl.skips" scratch/musl-names.txt "${musl_i_options[@]}" --lanes 1 -c "${i_units[@]}"
timed musl-c "$here/scratch/musl.skips" "${musl_options[@]}" --lanes 1 -c "${sources[@]}"
timed musl-i "$here/scratch/musl.skips" "${musl_i_options[@]}" --lanes 1 -c "${i_units[@]}"
ls scratch/glibc-src | sed 's|\.c$||' > scratch/glibc-names.txt
mapfile -t gnames < scratch/glibc-names.txt
gsources=("${gnames[@]/#/$here/scratch/glibc-src/}"); gsources=("${gsources[@]/%/.c}")
compare glibc-c "$here/scratch/glibc.skips" scratch/glibc-names.txt --lanes 1 -c "${gsources[@]}"
timed glibc-c "$here/scratch/glibc.skips" --lanes 1 -c "${gsources[@]}"
echo sqlite3 > scratch/sqlite-names.txt
compare sqlite-warm "$here/scratch/sqlite.skips" scratch/sqlite-names.txt -c "$here/scratch/skip-sqlite/sqlite3.i"
timed sqlite-warm "$here/scratch/sqlite.skips" --time-stages -c "$here/scratch/skip-sqlite/sqlite3.i"
rm -rf scratch/objects-skip-a scratch/objects-skip-b
python3 tools/stat_medians.py "$out" > "$out/medians.tsv"
if ((status == 0)); then date -u +%FT%TZ > "$out/.done"; fi
exit $status
