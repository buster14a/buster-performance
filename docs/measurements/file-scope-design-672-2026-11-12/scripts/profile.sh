#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# profile.sh VARIANT: one variant of musl's command (musl.sh's: c, i-c, spine-c, one-c, empty-c) or of sqlite3.c
# (sqlite-i, sqlite-spine: 8 compiles) by function, inside one hold of the lock, the compile on CPU 2 and perf on
# CPU 5 (after the first record's muslprofile.sh): the leader-sampled work group reduced by `uarch symbols`; a cycles
# profile of both modes by object and symbol; and the kernel's cycles with their call chains, inclusive, which name
# what entered the kernel (a fault, a system call) for each of its functions.
set -u
cd "$(dirname "$0")"
. ./common.sh
variant=${1:?a variant}
out=$PWD/results/profile
here=$PWD
mkdir -p "$out" "scratch/objects-$variant"
compiler=$PWD/src/build/compiler
status=0
head -1 /var/lib/buster-9700x/owner > "$out/$variant.holder.txt"
mapfile -t sources < scratch/musl-units.txt
names=("${sources[@]##*/}"); names=("${names[@]%.c}")
case $variant in
    c) command=("$compiler" "${musl_options[@]}" --lanes 1 -c "${sources[@]}") ;;
    i-c) units=("${names[@]/#/$here/scratch/musl-i/}"); command=("$compiler" "${musl_i_options[@]}" --lanes 1 -c "${units[@]/%/.i}") ;;
    spine-c) units=("${names[@]/#/$here/scratch/musl-spine/}"); command=("$compiler" "${musl_i_options[@]}" --lanes 1 -c "${units[@]/%/.i}") ;;
    one-c) units=("${names[@]/#/$here/scratch/musl-one/}"); command=("$compiler" "${musl_i_options[@]}" --lanes 1 -c "${units[@]/%/.c}") ;;
    empty-c) units=("${names[@]/#/$here/scratch/musl-empty/}"); command=("$compiler" "${musl_i_options[@]}" --lanes 1 -c "${units[@]/%/.c}") ;;
    sqlite-i) command=("$compiler" -c "$here/scratch/sqlite3.i" -o sqlite3-i.o) ;;
    sqlite-spine) command=("$compiler" -c "$here/scratch/sqlite3-spine.i" -o sqlite3-spine.o) ;;
    *) echo "unknown variant $variant" >&2; exit 1 ;;
esac
repeat=1
case $variant in sqlite-*) repeat=8 ;; one-c | empty-c) repeat=4 ;; esac
printf -v one '%q ' taskset -c 2 "${command[@]}"
loop="for ((i = 0; i < $repeat; i += 1)); do $one > /dev/null 2>&1 || exit 1; done"
cd "scratch/objects-$variant" || exit 1
record()
{
    local name=$1; shift
    taskset -c 5 perf record -q -o "$here/scratch/$variant-$name.data" "$@" -- bash -c "$loop" > "$out/$variant.$name.record.log" 2>&1 || status=1
}
record work -e '{cycles:u,instructions:u,ex_ret_brn_misp:u,ls_dmnd_fills_from_sys.all:u,ls_dmnd_fills_from_sys.dram_io_near:u}:S' -c 100003
perf script -i "$here/scratch/$variant-work.data" -F period,event,ip,sym 2>> "$out/$variant.work.record.log" | "$here/uarch" symbols - > "$out/$variant.work.tsv" || status=1
record cycles -e cycles -c 100003
perf report -i "$here/scratch/$variant-cycles.data" --no-children --sort dso,sym --stdio -q --percent-limit 0.05 > "$out/$variant.cycles.txt" 2>> "$out/$variant.cycles.record.log" || status=1
perf report -i "$here/scratch/$variant-cycles.data" --no-children --sort dso --stdio -q > "$out/$variant.cycles-dso.txt" 2>> "$out/$variant.cycles.record.log" || status=1
record kernel -e cycles:k -c 100003 -g
perf report -i "$here/scratch/$variant-kernel.data" --children --sort sym --stdio -q -g none --percent-limit 0.2 > "$out/$variant.kernel-inclusive.txt" 2>> "$out/$variant.kernel.record.log" || status=1
perf report -i "$here/scratch/$variant-kernel.data" --no-children --sort sym --stdio -q -g none --percent-limit 0.2 > "$out/$variant.kernel-self.txt" 2>> "$out/$variant.kernel.record.log" || status=1
rm -f "$here"/scratch/"$variant"-*.data
cd "$here" && rm -rf "scratch/objects-$variant"
if ((status == 0)); then date -u +%FT%TZ > "$out/$variant.done"; fi
exit $status
