#!/bin/bash
# link-foreign on the design's appendix inputs (clang's hello.o, tcc's objects and synth's 513 objects), the output on
# tmpfs as the appendix measured it, timed by the appendix's timeit beside mold, wild and lld: each case its own lock
# acquisition. The objects are named inside the locked script, relative to their directory, so that its one argument
# stays under the kernel's 128 KB limit (phase3's synth case failed on it).
base=~/buster-fast-bench/claude-linker-80
B=~/buster-fast-bench/linker-baseline
log=$base/logs2
export EXCLUSIVE_OWNER=claude-linker-80 EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/86
L=~/buster-fast-bench/exclusive.sh
C=$base/tree2/build/compiler
GCC=/usr/lib/gcc/x86_64-pc-linux-gnu/16
OUT=/tmp/claude-linker-80-appendix; rm -rf $OUT; mkdir -p $OUT
COMMON="--hash-style=gnu --build-id --eh-frame-hdr -m elf_x86_64 -z now --no-gc-sections"
PRE="-pie -dynamic-linker /lib64/ld-linux-x86-64.so.2 /usr/lib/Scrt1.o /usr/lib/crti.o $GCC/crtbeginS.o -L$GCC -L/usr/lib"
POST="-lgcc --as-needed -lgcc_s --no-as-needed -lc -lgcc --as-needed -lgcc_s --no-as-needed $GCC/crtendS.o /usr/lib/crtn.o"
for CASE in hello tcc synth; do
    case $CASE in
        hello) DIR=$B; OBJS='hello.o'; RUNS="41 20" ;;
        tcc) DIR=$B/tinycc; OBJS='tcc.o libtcc.a -lm -ldl -lpthread'; RUNS="41 20" ;;
        synth) DIR=$B/synth_o; OBJS='$(ls *.o | tr "\n" " ")'; RUNS="11 200" ;;
    esac
    EXCLUSIVE_TITLE="Issue 80: link-foreign on the appendix's $CASE, output on tmpfs" $L bash -c "
        cd $DIR || exit 1
        O=\"$OBJS\"
        echo == $CASE, output on tmpfs: \$(echo \$O | wc -w) inputs
        taskset -c 2 $C link-foreign $COMMON --lanes=1 --time $PRE \$O $POST -o $OUT/$CASE.foreign 2>&1 | head -20
        printf 'link-foreign 1 lane  '; taskset -c 2 $B/timeit $RUNS $C link-foreign $COMMON --lanes=1 $PRE \$O $POST -o $OUT/$CASE.foreign1
        printf 'link-foreign 8 lanes '; taskset -c 0-7 $B/timeit $RUNS $C link-foreign $COMMON --lanes=8 $PRE \$O $POST -o $OUT/$CASE.foreign8
        printf 'mold 1 thread        '; taskset -c 2 $B/timeit $RUNS mold $COMMON --no-threads $PRE \$O $POST -o $OUT/$CASE.mold
        printf 'wild 1 thread        '; taskset -c 2 $B/timeit $RUNS wild $COMMON --no-threads $PRE \$O $POST -o $OUT/$CASE.wild
        printf 'lld 1 thread         '; taskset -c 2 $B/timeit $RUNS ld.lld $COMMON --threads=1 $PRE \$O $POST -o $OUT/$CASE.lld
        printf 'mold its threads     '; $B/timeit $RUNS mold $COMMON $PRE \$O $POST -o $OUT/$CASE.moldt
        printf 'wild its threads     '; $B/timeit $RUNS wild $COMMON $PRE \$O $POST -o $OUT/$CASE.wildt
        printf 'lld its threads      '; $B/timeit $RUNS ld.lld $COMMON $PRE \$O $POST -o $OUT/$CASE.lldt
        for f in foreign1 foreign8 lld mold wild; do $OUT/$CASE.\$f > $OUT/$CASE.\$f.stdout 2>&1 < /dev/null; echo \"\$f run=\$?\"; done
        for f in foreign1 foreign8 mold wild; do cmp -s $OUT/$CASE.\$f.stdout $OUT/$CASE.lld.stdout && echo \"\$f prints what lld's prints\"; done
        ls -l $OUT/$CASE.foreign1 $OUT/$CASE.lld $OUT/$CASE.mold $OUT/$CASE.wild | awk '{print \$5, \$9}'
    " >> $log/appendix-tmpfs.log 2>&1; echo "appendix-tmpfs-$CASE=$? $(date -Is)" >> $log/status
done
echo "appendix-tmpfs done $(date -Is)" >> $log/status
