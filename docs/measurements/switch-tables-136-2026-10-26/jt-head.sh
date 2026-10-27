#!/bin/bash
# The jump tables' head (jump-136-head) against main (backend-136-main) on the 9700X, pinned to CPU 2: the head's build
# under its own hold of the lock; then sqlite3.c's -c interleaved in one hold, eight rounds of a perf stat -r 3 of each
# tree, the first alternating by round; then, in one more hold, the head's objects against the measured branch's
# (1e2bcae3, jump-136-claude): the same .text and .rodata bytes, `size -A`, the lowering's symbols counted, and the
# head's shell running work.sql once, its output compared.
export EXCLUSIVE_OWNER=claude-switch-136 EXCLUSIVE_TITLE="Solve 133 136 137 145" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/136"
unset CPATH C_INCLUDE_PATH
X=~/buster-fast-bench/exclusive.sh
B=~/buster-fast-bench
quiet() { grep -v "^exclusive.sh\|^  title:\|^  link:\|^  pull request:\|^ "; }
cd $B/jump-136-head || exit 1
BUSTER_DEBUG_INFO=0 $X ./build.sh > build.log 2>&1
status=$?
grep "^build.sh: [0-9]* sources compiled" build.log
echo "build status $status"
[ $status = 0 ] || exit 1
$X bash -c '
    B=~/buster-fast-bench
    Q=$B/preprocessor-corpora-astra-01a158dd/sqlite
    for round in 1 2 3 4 5 6 7 8; do
        if [ $((round % 2)) = 1 ]; then order="backend-136-main jump-136-head"; else order="jump-136-head backend-136-main"; fi
        for d in $order; do
            taskset -c 2 perf stat -r 3 -x, -e instructions:u,cycles:u $B/$d/build/compiler -c -I$Q -o $B/$d/interleave.o $Q/sqlite3.c 2> $B/jump-136-head/interleave.tmp
            echo "$round $d $(grep instructions:u $B/jump-136-head/interleave.tmp | cut -d, -f1) $(grep cycles:u $B/jump-136-head/interleave.tmp | cut -d, -f1)"
        done
    done
    rm -f $B/jump-136-head/interleave.tmp
' 2>&1 | grep -E "^[0-9]+ [a-z0-9-]+ [0-9]+ [0-9]+$"
$X bash -c '
    B=~/buster-fast-bench
    Q=$B/preprocessor-corpora-astra-01a158dd/sqlite
    H=$B/jump-136-head
    cd $H || exit 1
    sha256sum build/compiler
    for s in .text .rodata; do
        objcopy -O binary -j $s interleave.o head$s.bin && objcopy -O binary -j $s $B/jump-136-claude/sqlite3.o branch$s.bin &&
            cmp head$s.bin branch$s.bin && echo "$s: the measured branch'"'"'s bytes"
        rm -f head$s.bin branch$s.bin
    done
    size -A interleave.o | grep -E "^\.(text|rodata) "
    echo "the lowering'"'"'s symbols: $(readelf -sW interleave.o | grep -c "\.Lbuster_switch_\|\.Lbuster_case_"); all symbols: $(readelf -sW interleave.o | grep -c "^ *[0-9]*:")"
    echo "the measured branch'"'"'s symbols: $(readelf -sW $B/jump-136-claude/sqlite3.o | grep -c "^ *[0-9]*:")"
    readelf -rW interleave.o | grep "^Relocation section .\.rela\.rodata"
    ./build/compiler -c -I$Q -o shell-sqlite3.o $Q/sqlite3.c && ./build/compiler -c -I$Q -o shell-shell.o $Q/shell.c && cc -o sq shell-sqlite3.o shell-shell.o -lm -lpthread -ldl &&
        taskset -c 2 ./sq :memory: < $B/jump-136-claude/work.sql > out.txt && md5sum out.txt $B/backend-136-main/out.txt
' 2>&1 | quiet
echo done
