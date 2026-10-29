#!/bin/bash
# #778/#779's evidence on the 9700X: #763's head (29770b85), #779's (520ba859) and #778's (93db248e) built, the
# tests that #778's head changes run there, and the measurements: the link's tail by stage (--time-stages, with the
# write's phases) on synth's 512 units and Lua's 33 by --lanes 8 and 1; whole processes (time-runs) of synth's and
# Lua's links, Lua's with -g, and musl's -c by each head; and the one-file A/B (perf stat -r 11 on CPU 2, in three
# rounds of a rotating order) of the three heads and an A/A copy of #763's. Every build, test and measurement holds
# the host's lock for itself.
set -u
W=$HOME/buster-fast-bench/units-152-claude
echo $$ > $W/ev778.pid
E=$W/exp
export TMPDIR=$W/tmp
lock() { EXCLUSIVE_OWNER=claude-152 EXCLUSIVE_TITLE="tackle #776-#779 (units' link tail)" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/778" ~/buster-fast-bench/exclusive.sh "$@"; }
# time-runs' results without the lists' long arguments; the legend before each run names them.
results() { sed -n 's/^\(list [0-9]*\) \[.*\]\(.*\)$/\1\2/p; /^time-runs:/p'; }
OUT=$W/ev778
rm -rf $OUT && mkdir -p $OUT/ab $OUT/stages $OUT/runs $OUT/musl/probe
for t in t763 t779 t778; do
    (cd $E/tree-$t && rm -rf build && BUSTER_DEBUG_INFO=0 lock ./build.sh 2>&1 | tail -1)
    [ -x $E/tree-$t/build/compiler ] || { echo "the build of $t failed"; exit 1; }
done
A=$E/tree-t763/build/compiler
B=$E/tree-t779/build/compiler
H=$E/tree-t778/build/compiler
sha256sum $A $B $H

echo "== tests at #778's head"
cd $E/tree-t778
ln -sfn $W/inputs/c-testsuite build/c-testsuite
n=0
for t in "test-check-units" "test-check-units --corpus build/c-testsuite/tests/single-exec" "test-checker-driver --executable ./build/compiler" "test-check-debug --cross-check" "test-check-lanes"; do
    n=$((n + 1))
    lock bash -c "taskset -c 0-7 ./build/compiler $t > $OUT/test-$n.log 2>&1; echo \"$t: status \$?\""
    grep -m5 -i "fail" $OUT/test-$n.log
    tail -1 $OUT/test-$n.log
done
lock bash -c "./build/compiler test-call-graph 2>&1 | tail -1; ./build.sh check-call-graph 2>&1 | tail -2"

echo "== stages at #778's head"
cd $OUT/stages
lock bash -c "set -o pipefail; for r in 1 2 3; do for lanes in 8 1; do echo \"synth link, --lanes \$lanes, run \$r\"; taskset -c 0-7 $H --time-stages --lanes \$lanes -o synth $W/explore/synth/unit_*.c 2>&1 | grep -E '^time-(stage|process|write)'; echo status=\$?; done; done"
./synth | tail -1
LUA=$W/inputs/lua-5.4.8/src
LUAFILES=$(cd $LUA && ls *.c | grep -v '^luac.c$' | sed "s|^|$LUA/|" | tr '\n' ' ')
DEFINES="-std=gnu99 -U__ELF__ -DLUA_COMPAT_5_3 -DLUA_USE_LINUX"
lock bash -c "set -o pipefail; for r in 1 2 3; do for lanes in 8 1; do for g in plain -g; do flag=\$g; [ \$g = plain ] && flag=; echo \"lua link, --lanes \$lanes \$g, run \$r\"; taskset -c 0-7 $H --time-stages --lanes \$lanes \$flag $DEFINES -o lua_\$g $LUAFILES -lm -ldl 2>&1 | grep -E '^time-(stage|process|write)'; echo status=\$?; done; done; done"
echo 'print(6 * 7)' | ./lua_plain - && echo 'print(6 * 7)' | ./lua_-g -

cd $OUT/runs
echo "== synth's link (time-runs): lists 1-2 --lanes 8 by #763, #778; lists 3-4 --lanes 1 by #763, #778"
SYN=$(ls $W/explore/synth/unit_*.c | tr '\n' ' ')
lists=()
for lanes in 8 1; do for c in $A $H; do lists+=(--list -c "taskset -c 0-7 $c --lanes $lanes -o synth_tr $SYN"); done; done
lock $H time-runs --executable /bin/sh --runs 7 "${lists[@]}" | results
./synth_tr | tail -1
echo "== Lua's link (time-runs): --lanes 8 then 1, each: plain by #763, #779, #778; -g by #779, #778"
lists=()
for lanes in 8 1; do
    for c in $A $B $H; do lists+=(--list -c "taskset -c 0-7 $c --lanes $lanes $DEFINES -o lua_tr $LUAFILES -lm -ldl"); done
    for c in $B $H; do lists+=(--list -c "taskset -c 0-7 $c --lanes $lanes -g $DEFINES -o lua_tr $LUAFILES -lm -ldl"); done
done
lock $H time-runs --executable /bin/sh --runs 15 "${lists[@]}" | results
echo 'print(6 * 7)' | ./lua_tr -

cd $OUT/musl
m=$HOME/buster-fast-bench/refine-claude/inputs/musl
flags="-std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -I$m/arch/x86_64 -I$m/arch/generic -I$m/obj/src/internal -I$m/src/include -I$m/src/internal -I$m/obj/include -I$m/include"
# musl's Makefile's selection: src/*/*.c but those an arch file replaces, and the arch's own .c files.
base=$(cd $m && ls src/*/*.c | sort)
replaced=$(cd $m && for a in src/*/x86_64/*.[csS]; do d2=$(dirname $(dirname $a)); f=$(basename $a); echo "$d2/${f%.*}.c"; done | sort -u)
selected=$( (comm -23 <(echo "$base") <(echo "$replaced"); cd $m && ls src/*/x86_64/*.c) | sort)
(cd probe && lock taskset -c 0-7 $H --lanes 8 -c $flags $(for s in $selected; do echo -n "$m/$s "; done) 2> ../probe_errors.txt)
units=$(for s in $selected; do f=$(basename $s .c); [ -f probe/$f.o ] && echo -n "$m/$s "; done)
echo "== musl's -c (time-runs), $(echo $units | wc -w) units: lists 1-2 --lanes 8 by #763, #778; lists 3-4 --lanes 1"
lists=()
for lanes in 8 1; do for c in $A $H; do lists+=(--list -c "rm -f *.o; taskset -c 0-7 $c --lanes $lanes -c $flags $units"); done; done
lock $H time-runs --executable /bin/sh --runs 7 "${lists[@]}" | results

echo "== one-file A/B"
D=$OUT/ab
cd $D
cp $A $D/t763-copy
SQ=$HOME/buster-fast-bench/refine-claude/inputs/sqlite3.c
CT=$W/inputs/c-testsuite/tests/single-exec/00220.c
names=(t763 copy t779 t778)
paths=($A $D/t763-copy $B $H)
sha256sum "${paths[@]}"
one() {
    local name=$1 path=$2 what=$3
    shift 3
    taskset -c 2 perf stat -x, -e instructions:u,cycles:u,task-clock -r 11 -o $D/perf-$what-$name-r$round.csv "$path" "$@" > /dev/null 2> $D/stderr-$what-$name.txt
    echo "$what $name round $round status=$?"
}
export -f one
export D
for round in 1 2 3; do
    export round
    script=""
    for k in 0 1 2 3; do
        i=$(( (round - 1 + k) % 4 ))
        script+="one ${names[$i]} ${paths[$i]} c -c -o $D/out-${names[$i]}.o $SQ; "
        script+="one ${names[$i]} ${paths[$i]} syntax -fsyntax-only $SQ; "
        script+="one ${names[$i]} ${paths[$i]} exe -o $D/exe-${names[$i]} $CT; "
    done
    lock bash -c "$script"
done
cmp out-t763.o out-t778.o && cmp out-t763.o out-t779.o && echo "objects: the three heads' -c of sqlite3.c the same bytes"
for f in perf-*.csv; do echo "$f: $(grep -v '^#' $f | grep -v '^$' | cut -d, -f1,3 | tr '\n' ' ')"; done
echo ev778-finished
