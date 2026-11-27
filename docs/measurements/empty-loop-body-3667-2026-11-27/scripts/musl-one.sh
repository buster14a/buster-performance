#!/bin/bash
# musl-one.sh COMPILER UNIT: prints "unit writer same|diff"
c=$1; u=$2; C=/home/user/corpus; m=$C/libc/musl
o=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I $m/arch/x86_64 -I $m/arch/generic -I $C/musl-generated/obj/src/internal -I $m/src/include -I $m/src/internal -I $C/musl-generated/obj/include -I $m/include)
d=$(mktemp -d)
"$c" -c "${o[@]}" $m/$u -o $d/d.o 2> $d/d.err; ds=$?
w=$(readelf -p .comment $d/d.o 2>/dev/null | grep -o -E 'buster direct|buster-fast' | head -1)
r=-
if [ -n "$DIFF" ]; then
  "$c" --no-direct -c "${o[@]}" $m/$u -o $d/f.o 2> $d/f.err; fs=$?
  if [ $ds = $fs ] && cmp -s $d/d.err $d/f.err; then r=same; else r=diff; fi
fi
echo "$u ${w// /_} $r"
rm -rf $d
