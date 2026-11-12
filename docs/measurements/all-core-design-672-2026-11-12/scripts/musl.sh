#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# musl.sh ROUND: musl's 1,336 units to objects five ways, inside one hold of the lock, each run counted (common.sh's
# BASIC) and each cohort under the memory controllers' counters:
#   m.l1  one command of every unit on one lane, CPU 2 (3 runs)
#   m.l8  one command of every unit on 8 lanes, CPUs 0 to 7 (5 runs)
#   m.p8  8 commands at once, a worker's share of the units each (units.sh's deal), one lane and one CPU each (5 runs)
#   m.u1  a process a unit, one after another on CPU 2 (every unit once)
#   m.u8  a process a unit, 8 at a time: each worker its share one after another on its CPU (every unit once)
# The objects go to scratch/musl-objects. The order is rotated by ROUND.
set -u
cd "$(dirname "$0")"
. ./common.sh
round=${1:?a round}
out=$PWD/results/musl/r$round
objects=$PWD/scratch/musl-objects
mkdir -p "$out" "$objects"
status=0
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
lanes8=0+1+2+3+4+5+6+7
run()
{
    case $1 in
        m.l1) counted "$out" m.l1 ./allcore cohort --cpus 2 --loops 3 --label m.l1 --out "$out/m.l1.rows.tsv" --events "$EVENTS_BASIC" --directory "$objects" \
                  --arguments "$PWD/scratch/musl.all.txt" -- "$compiler" "${MUSL_OPTIONS[@]}" --lanes 1 -c ;;
        m.l8) counted "$out" m.l8 ./allcore cohort --cpus "$lanes8" --loops 5 --label m.l8 --out "$out/m.l8.rows.tsv" --events "$EVENTS_BASIC" --directory "$objects" \
                  --arguments "$PWD/scratch/musl.all.txt" -- "$compiler" "${MUSL_OPTIONS[@]}" --lanes 8 -c ;;
        m.p8) counted "$out" m.p8 ./allcore cohort --cpus "$CPUS_8" --loops 5 --label m.p8 --out "$out/m.p8.rows.tsv" --events "$EVENTS_BASIC" --directory "$objects" \
                  --arguments "$PWD/scratch/musl.p%w.txt" -- "$compiler" "${MUSL_OPTIONS[@]}" --lanes 1 -c ;;
        m.u1) counted "$out" m.u1 ./allcore cohort --cpus 2 --label m.u1 --out "$out/m.u1.rows.tsv" --events "$EVENTS_BASIC" --directory "$objects" \
                  --items "$PWD/scratch/musl.all.txt" -- "$compiler" "${MUSL_OPTIONS[@]}" --lanes 1 -c -o "$objects/u1.o" ;;
        m.u8) counted "$out" m.u8 ./allcore cohort --cpus "$CPUS_8" --label m.u8 --out "$out/m.u8.rows.tsv" --events "$EVENTS_BASIC" --directory "$objects" \
                  --items "$PWD/scratch/musl.p%w.txt" -- "$compiler" "${MUSL_OPTIONS[@]}" --lanes 1 -c -o "$objects/u8.w%w.o" ;;
    esac
}
idle "$out" idle 2 || status=1
labels=(m.l1 m.l8 m.p8 m.u1 m.u8)
n=${#labels[@]}
for ((s = 0; s < n; s += 1)); do
    label=${labels[(s + round) % n]}
    run "$label" || { status=1; echo "$label failed" >&2; }
done
ls "$objects" | wc -l > "$out/objects.txt"
if ((status == 0)); then date -u +%FT%TZ > "$out/.done"; fi
exit $status
