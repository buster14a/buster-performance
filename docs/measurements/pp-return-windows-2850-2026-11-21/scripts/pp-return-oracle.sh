#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window";root=$PWD
source ./corpora.sh;mkdir -p return-oracle
base=$HOME/buster-fast-bench/2850-codex-step2/trees/chainprbase6e9
clang=$(sed -n 's/.*toolchain: clang \([^ ]*\) (.*/\1/p' "$HOME/buster-fast-bench/2850-codex-step2/results/chainprbase6e9/build.log" | head -1)
for tag in before return;do
 src=$base;args=();if [[ $tag != before ]];then src=$root/trees/return;args=(-DPROBE_RETURN);fi
 ./lock.sh taskset -c 2 "$clang" "${args[@]}" -std=gnu17 -march=znver5 -O1 -g0 -fwrapv -funsigned-char -I"$src/src" pp-return-oracle.c -o "return-oracle/$tag" >"return-oracle/$tag.build" 2>&1
done
cd "$base";main_arguments="-march=znver5 -Isrc -fwrapv -funsigned-char --predefines $root/oracle/predefines.h src/buster/compiler/main.c"
for c in sqlite lua musl main;do
 key=${c}_arguments;eval "args=(${!key})";opts=();files=();for a in "${args[@]}";do if [[ $a == *.c ]];then files+=("$a");else opts+=("$a");fi;done
 for tag in before stream replay;do
  cc=$root/return-oracle/return;[[ $tag != before ]] || cc=$root/return-oracle/before
  p=$root/return-oracle/$c-$tag
  "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 "$@" >"$p.data" 2>"$p.files"' _ "$p" env BUSTER_TEST_PP_RETURN_WINDOW="$tag" "$cc" "${opts[@]}" -- "${files[@]}" >"$p.lock" 2>&1
 done
 cmp "$root/return-oracle/$c-before.data" "$root/return-oracle/$c-stream.data"
 cmp "$root/return-oracle/$c-before.data" "$root/return-oracle/$c-replay.data"
 (cd "$root/return-oracle" && sha256sum "$c"-*.data > "$c.sha256")
 echo "$c pass" >>"$root/return-oracle/status"
done
date -u +%FT%TZ >"$root/return-oracle/done"
