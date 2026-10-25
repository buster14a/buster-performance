#!/bin/bash
# #87's validation and lane sweeps on the 9700X, on tree87: each step its own lock acquisition.
base=~/buster-fast-bench/claude-linker-80
cd $base/tree87 || exit 1
export EXCLUSIVE_OWNER=claude-linker-80 EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/87
L=~/buster-fast-bench/exclusive.sh
log=$base/logs87; mkdir -p $log
echo "build start $(date -Is)" > $log/status
{ date -Is; cat /sys/devices/system/cpu/online; for c in 0 1 2 3 4 5 6 7 8 9 11 12 13 14 15; do echo "cpu$c $(cat /sys/devices/system/cpu/cpu$c/cpufreq/scaling_governor)"; done; uname -r; } > $log/host.txt
EXCLUSIVE_TITLE="Issue 87: foreign conversion on lanes, build" $L ./build.sh > $log/build.log 2>&1; echo "build=$? $(date -Is)" >> $log/status
sha256sum build/compiler >> $log/host.txt
EXCLUSIVE_TITLE="Issue 87: foreign conversion on lanes, call graph" $L ./build.sh check-call-graph > $log/callgraph.log 2>&1; echo "callgraph=$? $(date -Is)" >> $log/status
sed -n "/<<'TESTS'$/,/^ *TESTS$/{//!{s/^ \{10\}//;p}}" .github/workflows/9700x.yml > $log/tests.txt
EXCLUSIVE_TITLE="Issue 87: foreign conversion on lanes, tests" $L bash -c "clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h && ./build/compiler parallel --timeout 180 $log/tests.txt" > $log/tests.log 2>&1; echo "tests=$? $(date -Is)" >> $log/status
EXCLUSIVE_TITLE="Issue 87: foreign corpus on 1 and 8 lanes against lld and mold" $L ./build/compiler test-foreign-corpus --sqlite ../inputs/sqlite-amalgamation-3530400 --lua ../inputs/lua-5.4.8/src --self . > $log/corpus.log 2>&1; echo "corpus=$? $(date -Is)" >> $log/status
r=0
for order in "1 2 3 4 5 6 7 8 10 12 15" "15 12 10 8 7 6 5 4 3 2 1" "4 1 8 2 12 3 7 15 5 10 6"; do
    r=$((r + 1))
    EXCLUSIVE_TITLE="Issue 87: link-foreign lane sweep, round $r" $L $base/sweep87.sh $order > $log/sweep-r$r.log 2>&1; echo "sweep$r=$? $(date -Is)" >> $log/status
done
B=~/buster-fast-bench/linker-baseline
GCC=/usr/lib/gcc/x86_64-pc-linux-gnu/16
OUT=/tmp/claude-linker-80-lanes; mkdir -p $OUT
COMMON="--hash-style=gnu --build-id --eh-frame-hdr -m elf_x86_64 -z now --no-gc-sections"
PRE="-pie -dynamic-linker /lib64/ld-linux-x86-64.so.2 /usr/lib/Scrt1.o /usr/lib/crti.o $GCC/crtbeginS.o -L$GCC -L/usr/lib"
POST="-lgcc --as-needed -lgcc_s --no-as-needed -lc -lgcc --as-needed -lgcc_s --no-as-needed $GCC/crtendS.o /usr/lib/crtn.o"
for CASE in hello tcc; do
    case $CASE in
        hello) OBJS="$B/hello.o" ;;
        tcc) OBJS="$B/tinycc/tcc.o $B/tinycc/libtcc.a -lm -ldl -lpthread" ;;
    esac
    EXCLUSIVE_TITLE="Issue 87: link-foreign lanes on the appendix's $CASE" $L bash -c "
        for n in 1 2 3 4 8; do
            list=\$(echo 2,0,1,3,4,5,6,7 | cut -d, -f1-\$n)
            printf '$CASE, %d lanes ' \$n; taskset -c \$list $B/timeit 41 20 $base/tree87/build/compiler link-foreign $COMMON --lanes=\$n $PRE $OBJS $POST -o $OUT/$CASE.out
        done
        taskset -c 2 $base/tree87/build/compiler link-foreign $COMMON --lanes=8 --time $PRE $OBJS $POST -o $OUT/$CASE.out
    " > $log/small-$CASE.log 2>&1; echo "small-$CASE=$? $(date -Is)" >> $log/status
done
echo "done $(date -Is)" >> $log/status
