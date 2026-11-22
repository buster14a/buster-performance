#!/usr/bin/env bash
set -u
D=$HOME/buster-fast-bench/3070-claude
C=$1; out=$2
mkdir -p "$out"
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
musl=$corpus/libc/musl
opts=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic"
    -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal"
    -I "$corpus/musl-generated/obj/include" -I "$musl/include")
declare -A seen
units=()
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do b=${f##*/}; if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; units+=("$f"); fi; done
work=/dev/shm/3070-claude-prof
rm -rf "$work"; mkdir -p "$work"
cd "$work"
perf record -q -g -F 2000 -o "$out/musl1-g.data" -- taskset -c 2 "$C" -c --lanes 1 "${opts[@]}" "${units[@]}" 2> /dev/null
grep -E "AnonHugePages|thp_enabled" /proc/self/smaps_rollup > "$out/thp.txt" 2>&1; cat /sys/kernel/mm/transparent_hugepage/enabled >> "$out/thp.txt"
