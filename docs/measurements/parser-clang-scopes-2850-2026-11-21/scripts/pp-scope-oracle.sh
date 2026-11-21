#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window";root=$PWD;source ./corpora.sh
until [[ -f results/scopeadmit/.built ]];do sleep 2;done
out=$root/scopeadmit-oracle;mkdir -p "$out"
clang=$(sed -n 's/.*toolchain: clang \([^ ]*\) (.*/\1/p' "$root/results/scopeadmit/build.log"|head -1)
for tag in enumqueuebase scopeadmit;do
 "$root/lock.sh" taskset -c 2 "$clang" -DPROBE_IDENTITY -std=gnu17 -march=znver5 -O1 -g0 -fwrapv -funsigned-char -I"$root/trees/$tag/src" pp-scope-dump.c -o "$out/$tag-oracle" >"$out/$tag.build" 2>&1
done
cd "$HOME/buster-fast-bench/2850-codex-step2/trees/chainprbase6e9"
main_arguments="-march=znver5 -Isrc -fwrapv -funsigned-char --predefines $root/oracle/predefines.h src/buster/compiler/main.c"
for c in sqlite lua musl main;do key=${c}_arguments;eval "args=(${!key})";opts=();files=()
 for a in "${args[@]}";do if [[ $a == *.c ]];then files+=("$a");else opts+=("$a");fi;done
 for mode in 0 1 2 3;do
  tag=scopeadmit;[[ $mode != 0 ]] || tag=enumqueuebase
  "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 "$@" >"$p.data" 2>"$p.files"' _ "$out/$c-$mode" env BUSTER_TEST_SCOPE_ADMISSION="$mode" "$out/$tag-oracle" "${opts[@]}" -- "${files[@]}" > "$out/$c-$mode.lock" 2>&1
  cmp "$out/$c-0.data" "$out/$c-$mode.data";cmp "$out/$c-0.files" "$out/$c-$mode.files"
  sha256sum "$out/$c-$mode.data" > "$out/$c-$mode.sha256";wc -cl "$out/$c-$mode.data" "$out/$c-$mode.files" > "$out/$c-$mode.bytes"
  [[ $mode == 0 ]] || rm "$out/$c-$mode.data"
  echo "$c $mode">>"$out/status"
 done
 rm "$out/$c-0.data"
done
date -u +%FT%TZ > "$out/done"
