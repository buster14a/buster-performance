#!/bin/bash
# #152: the PR head's build, its units tests, and where a link of synth's units spends its time (--time-stages).
set -u
W=$HOME/buster-fast-bench/units-152-claude
echo $$ > $W/stages.pid
E=$W/exp
export TMPDIR=$W/tmp
lock() { EXCLUSIVE_OWNER=claude-152 EXCLUSIVE_TITLE="solve #152 multi-file driver (head checks, stages)" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/152" ~/buster-fast-bench/exclusive.sh "$@"; }
(cd $E/tree-head && rm -rf build && BUSTER_DEBUG_INFO=0 lock ./build.sh 2>&1 | tail -1)
H=$E/tree-head/build/compiler
sha256sum $H
echo "== tests"
cd $E/tree-head && lock bash -c "timeout 400 ./build/compiler test-check-units 2>&1 | tail -8; echo status=\$?; timeout 300 ./build/compiler test-check-units --corpus $W/inputs/c-testsuite/tests/single-exec 2>&1 | tail -3"
echo "== stages"
mkdir -p $W/final/stages && cd $W/final/stages
lock bash -c "set -o pipefail; for r in 1 2 3; do for lanes in 8 1; do echo \"synth link, --lanes \$lanes, run \$r\"; taskset -c 0-7 $H --time-stages --lanes \$lanes -o synth $W/explore/synth/unit_*.c 2>&1 | grep -E '^time-stage|^time-total|^time-process' ; echo status=\$?; done; done"
./synth | tail -1
LUA=$W/inputs/lua-5.4.8/src
LUAFILES=$(cd $LUA && ls *.c | grep -v '^luac.c$' | sed "s|^|$LUA/|" | tr '\n' ' ')
lock bash -c "set -o pipefail; for r in 1 2 3; do for lanes in 8 1; do echo \"lua link, --lanes \$lanes, run \$r\"; taskset -c 0-7 $H --time-stages --lanes \$lanes -std=gnu99 -U__ELF__ -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -o lua_buster $LUAFILES -lm -ldl 2>&1 | grep -E '^time-stage|^time-process'; echo status=\$?; done; done"
echo 'print(6 * 7)' | ./lua_buster -
echo finished
