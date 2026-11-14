#!/usr/bin/env bash
# luapad.sh: Lua's arithmetic script by each build at link order 1 after a pad of 0 to 960 bytes, in one hold: cycles,
# instructions and retired branch mispredictions, three runs each, pinned to CPU 2.
set -u
W=$HOME/buster-fast-bench/2618e-claude
export EXCLUSIVE_OWNER=claude-2618 EXCLUSIVE_TITLE='GitHub issue #2618 (rest) and #2685: Lua arithmetic by alignment' EXCLUSIVE_LINK=https://claude.ai/code/session_01NNmNQsNkec1N4WJ65hh6VB
D=$W/luaprof/pad
mkdir -p $D
cat > $D/one.sh <<EOS
set -u
head -1 /var/lib/buster-9700x/owner >> $W/holds.txt
perm="\$(sed -n 2p $W/orders.txt | cut -d' ' -f2-)"
for n in 0 64 128 256 512 576 960; do
  pad=""
  if [ \$n != 0 ]; then
    printf '.text\n.globl buster_pad_%d\nbuster_pad_%d:\n.skip %d, 0xcc\n.section .note.GNU-stack,"",@progbits\n' \$n \$n \$n > $D/pad-\$n.s
    cc -c -o $D/pad-\$n.o $D/pad-\$n.s || exit 1
    pad=$D/pad-\$n.o
  fi
  for t in base head; do
    objs=""; for f in \$perm; do objs="\$objs $W/obj-\$t/\$f.o"; done
    cc -o $D/lua-\$t-p\$n \$pad \$objs -lm -ldl || exit 1
    nm $D/lua-\$t-p\$n | grep -E ' (luaV_mod|luaV_execute)\$' | tr '\n' ' ' >> $D/addresses.txt; echo "\$t p\$n" >> $D/addresses.txt
  done
done
cd $W/inputs
for k in 1 2 3; do
  for n in 0 64 128 256 512 576 960; do
    for t in base head; do
      taskset -c 2 perf stat -x, -e cycles:u,instructions:u,ex_ret_brn_misp:u -o $D/one.txt $D/lua-\$t-p\$n arithmetic.lua > $D/out-\$t-\$n.txt 2>&1
      echo "\$k \$n \$t \$(grep -v '^#' $D/one.txt | grep . | awk -F, '{printf "%s=%s ", \$3, \$1}')" >> $D/runs.txt
    done
  done
done
EOS
timeout 900 ~/buster-fast-bench/exclusive.sh bash $D/one.sh
echo "exit $?" > $D/done
