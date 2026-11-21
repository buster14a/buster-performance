#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window";root=$PWD;source ./corpora.sh
until [[ -f results/grammarsized/.built ]];do sleep 2;done
out=$root/grammarsized-focused;mkdir -p "$out"; cc=$root/results/grammarsized/compiler
"$root/lock.sh" taskset -c 2 python3 pp-grammar-boundaries.py "$root/results/enumqueuebase/compiler" "$cc" "$out/edges" >"$out/edges.log" 2>&1
printf 'int main(void){return 0;}\n' > "$out/fixture.c"
for mode in 0 1 2;do for fault in off on;do st=0;envs=(BUSTER_TEST_PP_GRAMMAR_STREAM="$mode" BUSTER_TEST_PP_GRAMMAR_REPORT=1);[[ $fault != on ]] || envs+=(BUSTER_TEST_PP_GRAMMAR_FAULT=1)
 p="$out/fixture-$mode-$fault";rm -f "$p.o"
 "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 "$@" >"$p.out" 2>"$p.err"' _ "$p" env "${envs[@]}" "$cc" -c -o "$p.o" "$out/fixture.c" >"$p.lock" 2>&1 || st=$?
 echo "$st" > "$p.status";if [[ -f $p.o ]];then sha256sum "$p.o"|cut -d' ' -f1 > "$p.sha256";fi
 if [[ $mode == 2 && $fault == on ]];then test "$st" != 0;grep -q 'take=1' "$p.err";else test "$st" = 0;cmp "$p.sha256" "$out/fixture-0-off.sha256";fi
done;done
eval "args=($sqlite_arguments)";st=0
"$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 "$@" >"$p.out" 2>"$p.err"' _ "$out/sqlite-fault" env BUSTER_TEST_PP_GRAMMAR_STREAM=2 BUSTER_TEST_PP_GRAMMAR_REPORT=1 BUSTER_TEST_PP_GRAMMAR_FAULT=1 "$cc" -c -o "$out/sqlite-fault.o" "${args[@]}" > "$out/sqlite-fault.lock" 2>&1 || st=$?
echo "$st" > "$out/sqlite-fault.status"; test "$st" != 0; grep -q 'take=1' "$out/sqlite-fault.err"
date -u +%FT%TZ > "$out/done"
