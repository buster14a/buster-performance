#!/bin/bash
# #394's validation and measurements on the 9700X, on tree394 (and treemain394 for the writer's A/B): each step its own
# lock acquisition.
base=~/buster-fast-bench/claude-linker-80
export EXCLUSIVE_OWNER=claude-linker-80 EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/405
L=~/buster-fast-bench/exclusive.sh
log=$base/logs394; mkdir -p $log
echo "start $(date -Is)" > $log/status
{ date -Is; cat /sys/devices/system/cpu/online; for c in 0 1 2 3 4 5 6 7 8 9 11 12 13 14 15; do echo "cpu$c $(cat /sys/devices/system/cpu/cpu$c/cpufreq/scaling_governor)"; done; uname -r; clang --version | head -1; gcc --version | head -1; ld.lld --version; mold --version; wild --version; } > $log/host.txt 2>&1
for t in tree394 treemain394; do
    cd $base/$t || exit 1
    EXCLUSIVE_TITLE="PR 405: link-foreign's output kinds, build $t" $L ./build.sh > $log/build-$t.log 2>&1; echo "build-$t=$? $(date -Is)" >> $log/status
    sha256sum build/compiler >> $log/host.txt
done
cd $base/tree394
EXCLUSIVE_TITLE="PR 405: link-foreign's output kinds, call graph" $L ./build.sh check-call-graph > $log/callgraph.log 2>&1; echo "callgraph=$? $(date -Is)" >> $log/status
sed -n "/<<'TESTS'$/,/^ *TESTS$/{//!{s/^ \{10\}//;p}}" .github/workflows/9700x.yml > $log/tests.txt
EXCLUSIVE_TITLE="PR 405: link-foreign's output kinds, tests" $L bash -c "clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h && ./build/compiler parallel --timeout 180 $log/tests.txt" > $log/tests.log 2>&1; echo "tests=$? $(date -Is)" >> $log/status
EXCLUSIVE_TITLE="PR 405: foreign corpus, every kind, against lld and mold" $L ./build/compiler test-foreign-corpus --sqlite ../inputs/sqlite-amalgamation-3530400 --lua ../inputs/lua-5.4.8/src --self . > $log/corpus.log 2>&1; echo "corpus=$? $(date -Is)" >> $log/status
EXCLUSIVE_TITLE="PR 405: benchmark-link, every kind with link-foreign" $L ./build/compiler benchmark-link > $log/benchmark-link.log 2>&1; echo "benchmark-link=$? $(date -Is)" >> $log/status
# The writer's dynamic PIEs, main against the branch (the IFUNC pass every dynamic PIE now runs), three rounds in turn.
for r in 1 2 3; do
    for t in treemain394 tree394; do
        EXCLUSIVE_TITLE="PR 405: benchmark-executable dynamic, $t round $r" $L taskset -c 2 $base/$t/build/compiler benchmark-executable --only dynamic --directory /tmp > $log/executable-$t-r$r.log 2>&1; echo "executable-$t-r$r=$? $(date -Is)" >> $log/status
    done
done
# The appendix's hello and tcc as static executables and static PIEs, link-foreign against lld, mold and wild, on tmpfs.
B=~/buster-fast-bench/linker-baseline
GCC=/usr/lib/gcc/x86_64-pc-linux-gnu/16
OUT=/tmp/claude-linker-80-394; mkdir -p $OUT
COMMON="--hash-style=gnu --build-id --eh-frame-hdr -m elf_x86_64 -z now --no-gc-sections"
GROUP="-L$GCC -L/usr/lib --start-group -lgcc -lgcc_eh -lc --end-group"
for CASE in hello tcc; do
    case $CASE in
        hello) OBJS="$B/hello.o" ;;
        tcc) OBJS="$B/tinycc/tcc.o $B/tinycc/libtcc.a -lm -ldl -lpthread" ;;
    esac
    for KIND in static static-pie; do
        case $KIND in
            static) PRE="-static /usr/lib/crt1.o /usr/lib/crti.o $GCC/crtbeginT.o"; POST="$GCC/crtend.o /usr/lib/crtn.o" ;;
            static-pie) PRE="-static -pie --no-dynamic-linker -z text /usr/lib/rcrt1.o /usr/lib/crti.o $GCC/crtbeginS.o"; POST="$GCC/crtendS.o /usr/lib/crtn.o" ;;
        esac
        EXCLUSIVE_TITLE="PR 405: the appendix's $CASE as a $KIND" $L bash -c "
            printf '$CASE $KIND link-foreign 1 lane '; taskset -c 2 $B/timeit 41 20 $base/tree394/build/compiler link-foreign $COMMON --lanes=1 $PRE $OBJS $GROUP $POST -o $OUT/$CASE-$KIND.ours
            printf '$CASE $KIND link-foreign 8 lanes '; taskset -c 2,0,1,3,4,5,6,7 $B/timeit 41 20 $base/tree394/build/compiler link-foreign $COMMON --lanes=8 $PRE $OBJS $GROUP $POST -o $OUT/$CASE-$KIND.ours8
            printf '$CASE $KIND wild 1 thread '; taskset -c 2 $B/timeit 41 20 wild --no-threads $COMMON $PRE $OBJS $GROUP $POST -o $OUT/$CASE-$KIND.wild
            printf '$CASE $KIND mold 1 thread '; taskset -c 2 $B/timeit 41 20 mold --no-threads $COMMON $PRE $OBJS $GROUP $POST -o $OUT/$CASE-$KIND.mold
            printf '$CASE $KIND lld 1 thread '; taskset -c 2 $B/timeit 41 20 ld.lld --threads=1 $COMMON $PRE $OBJS $GROUP $POST -o $OUT/$CASE-$KIND.lld
            for o in ours ours8 wild mold lld; do printf '%s ' \$o; $OUT/$CASE-$KIND.\$o --version > /dev/null 2>&1; echo \$?; done
        " > $log/appendix-$CASE-$KIND.log 2>&1; echo "appendix-$CASE-$KIND=$? $(date -Is)" >> $log/status
    done
done
echo "done $(date -Is)" >> $log/status
