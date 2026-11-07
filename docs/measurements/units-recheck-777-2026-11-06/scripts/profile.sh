#!/bin/bash
# Where main's one-lane units take more instructions than #763's, in one hold: perf stat of a tiny unit's -c and of Lua's
# link by one lane, and perf record (user instructions) of that link, each tree, CPU 2.
# Usage: profile.sh TREE BASE
. $(dirname $0)/common.sh
TREE=${1:?tree}
BASE=${2:?base tree}
OUT=$W/profile-$TREE
rm -rf $OUT && mkdir -p $OUT/$TREE $OUT/$BASE && cd $OUT
src=$HOME/buster-fast-bench/units-152-claude/inputs/lua-5.4.8/src
files=$(cd $src && ls *.c | grep -v '^luac.c$' | sed "s|^|$src/|" | tr '\n' ' ')
flags="-std=gnu99 -U__ELF__ -DLUA_COMPAT_5_3 -DLUA_USE_LINUX"
echo 'int f(int x) { return x + 1; }' > tiny.c
cat > hold.sh <<EOS
for T in $TREE $BASE; do
    C=$W/\$T/build/compiler
    cd $OUT/\$T
    echo "== \$T"
    perf stat -r 11 -e instructions:u,cycles:u,task-clock taskset -c 2 \$C -c ../tiny.c 2>&1 | grep -E 'instructions|cycles|task-clock|elapsed'
    perf stat -r 5 -e instructions:u,cycles:u,task-clock taskset -c 2 \$C --lanes 1 $flags -o lua $files -lm -ldl 2>&1 | grep -E 'instructions|cycles|task-clock|elapsed'
    perf record -q -e instructions:u -c 200003 -o perf.data taskset -c 2 \$C --lanes 1 $flags -o lua $files -lm -ldl > /dev/null 2>&1; echo record status \$?
done
EOS
lock bash hold.sh
for T in $TREE $BASE; do
    perf report -i $T/perf.data --sort symbol --stdio --no-children 2> /dev/null | grep -v '^#' | grep -v '^$' | head -70 > $T/report.txt
    echo "== $T: the top symbols by user instructions"; head -40 $T/report.txt
done
echo profile-finished
