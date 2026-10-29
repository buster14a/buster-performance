#!/bin/bash
# #776's evidence on the 9700X: the experiment's head built (tree-t776); test-check-units with --corpus there; then, by
# one executable with and without --units-walk, whole processes (time-runs, CPUs 0 to 7) of Lua's 33 units linked,
# synth's 512 linked and musl's 1,006 with -c at 1, 2, 4 and 8 lanes, with their peak resident sets; the walk's stage and
# counts (--time-stages) on 8 lanes; and benchmark-files on the same roots and options, for the files the walk prepares
# that no unit enters. Every build, test and measurement holds the host's lock for itself.
set -u
W=$HOME/buster-fast-bench/units-152-claude
echo $$ > $W/ev776.pid
E=$W/exp
export TMPDIR=$W/tmp
lock() { EXCLUSIVE_OWNER=claude-152 EXCLUSIVE_TITLE="tackle #776-#779 (#776: one cache for the units)" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/776" ~/buster-fast-bench/exclusive.sh "$@"; }
results() { sed -n 's/^\(list [0-9]*\) \[.*\]\(.*\)$/\1\2/p; /^time-runs:/p'; }
OUT=$W/ev776
rm -rf $OUT && mkdir -p $OUT/runs $OUT/musl/probe
(cd $E/tree-t776 && rm -rf build && BUSTER_DEBUG_INFO=0 lock ./build.sh 2>&1 | tail -1)
[ -x $E/tree-t776/build/compiler ] || { echo "the build of t776 failed"; exit 1; }
H=$E/tree-t776/build/compiler
sha256sum $H

echo "== tests at #776's head"
cd $E/tree-t776
ln -sfn $W/inputs/c-testsuite build/c-testsuite
n=0
for t in "test-check-units" "test-check-units --corpus build/c-testsuite/tests/single-exec" "test-files"; do
    n=$((n + 1))
    lock bash -c "taskset -c 0-7 ./build/compiler $t > $OUT/test-$n.log 2>&1; echo \"$t: status \$?\""
    grep -m5 -i "fail" $OUT/test-$n.log
    grep "corpus:" $OUT/test-$n.log
    tail -1 $OUT/test-$n.log
done
lock bash -c "./build/compiler test-call-graph 2>&1 | tail -1; ./build.sh check-call-graph 2>&1 | tail -2"

LUA=$W/inputs/lua-5.4.8/src
LUAFILES=$(cd $LUA && ls *.c | grep -v '^luac.c$' | sed "s|^|$LUA/|" | tr '\n' ' ')
DEFINES="-std=gnu99 -U__ELF__ -DLUA_COMPAT_5_3 -DLUA_USE_LINUX"
SYN=$(ls $W/explore/synth/unit_*.c | tr '\n' ' ')
m=$HOME/buster-fast-bench/refine-claude/inputs/musl
flags="-std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -I$m/arch/x86_64 -I$m/arch/generic -I$m/obj/src/internal -I$m/src/include -I$m/src/internal -I$m/obj/include -I$m/include"
base=$(cd $m && ls src/*/*.c | sort)
replaced=$(cd $m && for a in src/*/x86_64/*.[csS]; do d2=$(dirname $(dirname $a)); f=$(basename $a); echo "$d2/${f%.*}.c"; done | sort -u)
selected=$( (comm -23 <(echo "$base") <(echo "$replaced"); cd $m && ls src/*/x86_64/*.c) | sort)
(cd $OUT/musl/probe && lock taskset -c 0-7 $H --lanes 8 -c $flags $(for s in $selected; do echo -n "$m/$s "; done) 2> ../probe_errors.txt)
MUSL=$(for s in $selected; do f=$(basename $s .c); [ -f $OUT/musl/probe/$f.o ] && echo -n "$m/$s "; done)
echo "musl: $(echo $MUSL | wc -w) units"

cd $OUT/runs
echo "== the walk's stage and counts, by 8 lanes (three runs each)"
lock bash -c "for r in 1 2 3; do for walk in plain --units-walk; do flag=\$walk; [ \$walk = plain ] && flag=; echo \"lua \$walk run \$r\"; taskset -c 0-7 $H --time-stages --lanes 8 \$flag $DEFINES -o lua_st $LUAFILES -lm -ldl 2>&1 | grep -E '^time-stage.(setup|walk|lanes|total)|^units-walk|^time-process.peak'; done; done"
lock bash -c "for r in 1 2 3; do for walk in plain --units-walk; do flag=\$walk; [ \$walk = plain ] && flag=; echo \"synth \$walk run \$r\"; taskset -c 0-7 $H --time-stages --lanes 8 \$flag -o synth_st $SYN 2>&1 | grep -E '^time-stage.(setup|walk|lanes|total)|^units-walk|^time-process.peak'; done; done"
lock bash -c "cd $OUT/musl && for r in 1 2 3; do for walk in plain --units-walk; do flag=\$walk; [ \$walk = plain ] && flag=; echo \"musl \$walk run \$r\"; rm -f *.o; taskset -c 0-7 $H --time-stages --lanes 8 \$flag -c $flags $MUSL 2>&1 | grep -E '^time-stage.(setup|walk|lanes|total)|^units-walk|^time-process.peak'; done; done"

echo "== Lua's link (time-runs): for each of --lanes 1, 2, 4, 8: plain, then --units-walk"
lists=()
for lanes in 1 2 4 8; do for walk in "" "--units-walk"; do lists+=(--list -c "taskset -c 0-7 $H --lanes $lanes $walk $DEFINES -o lua_tr $LUAFILES -lm -ldl"); done; done
lock $H time-runs --executable /bin/sh --runs 15 "${lists[@]}" | results
echo 'print(6 * 7)' | ./lua_tr -
echo "== synth's link (time-runs): for each of --lanes 1, 2, 4, 8: plain, then --units-walk"
lists=()
for lanes in 1 2 4 8; do for walk in "" "--units-walk"; do lists+=(--list -c "taskset -c 0-7 $H --lanes $lanes $walk -o synth_tr $SYN"); done; done
lock $H time-runs --executable /bin/sh --runs 5 "${lists[@]}" | results
./synth_tr | tail -1
cd $OUT/musl
echo "== musl's -c (time-runs): for each of --lanes 1, 2, 4, 8: plain, then --units-walk"
lists=()
for lanes in 1 2 4 8; do for walk in "" "--units-walk"; do lists+=(--list -c "rm -f *.o; taskset -c 0-7 $H --lanes $lanes $walk -c $flags $MUSL"); done; done
lock $H time-runs --executable /bin/sh --runs 7 "${lists[@]}" | results

echo "== benchmark-files: the walks of the same roots, with what they prepare that no unit enters"
lock taskset -c 0-7 $H benchmark-files --lanes 1,8 --runs 11 $DEFINES $LUAFILES 2>&1 | grep -v "^  title\|^  link" | tail -30
lock taskset -c 0-7 $H benchmark-files --lanes 1,8 --runs 11 $flags $MUSL 2>&1 | tail -30
lock taskset -c 0-7 $H benchmark-files --lanes 1,8 --runs 5 $SYN 2>&1 | tail -30
echo ev776-finished
