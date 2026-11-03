#!/bin/bash
cd /home/david/buster-fast-bench/1128-claude/lua
L=(-std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -w)
taskset -c 0-7 /home/david/buster-fast-bench/1128-claude/main-a4a2182a/build/compiler time-runs --runs 11 --warmups 1 --build main /home/david/buster-fast-bench/1128-claude/main-a4a2182a/build/compiler --build head /home/david/buster-fast-bench/1128-claude/head-be422b81/build/compiler --build variant /home/david/buster-fast-bench/1128-claude/column-c/build/compiler --list "${L[@]}" --lanes 1 -o /home/david/buster-fast-bench/1128-claude/out/lua *.c -lm -ldl --list "${L[@]}" --lanes 8 -o /home/david/buster-fast-bench/1128-claude/out/lua *.c -lm -ldl
