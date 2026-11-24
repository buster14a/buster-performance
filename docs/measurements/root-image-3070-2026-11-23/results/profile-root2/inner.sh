#!/usr/bin/env bash
set -u
D=$HOME/buster-fast-bench/3070-claude-euler
C=$1; out=$2
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
musl=$corpus/libc/musl
opts=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic"
    -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal"
    -I "$corpus/musl-generated/obj/include" -I "$musl/include")
work=/dev/shm/3070-claude-euler-prof
rm -rf "$work"; mkdir -p "$work"
cd "$work"
{ uname -r; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; } > "$out/host-before.txt"
for i in 1 2 3; do taskset -c 2 "$C" -c --lanes 1 "${opts[@]}" "$D"/empty/*.c; done
for i in 1 2 3 4 5; do
  perf stat -x, -e cycles:u,cycles:k,instructions:u,instructions:k,page-faults,task-clock -o "$out/empty-stat.$i.csv" -- taskset -c 2 "$C" -c --lanes 1 "${opts[@]}" "$D"/empty/*.c
done
perf record -q -F 20000 -g -o "$out/empty.data" -- taskset -c 2 "$C" -c --lanes 1 "${opts[@]}" "$D"/empty/*.c 2> /dev/null
perf report -i "$out/empty.data" --no-children --sort symbol --stdio 2> /dev/null | grep -v '^$' | grep -E '^ +[0-9.]+%' | head -150 > "$out/empty-flat.txt"
perf report -i "$out/empty.data" --children --sort symbol --stdio -g none 2> /dev/null | grep -E '^ +[0-9.]+%' | head -200 > "$out/empty-children.txt"
strace -c -f -o "$out/empty-strace.txt" taskset -c 2 "$C" -c --lanes 1 "${opts[@]}" "$D"/empty/*.c
{ cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; } > "$out/host-after.txt"
