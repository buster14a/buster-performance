#!/usr/bin/env bash
# Second hold: a resident compiler's client floor (spawn, connect, send argv + 4 descriptors, read a status) against a
# static process that only exits; and musl's originals and reduced units in one command on 1, 4 and 8 lanes, wall time.
set -u
D=$HOME/buster-fast-bench/build-images-claude
C=$D/tree/build/compiler
R=$D/results/$(date -u +%Y%m%dT%H%M%S)-2
mkdir -p "$R"
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
musl=$corpus/libc/musl
opts=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic"
    -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal"
    -I "$corpus/musl-generated/obj/include" -I "$musl/include")
declare -A seen
units=()
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; units+=("$f"); fi
done
export LC_ALL=C
work=/dev/shm/build-images-claude
rm -rf "$work"; mkdir -p "$work/o" "$work/musl-i" "$work/musl-red" "$work/musl-red2"
{ cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; } > "$R/host-before.txt" 2>&1
for u in "${units[@]}"; do e=$(echo "$u" | sed 's|.*/src/||; s|/|_|g'); "$C" -E "${opts[@]}" -o "$work/musl-i/$e.i" "$u"; done
python3 -I "$D/census/reduce.py" "$work/musl-red" "$work/musl-i"/*.i > /dev/null 2> "$R/musl-red-total.txt"
for u in "${units[@]}"; do e=$(echo "$u" | sed 's|.*/src/||; s|/|_|g'); cp "$work/musl-red/$e.c" "$work/musl-red2/${u##*/}"; done
reds=("$work"/musl-red2/*.c)
# The client floor.
cc -O2 -static -nostdlib -o "$work/tiny" "$D/spawn/tiny.c"
cc -O2 -static -nostdlib -fno-stack-protector -o "$work/client" "$D/spawn/client.c"
cc -O2 -o "$work/server" "$D/spawn/server.c"
cc -O2 -o "$work/spawnbench" "$D/spawn/spawnbench.c"
taskset -c 3 "$work/server" & server=$!
sleep 0.3
for r in 1 2 3; do
    taskset -c 2 "$work/spawnbench" 3000 "$work/tiny" -c x.c -o x.o
    taskset -c 2 "$work/spawnbench" 3000 "$work/client" -c x.c -o x.o
done > "$R/client.txt" 2>&1
kill $server; rm -f /dev/shm/build-images-server.sock
events=duration_time,task-clock,cycles:u,cycles:k,page-faults
for round in 1 2 3; do
    for lanes in 1 4 8; do
        case $lanes in 1) cpus=2;; 4) cpus=2,3,4,5;; 8) cpus=0,1,2,3,4,5,6,7;; esac
        rm -f "$work"/o/*.o
        (cd "$work/o" && perf stat -x, -e $events -o "$R/perf-musl-orig-$lanes.$round.csv" -- taskset -c $cpus "$C" -c --lanes $lanes "${opts[@]}" "${units[@]}" > /dev/null 2>&1)
        rm -f "$work"/o/*.o
        (cd "$work/o" && perf stat -x, -e $events -o "$R/perf-musl-red-$lanes.$round.csv" -- taskset -c $cpus "$C" -c --lanes $lanes -std=c99 -ffreestanding -w "${reds[@]}" > /dev/null 2>&1)
    done
done
{ cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; } > "$R/host-after.txt" 2>&1
rm -rf "$work"
echo "results $R"
