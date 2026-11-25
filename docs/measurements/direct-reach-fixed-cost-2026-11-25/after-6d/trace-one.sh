#!/bin/bash
# trace-one.sh COMPILER UNIT: the unit by musl's -std=c99 with the direct path's bail trace; prints the trace line.
C=/home/user/corpora; M=$C/libc/musl
O=/tmp/claude-0/-home-user/b1e85fd2-26a4-5c0b-994d-f1ac5098859a/scratchpad/ldt
name=$(echo "$2" | sed 's|.*/musl/src/||; s|/|_|g')
BUSTER_EXPERIMENT_DIRECT_TRACE=1 "$1" -std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I $M/arch/x86_64 -I $M/arch/generic -I $C/musl-generated/obj/src/internal -I $M/src/include -I $M/src/internal -I $C/musl-generated/obj/include -I $M/include -c "$2" -o "$O/$name.o" 2>&1 >/dev/null | grep '^direct-bail'
