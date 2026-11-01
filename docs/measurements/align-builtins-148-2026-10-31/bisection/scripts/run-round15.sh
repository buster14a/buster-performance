#!/usr/bin/env bash
# The base with the head with the walk file of the base (tnoadapt): its build, then sqlite -fsyntax-only instructions by the base (t978),
# it and the head (talign10), 3 rounds in turn, pinned to CPU 2, in one hold.
set -u
base=$HOME/buster-fast-bench/solve-148-claude
echo $$ > $base/round15.pid
export EXCLUSIVE_OWNER="claude-solve-148" EXCLUSIVE_TITLE="solve 137/147/148: the align builtins" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/148"
lock=$HOME/buster-fast-bench/exclusive.sh
log=$base/round15.log
: > $log
cd $base/tnoadapt
$lock env BUSTER_DEBUG_INFO=0 ./build.sh > build.log 2> build.err; echo "tnoadapt build $?" >> $log
cd $base
cat > ab15.sh <<'INNER'
#!/usr/bin/env bash
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c)
for round in 1 2 3; do
    for tree in t978 tnoadapt talign10; do
        perf stat -x, -e instructions:u -o ab15-perf.csv taskset -c 2 ./$tree/build/compiler -fsyntax-only "${options[@]}" > /dev/null 2>&1
        echo "syntax $round $tree status $? $(grep instructions ab15-perf.csv | cut -d, -f1)"
    done
done
INNER
chmod +x ab15.sh
$lock ./ab15.sh > ab15.log 2>&1; echo "ab15 $?" >> $log
echo done >> $log
