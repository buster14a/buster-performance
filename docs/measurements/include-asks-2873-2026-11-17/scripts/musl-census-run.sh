#!/bin/bash
# run.sh COMPILER OUT: every musl unit's -c by COMPILER under strace (the opens alone), a trace a unit in OUT.
. /home/user/keep/corpora.sh
compiler=$1; out=$2
mkdir -p "$out"
options=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include")
n=0
for f in "${files[@]}"; do
    strace -e trace=openat,open,newfstatat,statx,stat -o "$out/$n.strace" "$compiler" "${options[@]}" -c "$f" -o /dev/shm/claude-musl-census.o > /dev/null 2>&1 || echo "$f failed" >> "$out/failed.txt"
    n=$((n + 1))
done
rm -f /dev/shm/claude-musl-census.o
echo "$n units" > "$out/done.txt"
