#!/bin/bash
D=$HOME/buster-fast-bench/1128-claude
cd $D/lua
for r in 1 2 3; do taskset -c 0-7 perf record -q -F 25000 -g -o $D/logs/perf-main-b70deb47-8-$r.data $D/main-b70deb47/build/compiler -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -w --lanes 8 -o $D/out/lua-p *.c -lm -ldl; done
taskset -c 0-7 perf record -q -F 25000 -g -o $D/logs/perf-main-b70deb47-1-1.data $D/main-b70deb47/build/compiler -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -w --lanes 1 -o $D/out/lua-p *.c -lm -ldl
for n in 1 8; do taskset -c 0-7 $D/main-b70deb47/build/compiler -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -w --lanes $n --time-stages -o $D/out/lua-p *.c -lm -ldl 2>&1 | grep -E 'time-stage\tlanes|time-stage\ttotal|user-ms|system-ms'; done
