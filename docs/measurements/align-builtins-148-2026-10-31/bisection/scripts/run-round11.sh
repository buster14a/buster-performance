#!/usr/bin/env bash
# The alignment evidence out of line (talign10): its build, its walk's frame, then sqlite -c and stb -c instructions by the
# base (t978) and it, 3 rounds in turn, pinned to CPU 2, in one hold.
set -u
base=$HOME/buster-fast-bench/solve-148-claude
echo $$ > $base/round11.pid
export EXCLUSIVE_OWNER="claude-solve-148" EXCLUSIVE_TITLE="solve 137/147/148: the align builtins" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/148"
lock=$HOME/buster-fast-bench/exclusive.sh
log=$base/round11.log
: > $log
cd $base/talign10
$lock env BUSTER_DEBUG_INFO=0 ./build.sh > build.log 2> build.err; echo "talign10 build $?" >> $log
cd $base
for t in t978 talign10; do a=$(nm -S -t x $t/build/compiler | awk "\$4 == \"check_input_expressions\" { print \$1, \$2 }"); set -- $a; start=$((16#$1)); size=$((16#$2)); echo "$t frame $(objdump -d --no-show-raw-insn --start-address=$start --stop-address=$((start + size)) $t/build/compiler | grep -m1 "sub .*,%rsp")" >> $log; done
sed "s/talign8 talign9/talign10/; s/ab9-/ab11-/g" ab9.sh > ab11.sh
chmod +x ab11.sh
$lock ./ab11.sh > ab11.log 2>&1; echo "ab11 $?" >> $log
echo done >> $log
