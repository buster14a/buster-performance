#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window";root=$PWD;source ./corpora.sh
out=$root/location-printer;mkdir -p "$out"
base=$HOME/buster-fast-bench/2850-codex-step2/trees/chainprbase6e9
clang=$(sed -n 's/.*toolchain: clang \([^ ]*\) (.*/\1/p' "$HOME/buster-fast-bench/2850-codex-step2/results/chainprbase6e9/build.log" | head -1)
until [[ -d trees/locfinal ]];do sleep 1;done
for tag in before locfinal;do
 src=$base;args=();if [[ $tag != before ]];then src=$root/trees/locfinal;args=(-DLOCATION_VIEW);fi
 for tool in printer;do
  "$root/lock.sh" taskset -c 2 "$clang" -std=gnu17 -march=znver5 -O3 -fwrapv -funsigned-char "${args[@]}" -I"$src/src" "$root/pp-source-location-$tool.c" -o "$out/$tag-$tool" >"$out/$tag-$tool.build" 2>&1
 done
done
date -u +%FT%TZ >"$out/built"
cd "$base";main_arguments="-march=znver5 -Isrc -fwrapv -funsigned-char --predefines $root/oracle/predefines.h src/buster/compiler/main.c"
for c in sqlite lua musl main;do
 key=${c}_arguments;eval "args=(${!key})";opts=();files=()
 for a in "${args[@]}";do if [[ $a == *.c ]];then files+=("$a");else opts+=("$a");fi;done
 for mode in before poison;do
  cc=$out/locfinal-printer;[[ $mode != before ]] || cc=$out/before-printer
  pref=$out/$c-$mode
  "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 "$@" >"$p.data" 2>"$p.files"' _ "$pref" env BUSTER_TEST_PP_FILE_LOCATIONS="$mode" "$cc" "${opts[@]}" -- "${files[@]}" >"$pref.lock" 2>&1
  sha256sum "$pref.data" >"$pref.sha";wc -c "$pref.data" >"$pref.bytes"
  [[ $mode == before ]] || { cmp "$out/$c-before.data" "$pref.data"; cmp "$out/$c-before.files" "$pref.files"; rm "$pref.data"; }
  echo "$c $mode pass" >>"$out/status"
 done
 rm "$out/$c-before.data"
done
date -u +%FT%TZ >"$out/done"
