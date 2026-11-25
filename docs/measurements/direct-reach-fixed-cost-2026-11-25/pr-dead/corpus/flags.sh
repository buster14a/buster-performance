#!/bin/bash
# flags.sh TAG: the corpus runner's flags for a unit of TAG (as equiv/run.sh passes them)
C=/home/user/corpora; M=$C/libc/musl
case "$1" in
  musl) echo -std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I $M/arch/x86_64 -I $M/arch/generic -I $C/musl-generated/obj/src/internal -I $M/src/include -I $M/src/internal -I $C/musl-generated/obj/include -I $M/include ;;
  musl-gnu99) echo -std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I $M/arch/x86_64 -I $M/arch/generic -I $C/musl-generated/obj/src/internal -I $M/src/include -I $M/src/internal -I $C/musl-generated/obj/include -I $M/include -std=gnu99 ;;
  sqlite-host) echo -I$C/sqlite ;;
  sqlite\[*) f=${1#sqlite[}; f=${f%]}; echo "$f" -I$C/sqlite ;;
  *) echo ;;
esac
