#!/bin/bash
cd /home/david/buster-fast-bench/1128-claude/lua
L=(-std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -w)
uname -r; cat /proc/sys/vm/overcommit_memory; cat /sys/kernel/mm/transparent_hugepage/enabled
lists=()
for n in 1 2 4 8; do lists+=(--list "${L[@]}" --lanes $n -o /home/david/buster-fast-bench/1128-claude/out/lua *.c -lm -ldl); done
taskset -c 0-7 /home/david/buster-fast-bench/1128-claude/main-b70deb47/build/compiler time-runs --runs 11 --warmups 1 --build main /home/david/buster-fast-bench/1128-claude/main-b70deb47/build/compiler --build head /home/david/buster-fast-bench/1128-claude/head-tables1/build/compiler "${lists[@]}"
for b in main head; do for n in 1 8; do
  exe=/home/david/buster-fast-bench/1128-claude/main-b70deb47/build/compiler; [ $b = head ] && exe=/home/david/buster-fast-bench/1128-claude/head-tables1/build/compiler
  taskset -c 0-7 strace -f -c -o /home/david/buster-fast-bench/1128-claude/logs/strace-tables1-$b-$n.txt $exe "${L[@]}" --lanes $n -o /home/david/buster-fast-bench/1128-claude/out/lua-$b-$n *.c -lm -ldl
done; done
sha256sum /home/david/buster-fast-bench/1128-claude/out/lua-main-1 /home/david/buster-fast-bench/1128-claude/out/lua-main-8 /home/david/buster-fast-bench/1128-claude/out/lua-head-1 /home/david/buster-fast-bench/1128-claude/out/lua-head-8
