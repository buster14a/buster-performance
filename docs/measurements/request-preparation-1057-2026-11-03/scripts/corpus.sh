#!/bin/bash
# The record's fourth hold (#1057): a representative multi-file corpus beside sqlite3.c, Lua 5.4.8's 33 units but
# luac.c (the sources #1128's record measured, copied into inputs/lua with their sha256sums), as one command each by
# --lanes 1 -fsyntax-only and by --lanes 1 -c, interleaved by time-runs (11 runs, one warm-up, CPU 2); then each
# build's 33 objects compared byte for byte. Run under the 9700X's lock.
set -u
export LC_ALL=C
R=$HOME/buster-fast-bench/1057-claude/record; L=$R/logs
main=$R/trees/tree-754475d4/build/compiler; head=$R/trees/tree-4670b2eb/build/compiler
mkdir -p $R/inputs/lua $R/out/lua-run $R/out/lua-main $R/out/lua-head
cp $HOME/buster-fast-bench/1128-claude/record/lua/*.c $HOME/buster-fast-bench/1128-claude/record/lua/*.h $R/inputs/lua/
(cd $R/inputs/lua && sha256sum *.c *.h > $L/lua-sources.txt)
lua=(-std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -w)
files=$(ls $R/inputs/lua/*.c)
echo "lua units $(echo $files | wc -w)" >> $L/receipts.txt
cd $R/out/lua-run
taskset -c 2 $main time-runs --runs 11 --warmups 1 --build main $main --build head $head --list --lanes 1 -fsyntax-only "${lua[@]}" $files --list --lanes 1 -c "${lua[@]}" $files > $L/lua.log 2>&1
echo "lua time-runs status $?" >> $L/receipts.txt
for b in main head; do exe=$main; [ $b = head ] && exe=$head
    (cd $R/out/lua-$b && taskset -c 2 $exe --lanes 1 -c "${lua[@]}" $files); echo "lua -c $b status $? ($(ls $R/out/lua-$b/*.o | wc -l) objects)" >> $L/receipts.txt
done
differ=0
for o in $R/out/lua-main/*.o; do cmp -s $o $R/out/lua-head/$(basename $o) || { differ=1; echo "lua object $(basename $o) DIFFERS" >> $L/receipts.txt; }; done
[ $differ = 0 ] && echo "lua objects identical" >> $L/receipts.txt
(cd $R/out && sha256sum lua-main/*.o lua-head/*.o) > $L/lua-objects.txt
