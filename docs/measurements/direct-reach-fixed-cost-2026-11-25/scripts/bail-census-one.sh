#!/bin/bash
C=/home/user/corpora; M=$C/libc/musl
BUSTER_EXPERIMENT_DIRECT_TRACE=1 /home/user/keep/compiler-trace2 -c --lanes 1 -std=gnu99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$M/arch/x86_64" -I "$M/arch/generic" -I "$C/musl-generated/obj/src/internal" -I "$M/src/include" -I "$M/src/internal" -I "$C/musl-generated/obj/include" -I "$M/include" "$1" -o /dev/shm/bail-$$.o 2>&1 >/dev/null | grep "^direct-bail"
rm -f /dev/shm/bail-$$.o
