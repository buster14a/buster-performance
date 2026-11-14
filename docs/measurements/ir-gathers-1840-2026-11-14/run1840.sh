#!/bin/bash
# #1840's 9700X measurements: Release builds of base and head, the new Zen 5 rows, compile-time A/Bs, and the backend
# unit self-built by each compiler's --tier1, timed on Tier 1's own work.
W=$HOME/buster-fast-bench/1840-claude-h1
L=$HOME/buster-fast-bench/exclusive.sh
export EXCLUSIVE_OWNER=claude-1840-h1 EXCLUSIVE_TITLE="Issues 1834 1840" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1840
cd $W
echo "start $(date -u +%FT%TZ)" > $W/progress.txt
for t in base head; do
  (cd $W/$t && $L env BUSTER_DEBUG_INFO=0 ./build.sh --config Release > $W/build-$t.log 2>&1)
  echo "built $t: $(tail -1 $W/build-$t.log)" >> $W/progress.txt
  cp $W/$t/build/compiler $W/compiler-$t
done
(cd $W/head && $L taskset -c 2 ./build/compiler measure-x86-zen5 --missing --table > $W/zen5-table.txt 2> $W/zen5.err)
echo "zen5 $(wc -l < $W/zen5-table.txt) lines $(date -u +%FT%TZ)" >> $W/progress.txt
for t in base head; do clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > $W/$t/build/predefines.h; done
H=$W/head
ARGS="-march=native -I$H/src -fwrapv -funsigned-char --predefines $W/head/build/predefines.h"
(cd $W/head && ./build/compiler ab --rounds 11 --cpu 2 --lock $L $W/base $W/head -- -c $ARGS $H/src/buster/compiler/main.c -o $W/ab-c.o > $W/ab-c.txt 2>&1)
echo "ab -c done $(date -u +%FT%TZ)" >> $W/progress.txt
(cd $W/head && ./build/compiler ab --rounds 11 --cpu 2 --lock $L $W/base $W/head -- --tier1 -c $ARGS $H/src/buster/compiler/main.c -o $W/ab-t1.o > $W/ab-t1.txt 2>&1)
echo "ab --tier1 done $(date -u +%FT%TZ)" >> $W/progress.txt
# The machine rows of the backend unit at znver5, by each.
for t in base head; do
  $L $W/compiler-$t -c --tier1 --tier1-report -march=znver5 $ARGS $H/src/buster/compiler/main_unit_backend.c -o $W/rows-$t.o > $W/rows-$t.txt 2>&1
done
echo "rows done $(date -u +%FT%TZ)" >> $W/progress.txt
# Self-built backend units: each compiler's --tier1 of head's backend unit, linked with head's Release objects.
clang -dM -E -O3 -march=native -fwrapv -funsigned-char -fno-strict-aliasing -fno-stack-protector -x c /dev/null > $W/self-pd.h
N=$W/head/build/cmake/native
LINE=$(grep -n "^build Release/compiler.link: " $N/CMakeFiles/impl-Release.ninja | head -1 | cut -d: -f1)
OBJS=$(sed -n "${LINE}p" $N/CMakeFiles/impl-Release.ninja | sed 's/^build Release\/compiler.link: [A-Za-z_]* //; s/ |.*//')
FLAGS=$(sed -n "$((LINE+1)),$((LINE+8))p" $N/CMakeFiles/impl-Release.ninja | grep "LINK_FLAGS =" | sed 's/.*LINK_FLAGS = //')
echo "objects: $OBJS" > $W/self-link.txt
echo "flags: $FLAGS" >> $W/self-link.txt
for t in base head; do
  mkdir -p $W/self-$t/build
  $L $W/compiler-$t -c --tier1 -march=native -I$H/src -fwrapv -funsigned-char -fno-strict-aliasing -DBUSTER_CLANG_DEFAULT_TARGET=\"x86_64-unknown-linux-gnu\" -DBUSTER_EXECUTABLE_UNIT -DBUSTER_HOST_SSP_DEFAULT=BUSTER_PREDEFINES_SSP_OFF -DBUSTER_HOST_STATIC=1 --predefines $W/self-pd.h $H/src/buster/compiler/main_unit_backend.c -o $W/self-$t/backend.o > $W/self-$t/compile.txt 2>&1
  objs=""
  for o in $OBJS; do
    case $o in
      *main_unit_backend*) objs="$objs $W/self-$t/backend.o" ;;
      *) objs="$objs $N/$o" ;;
    esac
  done
  (cd $N && $L clang $FLAGS $objs -Wl,--push-state,--as-needed -lm -Wl,--pop-state -ldl -o $W/self-$t/build/compiler > $W/self-$t/link.txt 2>&1)
  echo "self $t: $(ls -la $W/self-$t/build/compiler 2>&1 | awk '{print $5}')" >> $W/progress.txt
done
# Tier 1's own work by each self-built backend: --tier1 of the backend unit (IR lowering, the passes, BURS labeling).
(cd $W/head && ./build/compiler ab --rounds 11 --cpu 2 --lock $L $W/self-base $W/self-head -- -c --tier1 -march=znver5 $ARGS $H/src/buster/compiler/main_unit_backend.c -o $W/ab-self.o > $W/ab-self.txt 2>&1)
echo "ab self done $(date -u +%FT%TZ)" >> $W/progress.txt
echo done >> $W/progress.txt
