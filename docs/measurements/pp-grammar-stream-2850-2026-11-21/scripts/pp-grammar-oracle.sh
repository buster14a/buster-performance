#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window";root=$PWD;source ./corpora.sh
until [[ -f results/grammarfinal/.built ]];do sleep 2;done
out=$root/grammarfinal-oracle;mkdir -p "$out"
clang=$(sed -n 's/.*toolchain: clang \([^ ]*\) (.*/\1/p' "$root/results/grammarfinal/build.log"|head -1)
for tag in parent take;do src=$root/trees/enumqueuebase;defs=();[[ $tag != take ]] || { src=$root/trees/grammarfinal;defs=(-DPP_GRAMMAR_DUMP); }
 "$root/lock.sh" taskset -c 2 "$clang" -DPROBE_IDENTITY "${defs[@]}" -std=gnu17 -march=znver5 -O1 -g0 -fwrapv -funsigned-char -I"$src/src" pp-grammar-dump.c -o "$out/$tag-oracle" >"$out/$tag.build" 2>&1
done
cd "$HOME/buster-fast-bench/2850-codex-step2/trees/chainprbase6e9"
main_arguments="-march=znver5 -Isrc -fwrapv -funsigned-char --predefines $root/oracle/predefines.h src/buster/compiler/main.c"
for c in sqlite lua musl main;do key=${c}_arguments;eval "args=(${!key})";opts=();files=()
 for a in "${args[@]}";do if [[ $a == *.c ]];then files+=("$a");else opts+=("$a");fi;done
 for tag in parent take;do
  "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 "$@" >"$p.data" 2>"$p.files"' _ "$out/$c-$tag" env BUSTER_TEST_PP_GRAMMAR_STREAM=2 "$out/$tag-oracle" "${opts[@]}" -- "${files[@]}" > "$out/$c-$tag.lock" 2>&1
 done
 cmp "$out/$c-parent.data" "$out/$c-take.data";cmp "$out/$c-parent.files" "$out/$c-take.files"
 sha256sum "$out/$c-parent.data" "$out/$c-take.data" > "$out/$c.sha256";wc -cl "$out/$c-parent.data" "$out/$c-parent.files" > "$out/$c.bytes";rm "$out/$c-parent.data" "$out/$c-take.data"
 "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 "$@" >/dev/null 2>"$p.admission"' _ "$out/$c" env BUSTER_TEST_PP_GRAMMAR_STREAM=2 BUSTER_TEST_PP_GRAMMAR_REPORT=1 "$out/take-oracle" "${opts[@]}" -- "${files[@]}" > "$out/$c-admission.lock" 2>&1
 echo "$c" >> "$out/status"
done
date -u +%FT%TZ > "$out/done"
