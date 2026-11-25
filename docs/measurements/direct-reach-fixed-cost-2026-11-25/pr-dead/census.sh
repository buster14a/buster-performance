#!/bin/bash
# census.sh COMPILER OUTDIR STD: each musl unit's path (direct/full/fail) by its object's .comment
P=$(realpath "$1"); O=$(realpath -m "$2"); STD=$3
C=/home/user/corpora; M=$C/libc/musl
mkdir -p "$O"
one() {
  u=$1; o="$O/$(echo "$u" | sed 's|.*/musl/src/||; s|/|_|g').o"
  if "$P" -c -std=$STD -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$M/arch/x86_64" -I "$M/arch/generic" -I "$C/musl-generated/obj/src/internal" -I "$M/src/include" -I "$M/src/internal" -I "$C/musl-generated/obj/include" -I "$M/include" "$u" -o "$o" 2>/dev/null; then
    if readelf -p .comment "$o" 2>/dev/null | grep -q 'buster direct'; then echo "direct $u"; else echo "full $u"; fi
  else echo "fail $u"; fi
}
export -f one; export P O STD C M
ls "$M"/src/*/*.c "$M"/src/*/x86_64/*.c | xargs -P 4 -I{} bash -c 'one {}' | sort -k2
