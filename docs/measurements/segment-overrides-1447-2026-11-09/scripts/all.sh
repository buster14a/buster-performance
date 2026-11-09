#!/bin/bash
cd "$(dirname "$0")" || exit 1
. ./env.sh
echo $$ > all.pid
{
    echo "== $(date -Is)"
    uname -a
    grep -m1 "model name" /proc/cpuinfo
    echo "cpu2 governor $(cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor)"
    clang --version | head -n 1
    for t in $MAIN $HEAD; do echo "tree $t commit $(cat $T/$t/COMMIT)"; done
} > $M/receipt.txt 2>&1
for t in $MAIN $HEAD; do
    echo "== build $t $(date -Is)"
    $X bash -c "cd $T/$t && BUSTER_DEBUG_INFO=0 ./build.sh" > $M/build-$t.log 2>&1 || { echo "build $t failed"; tail -5 $M/build-$t.log; exit 1; }
    tail -1 $M/build-$t.log
    sha256sum $T/$t/build/compiler | tee -a $M/receipt.txt
done
$X bash -c ". $B/env.sh; for t in $MAIN $HEAD; do taskset -c 2 \$T/\$t/build/compiler -o $M/sqlite-\$t.o \"\${SQLITE[@]}\"; echo \"\$t sqlite -c exit \$?\"; taskset -c 2 \$T/\$t/build/compiler -o $M/main-\$t.o \"\${MAINC_ARGS[@]}\"; echo \"\$t main -c exit \$?\"; done" > $M/compile.log 2>&1
cat $M/compile.log
sha256sum $M/*.o | tee $M/objects.sha256
echo "== ab $(date -Is)"
$T/$HEAD/build/compiler ab --rounds 15 --cpu 2 --lock $X $T/$MAIN $T/$HEAD -- -o /tmp/1447-seg-sqlite.o "${SQLITE[@]}" -- -o /tmp/1447-seg-main.o "${MAINC_ARGS[@]}" > $M/ab.txt 2>&1
echo "ab exit $?"
tail -30 $M/ab.txt
echo "all done $(date -Is)"
