#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window";root=$PWD;mkdir -p returnguard-meter
base=$HOME/buster-fast-bench/2850-codex-step2/trees/chainprbase6e9
clang=$(sed -n 's/.*toolchain: clang \([^ ]*\) (.*/\1/p' "$HOME/buster-fast-bench/2850-codex-step2/results/chainprbase6e9/build.log" | head -1)
for tag in before returnguard;do
 src=$base;args=();if [[ $tag == returnguard ]];then src=$root/trees/returnguard;args=(-DPROBE_RETURN);fi
 ./lock.sh taskset -c 2 "$clang" "${args[@]}" -std=gnu17 -march=znver5 -O3 -g0 -fwrapv -funsigned-char -I"$src/src" pp-return-meter-guard.c -o "returnguard-meter/$tag" >"returnguard-meter/$tag.build" 2>&1
done
date -u +%FT%TZ >returnguard-meter/done
