#!/bin/bash
# musl.sh COMPILER OUT: musl's 1,336 units as one command on one lane (CPU 2), by windows of 0 and of 2,048 tokens,
# interleaved, 5 rounds, each run counted by perf stat (user and kernel cycles, user instructions). One hold.
set -u
compiler=$1 out=$2
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
musl=$corpus/libc/musl
options=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include")
mkdir -p "$out/objects"
mapfile -t units < "$out/../corpora-head2/musl.files"
cd "$out/objects"
for round in 1 2 3 4 5; do
    for window in 0 2048; do
        start=$EPOCHREALTIME
        perf stat -x, -e cycles:u,cycles:k,instructions:u -o "$out/r$round.w$window.stat" -- taskset -c 2 "$compiler" "${options[@]}" --lanes 1 --emit-window=$window -c "${units[@]}" 2> "$out/r$round.w$window.err"
        echo "$round $window $? $(awk -v a="$EPOCHREALTIME" -v b="$start" 'BEGIN { printf "%.1f", (a - b) * 1000 }')" >> "$out/runs.txt"
        mkdir -p "../w$window"
        mv ./*.o "../w$window/" 2> /dev/null
    done
done
