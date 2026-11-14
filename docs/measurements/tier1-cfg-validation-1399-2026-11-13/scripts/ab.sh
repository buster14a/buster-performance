#!/bin/sh
# #1399: main vs head on the 9700X. Each exclusive.sh call is one run; times are taken inside the hold.
D=~/buster-fast-bench/1399-claude; cd $D; echo $$ > ab.pid; R=$D/ab.txt; rm -f $R
H=beb5de5d9258fec38d584a3bc6e2f8bff9f3c526
SQ=/home/david/buster-fast-bench/1296-codex-20261105/corpus/sqlite
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
export EXCLUSIVE_OWNER=claude-1399 EXCLUSIVE_TITLE="#1399 Tier 1 validation from the position column" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1399
[ -d head ] || git clone -q https://github.com/buster14a/buster head
git -C head fetch -q origin claude/peaceful-mccarthy-x5dbp2; git -C head checkout -q -f $H; git -C head rev-parse HEAD > head/COMMIT
echo "base $(cat base/COMMIT) head $(cat head/COMMIT)" >> $R
(cd head && BUSTER_HOST_ARCH=znver5 ~/buster-fast-bench/exclusive.sh ./build.sh > ../build-head.log 2>&1) || { echo "build failed" >> $R; tail -20 build-head.log >> $R; echo DONE >> $R; exit 1; }
ARGS="-c -w --tier1 --lanes=1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -I$SQ $SQ/sqlite3.c"
cat > round.sh <<B
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -4 | tail -3; cat /proc/loadavg
for r in \$1 \$2; do taskset -c 2 perf stat -x, -r 5 -e instructions:u,cycles:u,task-clock ./\$r/build/compiler $ARGS -o /dev/null 2> stat-\$r.tmp; echo "\$r \$(tr '\n' ' ' < stat-\$r.tmp)"; done
cat /proc/loadavg
B
~/buster-fast-bench/exclusive.sh sh -c "taskset -c 2 ./base/build/compiler $ARGS -o base.sqlite.o && taskset -c 2 ./head/build/compiler $ARGS -o head.sqlite.o" >> $R 2>&1
cmp base.sqlite.o head.sqlite.o && echo "sqlite3.c --tier1 --lanes=1 objects identical" >> $R || echo "objects DIFFER" >> $R
for i in 1 2 3 4 5 6; do if [ $((i % 2)) = 1 ]; then a=base; b=head; else a=head; b=base; fi; echo "round $i" >> $R; ~/buster-fast-bench/exclusive.sh sh round.sh $a $b >> $R 2>&1; done
~/buster-fast-bench/exclusive.sh sh -c "taskset -c 2 perf record -q -c 200003 -e cycles:u -o head2.data -- sh -c 'for i in 1 2 3 4 5 6 7 8 9 10; do ./head/build/compiler $ARGS -o /dev/null; done'" >> $R 2>&1
nice -n 19 perf report -i head2.data --no-children --stdio -q --sort sym --percent-limit 0.8 2>/dev/null | head -20 >> $R
nice -n 19 perf report -i head2.data --no-children --stdio -q --sort sym,srcline --percent-limit 0.01 2>/dev/null | grep -E "tier1_(cfg|emit_cfg|allocate)" > srclines-head.txt
cd head; clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h
t() { name=$1; shift; ~/buster-fast-bench/exclusive.sh timeout -k 5 600 "$@" > ../t_$name.log 2>&1 && echo "$name ok: $(grep -E 'checks|failures' ../t_$name.log | tail -1 | cut -c1-200)" >> $R || { echo "$name FAIL: $(tail -2 ../t_$name.log | cut -c1-300)" >> $R; }; }
t selfcheck ./build/compiler -fsyntax-only -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror src/buster/compiler/main.c
t tier1-cfg ./build/compiler test-tier1-cfg
t tier1-emit ./build/compiler test-tier1-emit
t tier1-pipeline ./build/compiler test-tier1-pipeline --cross-check
t tier1-cfg-simd ./build/compiler test-tier1-cfg-source --simd -march=x86-64-v4 tests/ir/vector-i32.c tests/ir/mask-builtins.c tests/ir/bmi-builtins.c tests/ir/vector-rows.c tests/ir/carrier-rows.c
t tier1-cfg-sqlite env SOURCE_DATE_EPOCH=1792454400 ./build/compiler test-tier1-cfg-source --predefines "$C/provenance/gnu17-pinned-predefines.txt" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include" "$C/sqlite/sqlite3.c"
t check-lanes ./build/compiler test-check-lanes
t tier1-select ./build/compiler test-tier1-select
t tier1-allocation ./build/compiler test-tier1-allocation
echo DONE >> $R
