# Where the head's extra instructions go: perf's user-instruction samples of -c sqlite3.c by each build, by symbol.
set -e
source ~/buster-fast-bench/1056-claude/common.sh
mkdir -p $root/run && cd $root/run
for tree in base head; do
    $lock taskset -c 2 perf record -q -e instructions:u -c 20011 -o perf-$tree.data -- $root/$tree/build/compiler "${sqlite_options[@]}" -o sqlite3-$tree.o
    perf report -i perf-$tree.data --stdio --sort symbol --no-children 2>/dev/null | grep -v "^#" | grep -v "^$" | head -150 > report-$tree.txt
done
perf diff -c delta --sort symbol perf-base.data perf-head.data 2>/dev/null | grep -v "^#" | grep -v "^$" | head -120 > diff.txt
echo PROFILE-DONE
