#!/usr/bin/env bash
# empty-lm.sh HEAD: the startup baseline as the c-testsuite programs link: the empty program with -lm, by each compiler
# (clang's and tcc's links then load libm, as every program's does; buster's binds it as needed, so not), and perf
# stat's user-space instructions of 5 runs of it, in one hold of the shared lock, pinned to CPU 2.
. ~/buster-fast-bench/claude-141-reciprocal/common.sh
head=$1
B=$PWD/$head/build/compiler
cts=$PWD/corpora-$head/cts
"$lock" bash -c "cd $cts && taskset -c 2 $B -o bin-t0/empty-lm empty.c -lm && taskset -c 2 $B --tier1 -fno-asynchronous-unwind-tables -o bin-t1/empty-lm empty.c -lm && taskset -c 2 $B --tier1 --scalar -fno-asynchronous-unwind-tables -o bin-t1s/empty-lm empty.c -lm && taskset -c 2 clang -O0 -o bin-clang0/empty-lm empty.c -lm && taskset -c 2 clang -O2 -o bin-clang2/empty-lm empty.c -lm && taskset -c 2 tcc -o bin-tcc/empty-lm empty.c -lm; : > empty-lm.txt; for c in t0 t1 t1s clang0 clang2 tcc; do for i in 1 2 3 4 5; do taskset -c 2 perf stat -x, -e instructions:u -o stat.out -- bin-\$c/empty-lm > /dev/null 2>&1; echo \"\$c \$(awk -F, '/instructions/ { print \$1 }' stat.out)\" >> empty-lm.txt; done; echo \"\$c needs \$(readelf -d bin-\$c/empty-lm | grep -c NEEDED)\" >> empty-lm.txt; done; rm -f stat.out"
cat $cts/empty-lm.txt
