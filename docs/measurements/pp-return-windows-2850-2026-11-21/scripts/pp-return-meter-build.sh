#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window";root=$PWD;mkdir -p return-meter
base=$HOME/buster-fast-bench/2850-codex-step2/trees/chainprbase6e9
clang=$(sed -n 's/.*toolchain: clang \([^ ]*\) (.*/\1/p' "$HOME/buster-fast-bench/2850-codex-step2/results/chainprbase6e9/build.log" | head -1)
for tag in before return;do
 src=$base;args=();if [[ $tag == return ]];then src=$root/trees/return;args=(-DPROBE_RETURN);fi
 ./lock.sh taskset -c 2 "$clang" "${args[@]}" -std=gnu17 -march=znver5 -O3 -g0 -fwrapv -funsigned-char -I"$src/src" pp-return-meter.c -o "return-meter/$tag" >"return-meter/$tag.build" 2>&1
done
date -u +%FT%TZ >return-meter/done
