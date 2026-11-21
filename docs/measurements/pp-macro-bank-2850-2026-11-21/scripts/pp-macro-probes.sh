#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window";root=$PWD;source ./corpora.sh
until [[ -f results/macrobank/.built ]];do sleep 2;done
out=$root/macrobank-probes;mkdir -p "$out"
clang=$(sed -n 's/.*toolchain: clang \([^ ]*\) (.*/\1/p' "$root/results/macrobank/build.log"|head -1)
for arm in parent bank coverage;do
 src=$root/trees/macrobank;defs=();[[ $arm != parent ]] || src=$root/trees/enumqueuebase;[[ $arm != coverage ]] || defs=(-DPP_BANK_COVERAGE)
 ./lock.sh taskset -c 2 "$clang" -std=gnu17 -march=znver5 -O3 -g0 -fwrapv -funsigned-char "${defs[@]}" -I"$src/src" pp-macro-meter.c -o "$out/$arm-meter" > "$out/$arm-meter.build" 2>&1
 if [[ $arm != coverage ]];then
 ./lock.sh taskset -c 2 "$clang" -DPROBE_IDENTITY -std=gnu17 -march=znver5 -O1 -g0 -fwrapv -funsigned-char -I"$src/src" pp-parser-identity-dump.c -o "$out/$arm-oracle" > "$out/$arm-oracle.build" 2>&1
 fi
done
cd "$HOME/buster-fast-bench/2850-codex-step2/trees/chainprbase6e9"
main_arguments="-march=znver5 -Isrc -fwrapv -funsigned-char --predefines $root/oracle/predefines.h src/buster/compiler/main.c"
for c in sqlite lua musl main;do key=${c}_arguments;eval "args=(${!key})";opts=();files=()
 for a in "${args[@]}";do if [[ $a == *.c ]];then files+=("$a");else opts+=("$a");fi;done
 for arm in parent bank;do
  "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 "$@" >"$p.data" 2>"$p.files"' _ "$out/$c-$arm" env BUSTER_TEST_PP_FILE_MACRO_BANK=1 "$out/$arm-oracle" "${opts[@]}" -- "${files[@]}" >"$out/$c-$arm.lock" 2>&1
 done
 cmp "$out/$c-parent.data" "$out/$c-bank.data";cmp "$out/$c-parent.files" "$out/$c-bank.files"
 sha256sum "$out/$c-parent.data" "$out/$c-bank.data" > "$out/$c.sha256";wc -cl "$out/$c-parent.data" "$out/$c-parent.files" > "$out/$c.bytes";rm "$out/$c-parent.data" "$out/$c-bank.data"
 "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 "$@" >"$p.out" 2>"$p.visits"' _ "$out/$c" env BUSTER_TEST_PP_FILE_MACRO_BANK=1 "$out/coverage-meter" "${opts[@]}" -- "${files[@]}" >"$out/$c.coverage.lock" 2>&1
 echo "$c" >> "$out/status"
done
date -u +%FT%TZ > "$out/done"
