#!/usr/bin/env bash
# One out-of-line helper for both builtins' evidence (talign11): its build, its walk's frame, then sqlite -fsyntax-only, sqlite -c
# and stb -c instructions by the base (t978) and it, 3 rounds in turn, pinned to CPU 2, in one hold.
set -u
base=$HOME/buster-fast-bench/solve-148-claude
echo $$ > $base/round16.pid
export EXCLUSIVE_OWNER="claude-solve-148" EXCLUSIVE_TITLE="solve 137/147/148: the align builtins" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/148"
lock=$HOME/buster-fast-bench/exclusive.sh
log=$base/round16.log
: > $log
cd $base/talign11
$lock env BUSTER_DEBUG_INFO=0 ./build.sh > build.log 2> build.err; echo "talign11 build $?" >> $log
cd $base
a=$(nm -S -t x talign11/build/compiler | awk "\$4 == \"check_input_expressions\" { print \$1, \$2 }"); set -- $a; start=$((16#$1)); size=$((16#$2)); echo "talign11 frame $(objdump -d --no-show-raw-insn --start-address=$start --stop-address=$((start + size)) talign11/build/compiler | grep -m1 "sub .*,%rsp") size $size" >> $log
cat > ab16.sh <<'INNER'
#!/usr/bin/env bash
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
stb=$HOME/buster-fast-bench/classify-148-claude/stb
options=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c)
for round in 1 2 3; do
    for tree in t978 talign11; do
        perf stat -x, -e instructions:u -o ab16-perf.csv taskset -c 2 ./$tree/build/compiler -fsyntax-only "${options[@]}" > /dev/null 2>&1
        echo "syntax $round $tree status $? $(grep instructions ab16-perf.csv | cut -d, -f1)"
        perf stat -x, -e instructions:u -o ab16-perf.csv taskset -c 2 ./$tree/build/compiler -c "${options[@]}" -o ab16-$tree.o > /dev/null 2>&1
        echo "c $round $tree status $? $(grep instructions ab16-perf.csv | cut -d, -f1)"
        perf stat -x, -e instructions:u -o ab16-perf.csv taskset -c 2 ./$tree/build/compiler -c -march=native -I$stb $stb/stb_image.c -o ab16-stb-$tree.o > /dev/null 2>&1
        echo "stb $round $tree status $? $(grep instructions ab16-perf.csv | cut -d, -f1)"
    done
done
INNER
chmod +x ab16.sh
$lock ./ab16.sh > ab16.log 2>&1; echo "ab16 $?" >> $log
echo done >> $log
