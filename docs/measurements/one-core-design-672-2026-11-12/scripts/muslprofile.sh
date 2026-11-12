#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# muslprofile.sh: musl.sh's command (1,336 units, -c, one lane, CPU 2) under two leader-sampled groups, by function,
# inside one hold of the lock; the kernel's share by a cycles profile of both modes. A many-unit command reports its
# units' stages as one (`lanes`), so the functions stand for the stages (tools/stage_of.py).
set -u
cd "$(dirname "$0")"
out=$PWD/results/musl
here=$PWD
mkdir -p "$out" scratch/musl-objects
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
musl="$corpus/libc/musl"
options=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic"
    -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal"
    -I "$corpus/musl-generated/obj/include" -I "$musl/include")
compiler=$PWD/src/build/compiler
export LC_ALL=C
status=0
head -1 /var/lib/buster-9700x/owner > "$out/profile.holder.txt"
cd scratch/musl-objects || exit 1
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
record()
{
    local name=$1; shift
    taskset -c 5 perf record -q -o "$here/scratch/musl-$name.data" "$@" -- taskset -c 2 "$compiler" "${options[@]}" --lanes 1 -c "${files[@]}" > /dev/null 2>&1 || status=1
}
record work -e '{cycles:u,instructions:u,ex_ret_brn_misp:u,ls_dmnd_fills_from_sys.all:u,ls_dmnd_fills_from_sys.dram_io_near:u}:S' -c 100003
perf script -i "$here/scratch/musl-work.data" -F period,event,ip,sym 2>> "$out/profile.log" | "$here/uarch" symbols - > "$out/work.tsv" || status=1
record cycles -e cycles -c 100003
perf report -i "$here/scratch/musl-cycles.data" --no-children --sort dso,sym --stdio -q --percent-limit 0.1 > "$out/cycles.txt" 2>> "$out/profile.log" || status=1
perf report -i "$here/scratch/musl-cycles.data" --no-children --sort dso --stdio -q > "$out/cycles-dso.txt" 2>> "$out/profile.log" || status=1
rm -f "$here"/scratch/musl-*.data
cd .. && rm -rf musl-objects
if ((status == 0)); then date -u +%FT%TZ > "$out/profile.done"; fi
exit $status
