#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# muslsample.sh LABEL GROUP: musl's units one of musl.sh's five ways (m.l1, m.l8, m.p8, m.u1, m.u8) under
# `perf record -a` on its CPUs, a leader-sampled group (sampled.sh's work or kern), inside one hold of the lock; then
# `allcore buckets` sums the samples of each run by function and by family. A command of several units reports no
# stages of its own, so a run is one stage here and the families stand for the stages.
set -u
cd "$(dirname "$0")"
. ./common.sh
label=${1:?a label} group=${2:?a group}
name="$label-$group"
out=$PWD/results/muslsampled
objects=$PWD/scratch/musl-objects
mkdir -p "$out" "$objects"
status=0
head -1 /var/lib/buster-9700x/owner > "$out/$name.holder.txt"
case $group in
    work) events='{cycles:u,instructions:u,ex_ret_brn_misp:u,ls_dmnd_fills_from_sys.all:u,ls_dmnd_fills_from_sys.dram_io_near:u}:S' ;;
    kern) events='{cycles,cycles:k,instructions:k,l2_fill_rsp_src.dram_io_near:u,l2_fill_rsp_src.dram_io_near:k}:S' ;;
    *) echo "unknown group $group" >&2; exit 1 ;;
esac
lanes8=0+1+2+3+4+5+6+7
all=
case $label in
    m.l1) cpus=2; command=(./allcore cohort --cpus 2 --loops 2 --label "$name" --out "$out/$name.rows.tsv" --directory "$objects" --arguments "$PWD/scratch/musl.all.txt" -- "$compiler" "${MUSL_OPTIONS[@]}" --lanes 1 -c) ;;
    m.l8) cpus=$CPUS_8; all=--all-cpus; command=(./allcore cohort --cpus "$lanes8" --loops 4 --label "$name" --out "$out/$name.rows.tsv" --directory "$objects" --arguments "$PWD/scratch/musl.all.txt" -- "$compiler" "${MUSL_OPTIONS[@]}" --lanes 8 -c) ;;
    m.p8) cpus=$CPUS_8; command=(./allcore cohort --cpus "$CPUS_8" --loops 4 --label "$name" --out "$out/$name.rows.tsv" --directory "$objects" --arguments "$PWD/scratch/musl.p%w.txt" -- "$compiler" "${MUSL_OPTIONS[@]}" --lanes 1 -c) ;;
    m.u1) cpus=2; command=(./allcore cohort --cpus 2 --label "$name" --out "$out/$name.rows.tsv" --directory "$objects" --items "$PWD/scratch/musl.all.txt" -- "$compiler" "${MUSL_OPTIONS[@]}" --lanes 1 -c -o "$objects/u1.o") ;;
    m.u8) cpus=$CPUS_8; command=(./allcore cohort --cpus "$CPUS_8" --label "$name" --out "$out/$name.rows.tsv" --directory "$objects" --items "$PWD/scratch/musl.p%w.txt" -- "$compiler" "${MUSL_OPTIONS[@]}" --lanes 1 -c -o "$objects/u8.w%w.o") ;;
    *) echo "unknown label $label" >&2; exit 1 ;;
esac
: > "$out/$name.strays.txt"
strays "$out" "$name" before
perf record -q -a -C "$cpus" -k CLOCK_MONOTONIC -T -m 16M -o "scratch/$name.data" -e "$events" -c 100003 -- "${command[@]}" > "$out/$name.record.log" 2>&1 || status=1
strays "$out" "$name" after
perf report -i "scratch/$name.data" --stats 2>> "$out/$name.record.log" | grep -E 'SAMPLE|LOST|THROTTLE' >> "$out/$name.record.log"
perf script -i "scratch/$name.data" --ns -F cpu,pid,tid,time,period,event,ip,sym 2>> "$out/$name.record.log" | gzip -1 -c > "scratch/$name.samples.gz" || status=1
rm -f "scratch/$name.data"
# A stray's own samples are left out by its process ID (it shared a lane's CPU in some runs: the strays file says).
pids=$(awk '{ print $7 }' "$out/$name.strays.txt" | sort -un | paste -sd, -)
./allcore buckets --rows "$out/$name.rows.tsv" --samples "scratch/$name.samples.gz" $all --without-pid "${pids:--}" --functions 60 --families families.tsv > "$out/$name.buckets.tsv" 2>> "$out/$name.record.log" || status=1
if ((status == 0)); then date -u +%FT%TZ > "$out/$name.done"; fi
exit $status
