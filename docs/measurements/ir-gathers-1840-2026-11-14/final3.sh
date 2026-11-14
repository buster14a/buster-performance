#!/bin/bash
# #1840's 9700X timings, base (main 8023523) against final (2526105; ec8b405 adds only docs), after final2.sh's `ab`
# runs, which time nothing themselves (ab only runs commands). Each `ab` round is one `time-runs` process under one
# lock hold: 3 runs of base, final and base again (the floor), each from 3 fresh copies, in a Williams order.
W=$HOME/buster-fast-bench/1840-claude-h1
L=$HOME/buster-fast-bench/exclusive.sh
export EXCLUSIVE_OWNER=claude-1840-h1 EXCLUSIVE_TITLE="Issues 1834 1840" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2722
H=$W/final
ARGS="-march=native -I$H/src -fwrapv -funsigned-char --predefines $H/build/predefines.h"
B="--build base $W/compiler-base --build final $W/compiler-final --build base-again $W/compiler-base"
TR="time-runs --runs 3 --copies 3"
echo "final3 start $(date -u +%FT%TZ)" >> $W/progress.txt
cd $H
./build/compiler ab --rounds 3 --cpu 2 --lock $L $W/compiler-final -- $TR $B --list -c $ARGS $H/src/buster/compiler/main.c -o $W/tr-c.o > $W/tr-c.txt 2>&1
echo "time-runs -c done $(date -u +%FT%TZ) status $?" >> $W/progress.txt
./build/compiler ab --rounds 3 --cpu 2 --lock $L $W/compiler-final -- $TR $B --list --tier1 -c $ARGS $H/src/buster/compiler/main.c -o $W/tr-t1.o > $W/tr-t1.txt 2>&1
echo "time-runs --tier1 done $(date -u +%FT%TZ) status $?" >> $W/progress.txt
for t in base final; do
  $L $W/compiler-$t -c --tier1 --tier1-report -march=znver5 $ARGS $H/src/buster/compiler/main_unit_backend.c -o $W/rows-$t.o > $W/rows-$t.txt 2>&1
done
echo "rows done $(date -u +%FT%TZ)" >> $W/progress.txt
# The backend unit self-built by base's and final's --tier1 (final's sources), linked with final's Release objects.
N=$H/build/cmake/native-g0
clang -dM -E -O3 -march=native -fwrapv -funsigned-char -fno-strict-aliasing -fno-stack-protector -x c /dev/null > $W/self-pd.h
LINE=$(grep -n "^build Release/compiler.link: " $N/CMakeFiles/impl-Release.ninja | head -1 | cut -d: -f1)
OBJS=$(sed -n "${LINE}p" $N/CMakeFiles/impl-Release.ninja | sed 's/^build Release\/compiler.link: [A-Za-z_]* //; s/ |.*//')
FLAGS=$(sed -n "$((LINE+1)),$((LINE+8))p" $N/CMakeFiles/impl-Release.ninja | grep "LINK_FLAGS =" | sed 's/.*LINK_FLAGS = //')
LIBS=$(sed -n "$((LINE+1)),$((LINE+8))p" $N/CMakeFiles/impl-Release.ninja | grep "LINK_LIBRARIES =" | sed 's/.*LINK_LIBRARIES = //')
echo "line $LINE objects: $OBJS" > $W/self-link.txt
echo "flags: $FLAGS libs: $LIBS" >> $W/self-link.txt
for t in base final; do
  rm -rf $W/self-$t; mkdir -p $W/self-$t/build
  $L $W/compiler-$t -c --tier1 --tier1-report -march=native -I$H/src -fwrapv -funsigned-char -fno-strict-aliasing -DBUSTER_CLANG_DEFAULT_TARGET=\"x86_64-unknown-linux-gnu\" -DBUSTER_EXECUTABLE_UNIT -DBUSTER_HOST_SSP_DEFAULT=BUSTER_PREDEFINES_SSP_OFF -DBUSTER_HOST_STATIC=1 --predefines $W/self-pd.h $H/src/buster/compiler/main_unit_backend.c -o $W/self-$t/backend.o > $W/self-$t/compile.txt 2>&1
  objs=""
  for o in $OBJS; do
    case $o in
      *main_unit_backend*) objs="$objs $W/self-$t/backend.o" ;;
      *) objs="$objs $N/$o" ;;
    esac
  done
  (cd $N && $L clang $FLAGS $objs $LIBS -o $W/self-$t/build/compiler > $W/self-$t/link.txt 2>&1)
  echo "self $t: $(stat -c %s $W/self-$t/build/compiler 2>&1) $(grep -o 'machine_rows=[0-9]*' $W/self-$t/compile.txt)" >> $W/progress.txt
done
# Both self-built compilers must give the Release final's output before timing.
for t in base final; do
  $L $W/self-$t/build/compiler -c --tier1 -march=znver5 $ARGS $H/src/buster/compiler/main_unit_backend.c -o $W/self-$t/out.o > $W/self-$t/run.txt 2>&1
done
$L $W/compiler-final -c --tier1 -march=znver5 $ARGS $H/src/buster/compiler/main_unit_backend.c -o $W/self-out-final.o > /dev/null 2>&1
echo "outputs: base $(cmp $W/self-base/out.o $W/self-out-final.o > /dev/null && echo same || echo differ), final $(cmp $W/self-final/out.o $W/self-out-final.o > /dev/null && echo same || echo differ)" >> $W/progress.txt
S="--build self-base $W/self-base/build/compiler --build self-final $W/self-final/build/compiler --build self-base-again $W/self-base/build/compiler"
./build/compiler ab --rounds 3 --cpu 2 --lock $L $W/compiler-final -- $TR $S --list -c --tier1 -march=znver5 $ARGS $H/src/buster/compiler/main_unit_backend.c -o $W/tr-self.o > $W/tr-self.txt 2>&1
echo "time-runs self done $(date -u +%FT%TZ) status $?" >> $W/progress.txt
echo finaldone >> $W/progress.txt
