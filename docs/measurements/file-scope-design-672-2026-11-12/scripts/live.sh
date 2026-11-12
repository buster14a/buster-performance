#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# live.sh [ROUNDS]: the design's rule emulated on musl's preprocessed units (tools/attest.py: the declarations a memo
# of an earlier unit's readings attests and the unit's own code doesn't reach, blanked), inside one hold of the lock:
#   1. the emulation, its report in results/live/attest-musl.tsv;
#   2. both sets of units compiled through one path (scratch/cur, a link to each in turn), so that nothing in an object
#      or a diagnostic names its set: every object compared byte for byte, and the diagnostics' text;
#   3. ROUNDS rounds (default 5) of `-c` and `-fsyntax-only` of both under perf stat, CPU 2, in turn;
#   4. the probe's stages for the reduced units (src-probe, BUSTER_PROBE=1), 3 runs.
# And the same for the frozen sqlite3.c with a warm memo (attest.py --warm: every eligible declaration a hit, as a
# second compile of the unit with a memo kept from the first would find): a bound for a memo that outlives a process.
set -u
cd "$(dirname "$0")"
. ./common.sh
rounds=${1:-5}
out=$PWD/results/live
here=$PWD
mkdir -p "$out" scratch/objects-i scratch/objects-live scratch/sqlite-warm-in scratch/sqlite-warm
compiler=$PWD/src/build/compiler
probe=$PWD/src-probe/build/compiler
status=0
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
rm -rf scratch/musl-live
python3 tools/attest.py --order scratch/musl-units.txt scratch/musl-i scratch/musl-live "$out/attest-musl.tsv" > "$out/attest.log" 2>&1 || status=1
cp scratch/sqlite3.i scratch/sqlite-warm-in/sqlite3.i
python3 tools/attest.py --warm scratch/sqlite-warm-in scratch/sqlite-warm "$out/attest-sqlite-warm.tsv" >> "$out/attest.log" 2>&1 || status=1
cat scratch/musl-live/*.i | sha256sum > "$out/musl-live.sha256"
mapfile -t sources < scratch/musl-units.txt
names=("${sources[@]##*/}"); names=("${names[@]%.c}")
units=("${names[@]/#/$here/scratch/cur/}"); units=("${units[@]/%/.i}")
# 2. Objects and diagnostics.
compile_set()
{
    local set=$1 objects=$2
    rm -f scratch/cur; ln -s "$here/scratch/$set" scratch/cur
    (cd "$objects" && rm -f ./*.o && taskset -c 2 "$compiler" "${musl_i_options[@]}" --lanes 1 -c "${units[@]}" > "$out/$set.stdout.txt" 2> "$out/$set.stderr.txt"; echo "$set status $?" >> "$out/status.txt")
}
: > "$out/status.txt"
compile_set musl-i scratch/objects-i
compile_set musl-live scratch/objects-live
same=0; different=0; missing=0
: > "$out/objects-different.txt"
for n in "${names[@]}"; do
    if [[ ! -f scratch/objects-i/$n.o || ! -f scratch/objects-live/$n.o ]]; then missing=$((missing + 1)); echo "missing $n" >> "$out/objects-different.txt"
    elif cmp -s "scratch/objects-i/$n.o" "scratch/objects-live/$n.o"; then same=$((same + 1))
    else different=$((different + 1)); echo "different $n" >> "$out/objects-different.txt"; fi
done
echo "objects: $same the same bytes, $different different, $missing missing" > "$out/objects.txt"
cat scratch/objects-i/*.o | sha256sum >> "$out/objects.txt"
cat scratch/objects-live/*.o | sha256sum >> "$out/objects.txt"
if cmp -s "$out/musl-i.stderr.txt" "$out/musl-live.stderr.txt"; then echo "diagnostics: the same bytes ($(wc -c < "$out/musl-i.stderr.txt") bytes, $(grep -c 'warning:' "$out/musl-i.stderr.txt") warnings)" >> "$out/objects.txt"
else echo "diagnostics: different" >> "$out/objects.txt"; diff "$out/musl-i.stderr.txt" "$out/musl-live.stderr.txt" | head -40 > "$out/diagnostics.diff"; fi
# 3. The time.
run()
{
    local name=$1 round=$2 set=$3; shift 3
    rm -f scratch/cur; ln -s "$here/scratch/$set" scratch/cur
    (cd scratch/objects-live && taskset -c 2 perf stat -x, -o "$out/stat-$name-$round.csv" -e '{cycles:u,instructions:u,cycles:k,instructions:k}' -e task-clock,page-faults -- "$compiler" "${musl_i_options[@]}" --lanes 1 "$@" "${units[@]}" > /dev/null 2>&1; echo "$name $round status $?" >> "$out/status.txt")
}
for ((r = 1; r <= rounds; r += 1)); do
    run i-c $r musl-i -c
    run live-c $r musl-live -c
    run i-syntax $r musl-i -fsyntax-only
    run live-syntax $r musl-live -fsyntax-only
done
# 4. The stages.
rm -f scratch/cur; ln -s "$here/scratch/musl-live" scratch/cur
for r in 1 2 3; do
    (cd scratch/objects-live && BUSTER_PROBE=1 taskset -c 2 "$probe" "${musl_i_options[@]}" --lanes 1 -c "${units[@]}" > /dev/null 2> "$out/musl-live-c-p1-$r.txt")
done
rm -f scratch/cur; ln -s "$here/scratch/musl-i" scratch/cur
for r in 1 2 3; do
    (cd scratch/objects-live && BUSTER_PROBE=1 taskset -c 2 "$probe" "${musl_i_options[@]}" --lanes 1 -c "${units[@]}" > /dev/null 2> "$out/musl-i-c-p1-$r.txt")
done
rm -f scratch/cur
rm -rf scratch/objects-i scratch/objects-live
# sqlite3.c, a warm memo.
taskset -c 2 "$compiler" -c scratch/sqlite-warm-in/sqlite3.i -o scratch/sqlite-warm-in.o 2> "$out/sqlite-in.stderr.txt"; echo "sqlite in status $?" >> "$out/status.txt"
cp scratch/sqlite-warm/sqlite3.i scratch/sqlite-warm-in/sqlite3-warm.i
mkdir -p scratch/sw && cp scratch/sqlite-warm/sqlite3.i scratch/sw/sqlite3.i
(cd scratch/sqlite-warm-in && cp sqlite3.i keep.i && cp ../sw/sqlite3.i sqlite3.i && taskset -c 2 "$compiler" -c sqlite3.i -o ../sqlite-warm.o 2> "$out/sqlite-warm.stderr.txt"; echo "sqlite warm status $?" >> "$out/status.txt"; cp keep.i sqlite3.i; rm keep.i)
(cd scratch/sqlite-warm-in && taskset -c 2 "$compiler" -c sqlite3.i -o ../sqlite-in2.o 2> /dev/null)
if cmp -s scratch/sqlite-in2.o scratch/sqlite-warm.o; then echo "sqlite3 objects: the same bytes" >> "$out/objects.txt"; else echo "sqlite3 objects: different" >> "$out/objects.txt"; fi
sha256sum scratch/sqlite-in2.o scratch/sqlite-warm.o >> "$out/objects.txt"
for ((r = 1; r <= rounds; r += 1)); do
    taskset -c 2 perf stat -x, -o "$out/stat-sqlite-i-$r.csv" -e '{cycles:u,instructions:u,cycles:k,instructions:k}' -e task-clock,page-faults -- "$compiler" -c scratch/sqlite3.i -o scratch/sq.o > /dev/null 2>&1
    taskset -c 2 perf stat -x, -o "$out/stat-sqlite-warm-$r.csv" -e '{cycles:u,instructions:u,cycles:k,instructions:k}' -e task-clock,page-faults -- "$compiler" -c scratch/sw/sqlite3.i -o scratch/sq.o > /dev/null 2>&1
    BUSTER_PROBE=1 taskset -c 2 "$probe" --time-stages -c scratch/sw/sqlite3.i -o scratch/sq.o > /dev/null 2> "$out/sqlite-warm-$r.txt"
done
python3 tools/stat_medians.py "$out" > "$out/medians.tsv"
if ((status == 0)); then date -u +%FT%TZ > "$out/.done"; fi
exit $status
