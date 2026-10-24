#!/bin/bash
# link-foreign on the design's appendix inputs (clang's hello.o, tcc and synth objects), timed by the appendix's timeit
# beside mold, wild and lld on one thread: each case its own lock acquisition, after phase2.
base=~/buster-fast-bench/claude-linker-80
B=~/buster-fast-bench/linker-baseline
log=$base/logs2
export EXCLUSIVE_OWNER=claude-linker-80 EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/86
L=~/buster-fast-bench/exclusive.sh
until grep -q '^done' $log/status; do sleep 20; done
C=$base/tree2/build/compiler
GCC=/usr/lib/gcc/x86_64-pc-linux-gnu/16
OUT=$base/appendix-out; mkdir -p $OUT
COMMON="--hash-style=gnu --build-id --eh-frame-hdr -m elf_x86_64 -z now --no-gc-sections"
for CASE in hello tcc synth; do
    case $CASE in
        hello) OBJS="$B/hello.o"; RUNS="41 20" ;;
        tcc) OBJS="$B/tinycc/tcc.o $B/tinycc/libtcc.a -lm -ldl -lpthread"; RUNS="41 20" ;;
        synth) OBJS="$(ls $B/synth_o/*.o | tr '\n' ' ')"; RUNS="11 200" ;;
    esac
    PRE="-pie -dynamic-linker /lib64/ld-linux-x86-64.so.2 /usr/lib/Scrt1.o /usr/lib/crti.o $GCC/crtbeginS.o -L$GCC -L/usr/lib"
    POST="-lgcc --as-needed -lgcc_s --no-as-needed -lc -lgcc --as-needed -lgcc_s --no-as-needed $GCC/crtendS.o /usr/lib/crtn.o"
    EXCLUSIVE_TITLE="Issue 80: link-foreign on the appendix's $CASE" $L bash -c "
        echo == $CASE
        taskset -c 2 $C link-foreign $COMMON --lanes=1 --time $PRE $OBJS $POST -o $OUT/$CASE.foreign 2>&1 | head -20
        $OUT/$CASE.foreign > /dev/null 2>&1 < /dev/null; echo run=\$?
        printf 'link-foreign 1 lane  '; taskset -c 2 $B/timeit $RUNS $C link-foreign $COMMON --lanes=1 $PRE $OBJS $POST -o $OUT/$CASE.foreign1
        printf 'link-foreign 8 lanes '; taskset -c 0-7 $B/timeit $RUNS $C link-foreign $COMMON --lanes=8 $PRE $OBJS $POST -o $OUT/$CASE.foreign8
        printf 'mold 1 thread        '; taskset -c 2 $B/timeit $RUNS mold $COMMON --no-threads $PRE $OBJS $POST -o $OUT/$CASE.mold
        printf 'wild 1 thread        '; taskset -c 2 $B/timeit $RUNS wild $COMMON --no-threads $PRE $OBJS $POST -o $OUT/$CASE.wild
        printf 'lld 1 thread         '; taskset -c 2 $B/timeit $RUNS ld.lld $COMMON --threads=1 $PRE $OBJS $POST -o $OUT/$CASE.lld
        printf 'mold its threads     '; $B/timeit $RUNS mold $COMMON $PRE $OBJS $POST -o $OUT/$CASE.moldt
        printf 'wild its threads     '; $B/timeit $RUNS wild $COMMON $PRE $OBJS $POST -o $OUT/$CASE.wildt
        ls -l $OUT/$CASE.foreign1 $OUT/$CASE.mold $OUT/$CASE.wild $OUT/$CASE.lld | awk '{print \$5, \$9}'
    " >> $log/appendix.log 2>&1; echo "appendix-$CASE=$? $(date -Is)" >> $log/status
done
echo "appendix done $(date -Is)" >> $log/status
