set -u
head -1 /var/lib/buster-9700x/owner >> /home/david/buster-fast-bench/2618e-claude/holds.txt
unset CPATH C_INCLUDE_PATH
for t in base head; do
    /home/david/buster-fast-bench/2618e-claude/$t/build/compiler --tier1 -fno-asynchronous-unwind-tables -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite -I/home/david/buster-fast-bench/2618e-claude/inputs -c -o /home/david/buster-fast-bench/2618e-claude/lay/st-$t.o /home/david/buster-fast-bench/2618e-claude/inputs/speedtest1-unity.c || exit 1
done
for n in 0 16 32 48 1072 3088; do
    pad=""
    if [ $n != 0 ]; then
        printf '.text\n.globl buster_pad_%d\nbuster_pad_%d:\n.skip %d, 0xcc\n.section .note.GNU-stack,"",@progbits\n' $n $n $n > /home/david/buster-fast-bench/2618e-claude/lay/pad-$n.s
        cc -c -o /home/david/buster-fast-bench/2618e-claude/lay/pad-$n.o /home/david/buster-fast-bench/2618e-claude/lay/pad-$n.s || exit 1
        pad=/home/david/buster-fast-bench/2618e-claude/lay/pad-$n.o
    fi
    for t in base head; do
        (cd /home/david/buster-fast-bench/2618e-claude/lay && cc -o st-$t-p$n $pad st-$t.o -lm) || exit 1
    done
done
