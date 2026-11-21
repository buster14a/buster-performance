#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window";root=$PWD;source ./corpora.sh
until [[ -f results/macrobank/.built ]];do sleep 2;done
out=$root/enum-and-macro-objects;mkdir -p "$out"
scratch=$(mktemp -d /dev/shm/buster2850-ppchecks.XXXXXXXX);trap 'rm -rf -- "$scratch"' EXIT
source_root="$HOME/buster-fast-bench/2850-codex-step2/trees/chainprbase6e9"
main_arguments="-march=znver5 -I$source_root/src -fwrapv -funsigned-char --predefines $root/oracle/predefines.h $source_root/src/buster/compiler/main.c"
for c in main sqlite lua musl;do key=${c}_arguments;eval "cmd=(${!key})";size=1
 case $c in main|sqlite)cmd+=(-o "$scratch/unit.o");;lua)size=34;;musl)size=1336;;esac
 for flag in default extra;do opts=();[[ $flag != extra ]] || opts=(-Wall -Wextra)
  for tag in enumqueuebase enumqueue macrobank;do
   cc=$root/results/$tag/compiler;p=$out/$c-$flag-$tag
   (cd "$scratch"; rm -f -- ./*.o
     "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 "$@" >"$p.stdout" 2>"$p.stderr"' _ "$p" env BUSTER_TEST_PP_FILE_MACRO_BANK=1 "$cc" --lanes 1 "${opts[@]}" -c "${cmd[@]}" >"$p.lock" 2>&1
     python3 "$HOME/buster-fast-bench/2850-codex-step2/full-chain-manifest.py" "$p.objects" "$size"
   )
   for ext in stdout stderr objects;do cmp "$p.$ext" "$out/$c-$flag-enumqueuebase.$ext";done
   echo "$c $flag $tag $size" >> "$out/status"
  done
 done
done;date -u +%FT%TZ > "$out/done"
