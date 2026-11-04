#!/bin/bash
# #1233 E3's builds: each tree's checker code moved by N bytes (0, 16, 32, 48) by main.c's one changed line in
# var-XXXXXXXX (`.skip N, 0xcc` after .text.buster_checker's page alignment, in every unit), BUSTER_DEBUG_INFO=0 as the
# record built, each build in its own hold of the lock. N=0 must give the measured tree's executable byte for byte; it
# also links ./build.sh shifts' 0 and 640 placements of main_unit_checker.c, to see what a unit's shift moves.
set -u
export LC_ALL=C
R=$HOME/buster-fast-bench/1233-claude; L=$R/logs
echo $$ > $R/e3-build.pid
export EXCLUSIVE_OWNER=claude-1233 EXCLUSIVE_TITLE="#1233 cycles without instructions" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1233
for s in 754475d4 4670b2eb; do
    t=$R/trees/var-$s
    (cd $t && find . -type f ! -name COMMIT ! -path './build/*' -print0 | sort -z | xargs -0 sha256sum > $L/host-manifest-var-$s.txt)
    for n in 0 16 32 48; do
        mkdir -p $R/var/$s-$n
        if [ $n = 0 ]; then
            (cd $t && ~/buster-fast-bench/exclusive.sh bash -c "head -1 /var/lib/buster-9700x/owner >> $L/holds.txt; env BUSTER_DEBUG_INFO=0 BUSTER_BUILD_DEFINES='-DBUSTER_CHECKER_SKIP_TEXT=\"$n\"' ./build.sh shifts $R/var/$s-shifts main_unit_checker.c 0 640" > $L/e3-build-$s-$n.log 2>&1)
        else
            (cd $t && ~/buster-fast-bench/exclusive.sh bash -c "head -1 /var/lib/buster-9700x/owner >> $L/holds.txt; env BUSTER_DEBUG_INFO=0 BUSTER_BUILD_DEFINES='-DBUSTER_CHECKER_SKIP_TEXT=\"$n\"' ./build.sh" > $L/e3-build-$s-$n.log 2>&1)
        fi
        echo "var-$s skip $n build status $?" >> $L/receipts.txt
        cp $t/build/compiler $R/var/$s-$n/compiler
        sha256sum $R/var/$s-$n/compiler >> $L/receipts.txt
    done
    sha256sum $R/var/$s-shifts/compiler-* >> $L/receipts.txt
done
echo done > $L/e3-build-done
