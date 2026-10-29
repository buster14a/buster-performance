#!/bin/bash
# #777's evidence on the 9700X: #777's head (015ca7c9) built beside #778's at the same merge of main (51063d23, tree-t778m);
# the tests #777 changes at #777's
# head; then whole processes (time-runs, CPUs 0 to 7) of a few large units, SQLite 3.53.4's sqlite3.c and shell.c, with
# -c and linked, by each head, against the two units' processes run at once (with -c, and with -c then cc's link) and
# against sqlite3.c alone; and Lua's, synth's and musl's commands by each head, with their peak resident sets. Every
# build, test and measurement holds the host's lock for itself.
set -u
W=$HOME/buster-fast-bench/units-152-claude
echo $$ > $W/ev777.pid
E=$W/exp
export TMPDIR=$W/tmp
lock() { EXCLUSIVE_OWNER=claude-152 EXCLUSIVE_TITLE="tackle #776-#779 (#777: a few large units)" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/777" ~/buster-fast-bench/exclusive.sh "$@"; }
results() { sed -n 's/^\(list [0-9]*\) \[.*\]\(.*\)$/\1\2/p; /^time-runs:/p'; }
OUT=$W/ev777
rm -rf $OUT && mkdir -p $OUT/sqlite $OUT/runs $OUT/musl/probe
for t in t778m t777; do
    (cd $E/tree-$t && rm -rf build && BUSTER_DEBUG_INFO=0 lock ./build.sh 2>&1 | tail -1)
    [ -x $E/tree-$t/build/compiler ] || { echo "the build of $t failed"; exit 1; }
done
A=$E/tree-t778m/build/compiler
H=$E/tree-t777/build/compiler
sha256sum $A $H

echo "== tests at #777's head"
cd $E/tree-t777
ln -sfn $W/inputs/c-testsuite build/c-testsuite
n=0
for t in "test-check-units" "test-check-units --corpus build/c-testsuite/tests/single-exec" "test-check-lanes" "test-checker-driver --executable ./build/compiler" "test-check-debug --cross-check" "test-lanes"; do
    n=$((n + 1))
    lock bash -c "taskset -c 0-7 ./build/compiler $t > $OUT/test-$n.log 2>&1; echo \"$t: status \$?\""
    grep -m5 -i "fail" $OUT/test-$n.log
    grep "shared parts" $OUT/test-$n.log
    tail -1 $OUT/test-$n.log
done
lock bash -c "./build/compiler test-call-graph 2>&1 | tail -1; ./build.sh check-call-graph 2>&1 | tail -2"

S=$HOME/buster-fast-bench/claude-linker-80/inputs/sqlite-amalgamation-3530400
cd $OUT/sqlite
echo "== a few large units: sqlite3.c and shell.c"
# The units' outputs by each head, and once with --shared-parts' report, outside the timing.
lock bash -c "taskset -c 0-7 $H -c --shared-parts $S/sqlite3.c $S/shell.c 2>&1 | tail -3; mkdir -p one && cd one && taskset -c 0-7 $H -c $S/sqlite3.c && taskset -c 0-7 $H -c $S/shell.c"
cmp sqlite3.o one/sqlite3.o && cmp shell.o one/shell.o && echo "-c of both at once: each object its own alone"
lock bash -c "taskset -c 0-7 $H -o sqlite_units $S/sqlite3.c $S/shell.c -lm 2>&1 | tail -3; taskset -c 0-7 $H --lanes 1 -o sqlite_one $S/sqlite3.c $S/shell.c -lm 2>&1 | tail -3"
cmp sqlite_units sqlite_one && echo "linked by default and by one lane: the same bytes"
echo "select 6 * 7;" | ./sqlite_units
echo "lists: 1-2 -c of both by #778, #777; 3 -c of each, two processes at once; 4 -c of sqlite3.c alone; 5 the same by --lanes 1;"
echo "       6-7 linked by #778, #777; 8 -c of each at once, then cc's link"
lists=()
for c in $A $H; do lists+=(--list -c "taskset -c 0-7 $c -c $S/sqlite3.c $S/shell.c"); done
lists+=(--list -c "taskset -c 0-7 $H -c -o a.o $S/sqlite3.c & taskset -c 0-7 $H -c -o b.o $S/shell.c & wait")
lists+=(--list -c "taskset -c 0-7 $H -c -o a.o $S/sqlite3.c")
lists+=(--list -c "taskset -c 0-7 $H --lanes 1 -c -o a.o $S/sqlite3.c")
for c in $A $H; do lists+=(--list -c "taskset -c 0-7 $c -o sqlite_tr $S/sqlite3.c $S/shell.c -lm"); done
lists+=(--list -c "taskset -c 0-7 $H -c -o a.o $S/sqlite3.c & taskset -c 0-7 $H -c -o b.o $S/shell.c & wait; taskset -c 0-7 cc -o sqlite_cc a.o b.o -lm")
lock $H time-runs --executable /bin/sh --runs 15 "${lists[@]}" | results
echo "select 6 * 7;" | ./sqlite_tr && echo "select 6 * 7;" | ./sqlite_cc

cd $OUT/runs
echo "== synth's link: lists 1-2 --lanes 8 by #778, #777; 3-4 --lanes 1"
SYN=$(ls $W/explore/synth/unit_*.c | tr '\n' ' ')
lists=()
for lanes in 8 1; do for c in $A $H; do lists+=(--list -c "taskset -c 0-7 $c --lanes $lanes -o synth_tr $SYN"); done; done
lock $H time-runs --executable /bin/sh --runs 7 "${lists[@]}" | results
./synth_tr | tail -1
LUA=$W/inputs/lua-5.4.8/src
LUAFILES=$(cd $LUA && ls *.c | grep -v '^luac.c$' | sed "s|^|$LUA/|" | tr '\n' ' ')
DEFINES="-std=gnu99 -U__ELF__ -DLUA_COMPAT_5_3 -DLUA_USE_LINUX"
echo "== Lua's link: lists 1-2 --lanes 8 by #778, #777; 3-4 --lanes 1"
lists=()
for lanes in 8 1; do for c in $A $H; do lists+=(--list -c "taskset -c 0-7 $c --lanes $lanes $DEFINES -o lua_tr $LUAFILES -lm -ldl"); done; done
lock $H time-runs --executable /bin/sh --runs 15 "${lists[@]}" | results
echo 'print(6 * 7)' | ./lua_tr -

cd $OUT/musl
m=$HOME/buster-fast-bench/refine-claude/inputs/musl
flags="-std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -I$m/arch/x86_64 -I$m/arch/generic -I$m/obj/src/internal -I$m/src/include -I$m/src/internal -I$m/obj/include -I$m/include"
base=$(cd $m && ls src/*/*.c | sort)
replaced=$(cd $m && for a in src/*/x86_64/*.[csS]; do d2=$(dirname $(dirname $a)); f=$(basename $a); echo "$d2/${f%.*}.c"; done | sort -u)
selected=$( (comm -23 <(echo "$base") <(echo "$replaced"); cd $m && ls src/*/x86_64/*.c) | sort)
(cd probe && lock taskset -c 0-7 $H --lanes 8 -c $flags $(for s in $selected; do echo -n "$m/$s "; done) 2> ../probe_errors.txt)
units=$(for s in $selected; do f=$(basename $s .c); [ -f probe/$f.o ] && echo -n "$m/$s "; done)
echo "== musl's -c, $(echo $units | wc -w) units: lists 1-2 --lanes 8 by #778, #777; 3-4 --lanes 1"
lists=()
for lanes in 8 1; do for c in $A $H; do lists+=(--list -c "rm -f *.o; taskset -c 0-7 $c --lanes $lanes -c $flags $units"); done; done
lock $H time-runs --executable /bin/sh --runs 7 "${lists[@]}" | results
echo ev777-finished
