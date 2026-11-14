#!/bin/bash
# musl.sh OPTIONS...: musl's 1,336 units as one command, -c, in the current directory.
C=/tmp/claude-0/-home-user/17548c52-aa06-599d-a6bd-e5e939dd75e5/scratchpad/corpus
mapfile -t sources < /tmp/claude-0/-home-user/17548c52-aa06-599d-a6bd-e5e939dd75e5/scratchpad/musl-units.txt
exec /home/user/buster/build/compiler -std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$C/libc/musl/arch/x86_64" -I "$C/libc/musl/arch/generic" -I "$C/musl-generated/obj/src/internal" -I "$C/libc/musl/src/include" -I "$C/libc/musl/src/internal" -I "$C/musl-generated/obj/include" -I "$C/libc/musl/include" "$@" -c "${sources[@]}"
