#!/bin/bash
# #1840's final head (2526105; ec8b405 adds only docs): Release build, then against base (main 8023523) the -c and
# --tier1 -c A/Bs of main.c, the backend unit's machine rows, and self-final.sh (the self-built backends' A/B).
# Replaces run1840.sh's A/Bs, which timed the earlier head c70562f (stopped 2026-11-14 at its -c A/B's round 2).
W=$HOME/buster-fast-bench/1840-claude-h1
L=$HOME/buster-fast-bench/exclusive.sh
export EXCLUSIVE_OWNER=claude-1840-h1 EXCLUSIVE_TITLE="Issues 1834 1840" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2722
echo "final2 start $(date -u +%FT%TZ)" >> $W/progress.txt
if [ ! -x $W/compiler-final ]; then
  (cd $W/final && $L env BUSTER_DEBUG_INFO=0 ./build.sh --config Release > $W/build-final.log 2>&1)
  cp $W/final/build/compiler $W/compiler-final
  echo "built final: $(tail -1 $W/build-final.log)" >> $W/progress.txt
fi
for t in base final; do clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > $W/$t/build/predefines.h; done
H=$W/final
ARGS="-march=native -I$H/src -fwrapv -funsigned-char --predefines $H/build/predefines.h"
(cd $H && ./build/compiler ab --rounds 11 --cpu 2 --lock $L $W/base $W/final -- -c $ARGS $H/src/buster/compiler/main.c -o $W/ab-cf.o > $W/ab-c-final.txt 2>&1)
echo "ab -c final done $(date -u +%FT%TZ)" >> $W/progress.txt
(cd $H && ./build/compiler ab --rounds 11 --cpu 2 --lock $L $W/base $W/final -- --tier1 -c $ARGS $H/src/buster/compiler/main.c -o $W/ab-t1f.o > $W/ab-t1-final.txt 2>&1)
echo "ab --tier1 final done $(date -u +%FT%TZ)" >> $W/progress.txt
for t in base final; do
  $L $W/compiler-$t -c --tier1 --tier1-report -march=znver5 $ARGS $H/src/buster/compiler/main_unit_backend.c -o $W/rows-$t.o > $W/rows-$t.txt 2>&1
done
echo "rows done $(date -u +%FT%TZ)" >> $W/progress.txt
$W/self-final.sh
echo finaldone >> $W/progress.txt
