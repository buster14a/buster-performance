#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window";root=$PWD;source ./corpora.sh
out=$root/scan-census;mkdir -p "$out/overlay"
src=$root/trees/enumqueuebase/src
python3 pp-scan-census-gen.py "$src/buster/compiler" "$out/overlay"
clang=$(sed -n 's/.*toolchain: clang \([^ ]*\) (.*/\1/p' "$root/results/enumqueuebase/build.log"|head -1)
"$root/lock.sh" taskset -c 2 "$clang" -std=gnu17 -O3 -g0 -march=znver5 -fwrapv -funsigned-char -I"$out/overlay" -I"$src" -I"$src/buster/compiler" pp-scan-census.c -o "$out/probe" >"$out/build" 2>&1
cd "$HOME/buster-fast-bench/2850-codex-step2/trees/chainprbase6e9"
main_arguments="-march=znver5 -Isrc -fwrapv -funsigned-char --predefines $root/oracle/predefines.h src/buster/compiler/main.c"
for c in sqlite main lua musl;do key=${c}_arguments;eval "args=(${!key})";opts=();files=()
 for a in "${args[@]}";do if [[ $a == *.c ]];then files+=("$a");else opts+=("$a");fi;done
 "$root/lock.sh" taskset -c 2 "$out/probe" "${opts[@]}" -- "${files[@]}" >"$out/$c.log" 2>"$out/$c.lock"
 echo "$c">>"$out/status"
done;date -u +%FT%TZ>"$out/done"
