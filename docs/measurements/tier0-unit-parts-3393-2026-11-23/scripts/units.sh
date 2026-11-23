#!/bin/bash
# Usage: units.sh BINARY TAG ROUNDS: Lua 5.4.8's 33 library and interpreter units and musl's src/string and src/stdio units, a
# process a file with -c --time-stages on CPU 2, ROUNDS times; each file's stage lines in results/TAG/FILE-ROUND.txt
# (buster#3393).
set -u
D=~/buster-fast-bench/3393-claude
C=$D/corpus
BIN=$1; TAG=$2; ROUNDS=${3:-3}
SYS="--predefines $C/provenance/gnu17-pinned-predefines.txt -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include"
M=$C/libc/musl
MUSL="--predefines $C/provenance/gnu17-pinned-predefines.txt -march=znver5 -std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I $M/arch/x86_64 -I $M/arch/generic -I $C/musl-generated/obj/src/internal -I $M/src/include -I $M/src/internal -I $C/musl-generated/obj/include -I $M/include"
mkdir -p $D/results/$TAG; cd $D/results/$TAG
for r in $(seq 1 $ROUNDS); do
  for f in $D/lua/src/*.c; do
    n=lua-$(basename $f .c)
    taskset -c 2 $BIN -c $SYS $f -o /dev/shm/3393-$TAG.o --time-stages 2> $n-$r.txt; echo "$n $? $(sha256sum < /dev/shm/3393-$TAG.o | cut -c1-16)" >> objects-$r.txt
  done
  for f in $M/src/string/*.c $M/src/stdio/*.c; do
    n=musl-$(basename $(dirname $f))-$(basename $f .c)
    taskset -c 2 $BIN -c $MUSL $f -o /dev/shm/3393-$TAG.o --time-stages 2> $n-$r.txt; echo "$n $? $(sha256sum < /dev/shm/3393-$TAG.o | cut -c1-16)" >> objects-$r.txt
  done
done
rm -f /dev/shm/3393-$TAG.o
