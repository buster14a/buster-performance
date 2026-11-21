#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window";root=$PWD;source ./corpora.sh
out=$root/front-profile; mkdir -p "$out";exec 9>"$HOME/buster-fast-bench/2850-codex-step2/our-timing.lock"
base=$HOME/buster-fast-bench/2850-codex-step2/trees/chainprbase6e9
clang=$(sed -n 's/.*toolchain: clang \([^ ]*\) (.*/\1/p' "$HOME/buster-fast-bench/2850-codex-step2/results/chainprbase6e9/build.log" | head -1)
./lock.sh taskset -c 2 "$clang" -std=gnu17 -march=znver5 -O3 -gline-tables-only -fno-omit-frame-pointer -fwrapv -funsigned-char -I"$base/src" pp-return-meter-guard.c -o "$out/probe" >"$out/build" 2>&1
eval "args=($sqlite_arguments)"; f=${args[-1]};opts=("${args[@]:0:${#args[@]}-1}")
files=();for i in {1..100};do files+=("$f");done
flock -x 9
./lock.sh taskset -c 2 perf record -e cycles:u -c 200000 -g -o "$out/samples.perfdata" -- "$out/probe" "${opts[@]}" -- "${files[@]}" >"$out/result" 2>"$out/log"
flock -u 9
perf report -i "$out/samples.perfdata" --stdio --no-children --sort symbol --percent-limit 0.2 >"$out/self.txt"
perf report -i "$out/samples.perfdata" --stdio --no-children --sort symbol,srcline --percent-limit 0.4 -g none >"$out/source.txt"
perf report -i "$out/samples.perfdata" --stdio --children --sort symbol --percent-limit 1 -g none >"$out/inclusive.txt"
date -u +%FT%TZ >"$out/done"
