#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window";root=$PWD
base=$HOME/buster-fast-bench/2850-codex-step2/trees/prepbase232
clang=$(sed -n 's/.*toolchain: clang \([^ ]*\) (.*/\1/p' "$HOME/buster-fast-bench/2850-codex-step2/results/prepbase232/build.log" | head -1)
mkdir -p bracketprod-raw
for tag in before bracket;do
 src=$base;args=();if [[ $tag != before ]];then src=$root/trees/bracketprod;args=(-DPROBE_BRACKET);fi
 ./lock.sh taskset -c 2 "$clang" "${args[@]}" -std=gnu17 -march=znver5 -O1 -g0 -fwrapv -funsigned-char -I"$src/src" pp-parser-bracket-raw.c -o "bracketprod-raw/$tag" >"bracketprod-raw/$tag.build" 2>&1
 ./lock.sh bash -c 'p=$1;exec taskset -c 2 "$p" >"$p.data" 2>"$p.err"' _ "$root/bracketprod-raw/$tag" >"bracketprod-raw/$tag.lock" 2>&1
done
cd bracketprod-raw;cmp before.data bracket.data;sha256sum *.data >hashes;wc -c before.data >bytes;rm -f *.data;date -u +%FT%TZ >done
