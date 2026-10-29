#!/bin/bash
# #778's stages before and after: the stage split alone (ccad85a6, tree-ccad) against #778's head (3c615fda, tree-t778),
# --time-stages of synth's 512 units and Lua's 33 linked by --lanes 8 and 1, three runs each, the two executables in
# turn, each corpus one hold of the host's lock.
set -u
W=$HOME/buster-fast-bench/units-152-claude
E=$W/exp
export TMPDIR=$W/tmp
lock() { EXCLUSIVE_OWNER=claude-152 EXCLUSIVE_TITLE="tackle #776-#779 (units' link tail)" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/778" ~/buster-fast-bench/exclusive.sh "$@"; }
(cd $E/tree-ccad && rm -rf build && BUSTER_DEBUG_INFO=0 lock ./build.sh 2>&1 | tail -1)
[ -x $E/tree-ccad/build/compiler ] || { echo "the build of ccad failed"; exit 1; }
B=$E/tree-ccad/build/compiler
H=$E/tree-t778/build/compiler
sha256sum $B $H
OUT=$W/st778
rm -rf $OUT && mkdir -p $OUT && cd $OUT
LUA=$W/inputs/lua-5.4.8/src
LUAFILES=$(cd $LUA && ls *.c | grep -v '^luac.c$' | sed "s|^|$LUA/|" | tr '\n' ' ')
DEFINES="-std=gnu99 -U__ELF__ -DLUA_COMPAT_5_3 -DLUA_USE_LINUX"
lock bash -c "set -o pipefail; for r in 1 2 3; do for lanes in 8 1; do for c in ccad t778; do echo \"synth link, \$c, --lanes \$lanes, run \$r\"; taskset -c 0-7 $E/tree-\$c/build/compiler --time-stages --lanes \$lanes -o synth $W/explore/synth/unit_*.c 2>&1 | grep -E '^time-stage|^time-process|^time-write'; echo status=\$?; done; done; done"
./synth | tail -1
lock bash -c "set -o pipefail; for r in 1 2 3; do for lanes in 8 1; do for c in ccad t778; do echo \"lua link, \$c, --lanes \$lanes, run \$r\"; taskset -c 0-7 $E/tree-\$c/build/compiler --time-stages --lanes \$lanes $DEFINES -o lua $LUAFILES -lm -ldl 2>&1 | grep -E '^time-stage|^time-process|^time-write'; echo status=\$?; done; done; done"
echo 'print(6 * 7)' | ./lua -
echo st778-finished
