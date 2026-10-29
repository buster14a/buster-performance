#!/bin/bash
# #777 with the board's idle lanes sleeping at once (tree-t777s) against #777's head before (tree-t777, 015ca7c9): its
# lane and units tests; sqlite3.c and shell.c with -c as one command by each, and as two processes at once, each twice
# (A/A), 21 runs; then Lua's link (15 runs), synth's (5) and musl's -c (7) by 8 lanes by each. Each a hold of the lock.
set -u
W=$HOME/buster-fast-bench/units-152-claude
E=$W/exp
export TMPDIR=$W/tmp
lock() { EXCLUSIVE_OWNER=claude-152 EXCLUSIVE_TITLE="tackle #776-#779 (#777: a few large units)" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/777" ~/buster-fast-bench/exclusive.sh "$@"; }
results() { sed -n 's/^\(list [0-9]*\) \[.*\]\(.*\)$/\1\2/p; /^time-runs:/p'; }
(cd $E/tree-t777s && rm -rf build && BUSTER_DEBUG_INFO=0 lock ./build.sh 2>&1 | tail -1)
[ -x $E/tree-t777s/build/compiler ] || { echo "the build of t777s failed"; exit 1; }
A=$E/tree-t777/build/compiler
H=$E/tree-t777s/build/compiler
sha256sum $A $H
cd $E/tree-t777s
for t in "test-check-units" "test-lanes"; do
    lock bash -c "taskset -c 0-7 ./build/compiler $t > $W/sl777-test.log 2>&1; echo \"$t: status \$?\"; grep -m5 -i fail $W/sl777-test.log; grep 'shared parts\|advance' $W/sl777-test.log | tail -2; tail -1 $W/sl777-test.log"
done
S=$HOME/buster-fast-bench/claude-linker-80/inputs/sqlite-amalgamation-3530400
OUT=$W/sl777
rm -rf $OUT && mkdir -p $OUT/musl && cd $OUT
echo "== sqlite3.c and shell.c, -c: lists 1, 4 one command by t777; 2, 5 by t777s; 3, 6 two processes at once by t777s"
lists=()
for k in 1 2; do
    lists+=(--list -c "taskset -c 0-7 $A -c $S/sqlite3.c $S/shell.c")
    lists+=(--list -c "taskset -c 0-7 $H -c $S/sqlite3.c $S/shell.c")
    lists+=(--list -c "taskset -c 0-7 $H -c -o a.o $S/sqlite3.c & taskset -c 0-7 $H -c -o b.o $S/shell.c & wait")
done
lock $H time-runs --executable /bin/sh --runs 21 "${lists[@]}" | results
echo "== sqlite3.c and shell.c linked: list 1 by t777, 2 by t777s"
lists=()
for c in $A $H; do lists+=(--list -c "taskset -c 0-7 $c -o sqlite_tr $S/sqlite3.c $S/shell.c -lm"); done
lock $H time-runs --executable /bin/sh --runs 15 "${lists[@]}" | results
echo "select 6 * 7;" | ./sqlite_tr
LUA=$W/inputs/lua-5.4.8/src
LUAFILES=$(cd $LUA && ls *.c | grep -v '^luac.c$' | sed "s|^|$LUA/|" | tr '\n' ' ')
DEFINES="-std=gnu99 -U__ELF__ -DLUA_COMPAT_5_3 -DLUA_USE_LINUX"
SYN=$(ls $W/explore/synth/unit_*.c | tr '\n' ' ')
echo "== by 8 lanes: Lua's link, list 1 t777, 2 t777s"
lists=()
for c in $A $H; do lists+=(--list -c "taskset -c 0-7 $c --lanes 8 $DEFINES -o lua_tr $LUAFILES -lm -ldl"); done
lock $H time-runs --executable /bin/sh --runs 15 "${lists[@]}" | results
echo "== by 8 lanes: synth's link, list 1 t777, 2 t777s"
lists=()
for c in $A $H; do lists+=(--list -c "taskset -c 0-7 $c --lanes 8 -o synth_tr $SYN"); done
lock $H time-runs --executable /bin/sh --runs 5 "${lists[@]}" | results
m=$HOME/buster-fast-bench/refine-claude/inputs/musl
flags="-std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -I$m/arch/x86_64 -I$m/arch/generic -I$m/obj/src/internal -I$m/src/include -I$m/src/internal -I$m/obj/include -I$m/include"
selected=$(cd $m && (comm -23 <(ls src/*/*.c | sort) <(for a in src/*/x86_64/*.[csS]; do d2=$(dirname $(dirname $a)); f=$(basename $a); echo "$d2/${f%.*}.c"; done | sort -u); ls src/*/x86_64/*.c) | sort)
units=$(for s in $selected; do f=$(basename $s .c); [ -f $W/ev778/musl/probe/$f.o ] && echo -n "$m/$s "; done)
cd $OUT/musl
echo "== by 8 lanes: musl's -c ($(echo $units | wc -w) units), list 1 t777, 2 t777s"
lists=()
for c in $A $H; do lists+=(--list -c "rm -f *.o; taskset -c 0-7 $c --lanes 8 -c $flags $units"); done
lock $H time-runs --executable /bin/sh --runs 7 "${lists[@]}" | results
echo sl777-finished
