#!/usr/bin/env bash
# The adapter condition tested op first (talign9): its build, then sqlite -c and stb -c instructions by the base (t978), the
# head (talign8) and it, 3 rounds in turn, each run pinned to CPU 2, in one hold.
set -u
base=$HOME/buster-fast-bench/solve-148-claude
echo $$ > $base/round9.pid
export EXCLUSIVE_OWNER="claude-solve-148" EXCLUSIVE_TITLE="solve 137/147/148: the align builtins" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/148"
lock=$HOME/buster-fast-bench/exclusive.sh
log=$base/round9.log
: > $log
cd $base/talign9
$lock env BUSTER_DEBUG_INFO=0 ./build.sh > build.log 2> build.err; echo "talign9 build $?" >> $log
cd $base
cat > ab9.sh <<'INNER'
#!/usr/bin/env bash
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
stb=$HOME/buster-fast-bench/classify-148-claude/stb
for round in 1 2 3; do
    for tree in t978 talign8 talign9; do
        perf stat -x, -e instructions:u -o ab9-perf.csv taskset -c 2 ./$tree/build/compiler -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c -o ab9-$tree.o > /dev/null 2>&1
        echo "sqlite $round $tree status $? $(grep instructions ab9-perf.csv | cut -d, -f1)"
        perf stat -x, -e instructions:u -o ab9-perf.csv taskset -c 2 ./$tree/build/compiler -c -march=native -I$stb $stb/stb_image.c -o ab9-stb-$tree.o > /dev/null 2>&1
        echo "stb $round $tree status $? $(grep instructions ab9-perf.csv | cut -d, -f1)"
    done
done
INNER
chmod +x ab9.sh
$lock ./ab9.sh > ab9.log 2>&1; echo "ab9 $?" >> $log
echo done >> $log
