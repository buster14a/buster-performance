#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window";root=$PWD;source ./corpora.sh
tag=$1;out=$root/$tag-driver;mkdir -p "$out"
until [[ -f $tag-objects/done ]];do sleep 2;done
scratch=$(mktemp -d /dev/shm/buster2850-pp-admission.XXXXXXXX);trap 'rm -rf -- "$scratch"' EXIT
source_root="$HOME/buster-fast-bench/2850-codex-step2/trees/chainprbase6e9"
main_arguments="-march=znver5 -I$source_root/src -fwrapv -funsigned-char --predefines $root/oracle/predefines.h $source_root/src/buster/compiler/main.c"
for c in main sqlite lua musl;do key=${c}_arguments;eval "cmd=(${!key})"; size=1
 case $c in main|sqlite)cmd+=(-o "$scratch/unit.o");;lua)size=34;;musl)size=1336;;esac
 for flag in default extra;do opts=();[[ $flag != extra ]] || opts=(-Wall -Wextra)
  cc=$root/results/$tag/compiler;p=$out/$c-$flag
  (cd "$scratch"; rm -f -- ./*.o
   "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 "$@" >"$p.stdout" 2>"$p.err"' _ "$p" env BUSTER_TEST_PP_GRAMMAR_STREAM=2 BUSTER_TEST_PP_GRAMMAR_REPORT=1 "$cc" --lanes 1 "${opts[@]}" -c "${cmd[@]}" >"$p.lock" 2>&1
   python3 "$HOME/buster-fast-bench/2850-codex-step2/full-chain-manifest.py" "$p.objects" "$size"
  )
  grep '^grammar-stream ' "$p.err" >"$p.records";grep -v '^grammar-stream ' "$p.err" >"$p.stderr" || true
  test "$(wc -l <"$p.records")" = "$size";for ext in stdout stderr objects;do cmp "$p.$ext" "$root/$tag-objects/$c-$flag-enumqueuebase.$ext";done
  echo "$c $flag" >> "$out/status"
 done
done;date -u +%FT%TZ > "$out/done"
