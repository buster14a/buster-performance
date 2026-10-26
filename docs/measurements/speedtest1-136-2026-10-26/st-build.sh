#!/bin/bash
# speedtest1 built four ways from the frozen corpus's sqlite3.c and SQLite 3.53.2's test/speedtest1.c, on CPU 2: this
# compiler's -c objects linked by cc (ours), its direct path on both files as one translation unit (direct), clang
# -O0's objects linked by cc (clang) and tcc's objects linked by tcc (tcc). Then the identities, the objects' and
# executables' sizes and hashes, and a --verify run of each, whose verification hashes must agree.
set -u
. "$(dirname "$0")/st-env.sh"
mkdir -p $M && cd $M || exit 1
rm -f *.o st-* tcc-link.txt
TCC_LINK=tcc
status=0
for c in ours clang tcc; do
    compile $c $Q/sqlite3.c $c-sqlite3.o || { echo "$c failed on sqlite3.c"; status=1; continue; }
    compile $c $SRC/speedtest1.c $c-speedtest1.o || { echo "$c failed on speedtest1.c"; status=1; continue; }
    link $c st-$c $c-speedtest1.o $c-sqlite3.o || echo "$c's objects didn't link by $([ $c = tcc ] && echo tcc || echo cc)"
done
if [ ! -x st-tcc ] && [ -e tcc-speedtest1.o ]; then
    TCC_LINK=mold
    link tcc st-tcc tcc-speedtest1.o tcc-sqlite3.o && echo mold > tcc-link.txt && echo "tcc's objects linked by cc with mold and libtcc1.a instead"
fi
direct st-direct || { echo "the direct path didn't build speedtest1"; status=1; }
{
    clang --version | head -1
    tcc -v
    cc --version | head -1
    ld --version | head -1
    mold --version
    bash --version | head -1
    uname -r
    grep -m1 'model name' /proc/cpuinfo
    echo "cpu2 governor $(cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor), epp $(cat /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference 2>/dev/null)"
    sha256sum $Q/sqlite3.c $Q/sqlite3.h $SRC/speedtest1.c $SRC/speedtest1-unity.c $C
} > identities.txt 2>&1
size *-sqlite3.o *-speedtest1.o st-* > sizes.txt 2>&1
ls -l *.o st-* > files.txt
sha256sum *.o st-* > hashes.txt
for c in ${BUILDS[@]}; do
    [ -x st-$c ] || continue
    echo "$c --verify: $(run $c $M/verify-$c.txt --verify) $(grep 'Verification Hash' verify-$c.txt)"
done
cat sizes.txt
exit $status
