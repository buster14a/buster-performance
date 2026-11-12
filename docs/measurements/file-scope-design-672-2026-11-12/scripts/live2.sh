#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# live2.sh [ROUNDS]: live.sh's comparison of the objects, again, with the skipped declarations' tokens kept as empty
# declarations (attest.py --semi: a `;` at each token's place), so that no other token's index changes: live.sh's
# blanked units gave 109 of musl's 1,336 objects other bytes, each a string literal's symbol, which the compiler
# names by the literal's token index (.Lbuster_string_N). Inside one hold of the lock:
#   1. musl, the memo filled as the command goes: objects and diagnostics of scratch/musl-i against scratch/musl-semi;
#   2. the frozen sqlite3.c with a warm memo: its object against the placeholder unit's;
#   3. musl with a warm memo (every eligible declaration a hit: a second command, or a memo kept across processes):
#      the one command, ROUNDS rounds (default 5), and the 1,336 units as 1,336 processes, 2 rounds, each against the
#      preprocessed units' own.
set -u
cd "$(dirname "$0")"
. ./common.sh
rounds=${1:-5}
out=$PWD/results/live2
here=$PWD
mkdir -p "$out" scratch/objects-i scratch/objects-semi scratch/sqlite-semi-in
compiler=$PWD/src/build/compiler
status=0
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
rm -rf scratch/musl-live scratch/musl-semi scratch/musl-warm scratch/musl-warm-semi scratch/sqlite-warm scratch/sqlite-semi
python3 tools/attest.py --order scratch/musl-units.txt --semi scratch/musl-semi scratch/musl-i scratch/musl-live "$out/attest-musl.tsv" > "$out/attest.log" 2>&1 || status=1
python3 tools/attest.py --warm --order scratch/musl-units.txt --semi scratch/musl-warm-semi scratch/musl-i scratch/musl-warm "$out/attest-musl-warm.tsv" >> "$out/attest.log" 2>&1 || status=1
cp scratch/sqlite3.i scratch/sqlite-semi-in/sqlite3.i
python3 tools/attest.py --warm --semi scratch/sqlite-semi scratch/sqlite-semi-in scratch/sqlite-warm "$out/attest-sqlite-warm.tsv" >> "$out/attest.log" 2>&1 || status=1
cat scratch/musl-live/*.i | sha256sum > "$out/musl-live.sha256"
cat scratch/musl-semi/*.i | sha256sum > "$out/musl-semi.sha256"
mapfile -t sources < scratch/musl-units.txt
names=("${sources[@]##*/}"); names=("${names[@]%.c}")
units=("${names[@]/#/$here/scratch/cur/}"); units=("${units[@]/%/.i}")
: > "$out/status.txt"
: > "$out/objects.txt"
compare()
{
    local label=$1 base=$2 other=$3
    local same=0 different=0 missing=0 n
    rm -f scratch/cur; ln -s "$here/scratch/$base" scratch/cur
    (cd scratch/objects-i && rm -f ./*.o && taskset -c 2 "$compiler" "${musl_i_options[@]}" --lanes 1 -c "${units[@]}" > /dev/null 2> "$out/$label.base.stderr.txt"; echo "$label base status $?" >> "$out/status.txt")
    rm -f scratch/cur; ln -s "$here/scratch/$other" scratch/cur
    (cd scratch/objects-semi && rm -f ./*.o && taskset -c 2 "$compiler" "${musl_i_options[@]}" --lanes 1 -c "${units[@]}" > /dev/null 2> "$out/$label.other.stderr.txt"; echo "$label other status $?" >> "$out/status.txt")
    rm -f scratch/cur
    : > "$out/$label.objects-different.txt"
    for n in "${names[@]}"; do
        if [[ ! -f scratch/objects-i/$n.o || ! -f scratch/objects-semi/$n.o ]]; then missing=$((missing + 1)); echo "missing $n" >> "$out/$label.objects-different.txt"
        elif cmp -s "scratch/objects-i/$n.o" "scratch/objects-semi/$n.o"; then same=$((same + 1))
        else different=$((different + 1)); echo "different $n" >> "$out/$label.objects-different.txt"; fi
    done
    echo "$label objects: $same the same bytes, $different different, $missing missing" >> "$out/objects.txt"
    cat scratch/objects-i/*.o | sha256sum >> "$out/objects.txt"
    cat scratch/objects-semi/*.o | sha256sum >> "$out/objects.txt"
    if cmp -s "$out/$label.base.stderr.txt" "$out/$label.other.stderr.txt"; then
        echo "$label diagnostics: the same bytes ($(wc -c < "$out/$label.base.stderr.txt") bytes, $(grep -c 'warning:' "$out/$label.base.stderr.txt") warnings, $(grep -c 'error:' "$out/$label.base.stderr.txt") errors)" >> "$out/objects.txt"
    else
        echo "$label diagnostics: different" >> "$out/objects.txt"; diff "$out/$label.base.stderr.txt" "$out/$label.other.stderr.txt" | head -40 > "$out/$label.diagnostics.diff"
    fi
}
compare musl-cold musl-i musl-semi
compare musl-warm musl-i musl-warm-semi
# sqlite3.c, a warm memo, through one path.
mkdir -p scratch/sq-cur
cp scratch/sqlite3.i scratch/sq-cur/sqlite3.i
taskset -c 2 "$compiler" -c scratch/sq-cur/sqlite3.i -o scratch/sqlite-base.o 2> "$out/sqlite.base.stderr.txt"; echo "sqlite base status $?" >> "$out/status.txt"
cp scratch/sqlite-semi/sqlite3.i scratch/sq-cur/sqlite3.i
taskset -c 2 "$compiler" -c scratch/sq-cur/sqlite3.i -o scratch/sqlite-semi.o 2> "$out/sqlite.other.stderr.txt"; echo "sqlite semi status $?" >> "$out/status.txt"
if cmp -s scratch/sqlite-base.o scratch/sqlite-semi.o; then echo "sqlite3 warm objects: the same bytes" >> "$out/objects.txt"; else echo "sqlite3 warm objects: different" >> "$out/objects.txt"; fi
sha256sum scratch/sqlite-base.o scratch/sqlite-semi.o >> "$out/objects.txt"
if cmp -s "$out/sqlite.base.stderr.txt" "$out/sqlite.other.stderr.txt"; then echo "sqlite3 warm diagnostics: the same bytes ($(wc -c < "$out/sqlite.base.stderr.txt") bytes)" >> "$out/objects.txt"; else echo "sqlite3 warm diagnostics: different" >> "$out/objects.txt"; fi
rm -rf scratch/sq-cur
# 3. A warm memo's time: the one command, and a process a unit.
run()
{
    local name=$1 round=$2 set=$3
    rm -f scratch/cur; ln -s "$here/scratch/$set" scratch/cur
    (cd scratch/objects-semi && taskset -c 2 perf stat -x, -o "$out/stat-$name-$round.csv" -e '{cycles:u,instructions:u,cycles:k,instructions:k}' -e task-clock,page-faults -- "$compiler" "${musl_i_options[@]}" --lanes 1 -c "${units[@]}" > /dev/null 2>&1; echo "$name $round status $?" >> "$out/status.txt")
}
for ((r = 1; r <= rounds; r += 1)); do
    run i-c $r musl-i
    run live-c $r musl-live
    run warm-c $r musl-warm
done
printf -v each '%q ' "$compiler" "${musl_i_options[@]}" -c
processes()
{
    local name=$1 round=$2 set=$3
    rm -f scratch/cur; ln -s "$here/scratch/$set" scratch/cur
    (cd scratch/objects-semi && taskset -c 2 perf stat -x, -o "$out/stat-$name-$round.csv" -e '{cycles:u,instructions:u,cycles:k,instructions:k}' -e task-clock,page-faults -- \
        bash -c "for n in ${names[*]}; do $each '$here/scratch/cur/'\$n.i -o \$n.o || exit 1; done" > /dev/null 2>&1; echo "$name $round status $?" >> "$out/status.txt")
}
for r in 1 2; do
    processes processes-i-c $r musl-i
    processes processes-warm-c $r musl-warm
done
rm -f scratch/cur
rm -rf scratch/objects-i scratch/objects-semi
python3 tools/stat_medians.py "$out" > "$out/medians.tsv"
if ((status == 0)); then date -u +%FT%TZ > "$out/.done"; fi
exit $status
