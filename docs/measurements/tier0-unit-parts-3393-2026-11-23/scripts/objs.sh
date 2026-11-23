#!/bin/bash
# objs.sh BIN OUTDIR: compile every exactness input with BIN under 4 flag variants; OUTDIR/VARIANT.txt has "file exit sha".
set -u
BIN=$1; OUT=$2; mkdir -p $OUT
C=/home/user/corpus; R=/home/user/buster
SYS="--predefines $C/provenance/gnu17-pinned-predefines.txt -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include"
M=$C/libc/musl
MUSL="--predefines $C/provenance/gnu17-pinned-predefines.txt -march=znver5 -std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I $M/arch/x86_64 -I $M/arch/generic -I $C/musl-generated/obj/src/internal -I $M/src/include -I $M/src/internal -I $C/musl-generated/obj/include -I $M/include"
SELF="--predefines $C/provenance/gnu17-pinned-predefines.txt -march=znver5 -I/home/user/selfsrc/src -fwrapv -funsigned-char -fno-strict-aliasing"
list=$OUT/list.txt
{
  echo "SYS $C/sqlite/sqlite3.c"
  for f in /home/user/lua/src/*.c; do echo "SYS $f"; done
  for f in $M/src/*/*.c $M/src/*/x86_64/*.c; do echo "MUSL $f"; done
  echo "SELF /home/user/selfsrc/src/buster/compiler/main.c"
  for n in $(sed -n 's|^\([0-9][0-9]*\)$|\1|p' $R/tests/c-testsuite/subset.txt); do echo "SYS $R/build/c-testsuite/tests/single-exec/$n.c"; done
  find $R/tests -name '*.c' | sort | sed 's/^/SYS /'
} > $list
one() {
  local kind=$1 f=$2 v=$3 flags
  case $kind in SYS) flags=$SYS;; MUSL) flags=$MUSL;; SELF) flags=$SELF;; esac
  local o=$(mktemp /dev/shm/objsXXXXXX.o)
  timeout 60 $BIN -c $flags $v $f -o $o > /dev/null 2>&1; local e=$?
  local h=-; [ $e -eq 0 ] && h=$(sha256sum < $o | cut -c1-16)
  rm -f $o; echo "$f $e $h"
}
export -f one; export BIN SYS MUSL SELF
for v in plain g unwind g-unwind; do
  case $v in plain) vf="";; g) vf="-g";; unwind) vf="-funwind-tables";; g-unwind) vf="-g -funwind-tables";; esac
  awk -v vf="$vf" '{print $1"\t"$2"\t"vf}' $list | xargs -P ${JOBS:-4} -d '\n' -n 1 bash -c 'IFS=$'"'"'\t'"'"' read k f v <<< "$0"; one "$k" "$f" "$v"' | sort > $OUT/$v.txt
done
wc -l $OUT/*.txt
