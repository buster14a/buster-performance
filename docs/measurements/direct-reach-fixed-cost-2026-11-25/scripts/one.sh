#!/bin/bash
# one.sh COMPILER OUTDIR FILE: compile one musl unit with -c; print "direct|full|fail FILE"
C=${C:-/home/user/corpora}
musl=$C/libc/musl
f=$3
o=$2/$(basename "$f" .c).o
"$1" -c --lanes 1 ${STD:--std=c99} -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$C/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$C/musl-generated/obj/include" -I "$musl/include" "$f" -o "$o" 2>"$o.err"
s=$?
if [ $s -ne 0 ]; then echo "fail $f"; elif grep -qa "buster direct" "$o"; then echo "direct $f"; else echo "full $f"; fi
