#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window";root=$PWD;tag=$1
until [[ -f results/$tag/.built ]];do sleep 2;done
out=$root/$tag-memory;mkdir -p "$out"
cat >"$out/input.c" <<'C'
typedef int I;
int f(I x) { return 5 + x; }
C
cat >"$out/broken.c" <<'C'
typedef int I;
int f(I x) { return 5 + (x; }
C
for memory in plain limit;do
 wrap=();[[ $memory != limit ]] || wrap=(prlimit --as=2147483648 --)
 for file in input broken;do
  for policy in ordinary poisoned;do
   flags=();[[ $policy != poisoned ]] || flags=(--poison-arenas)
   for arm in parent candidate;do
    cc=$root/results/enumqueuebase/compiler;[[ $arm != candidate ]] || cc=$root/results/$tag/compiler
    p=$out/$memory-$file-$policy-$arm; rm -f "$out/current.o"; st=0
    "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 "$@" >"$p.out" 2>"$p.err"' _ "$p" "${wrap[@]}" env BUSTER_TEST_PP_GRAMMAR_STREAM=2 "$cc" "${flags[@]}" -Wall -Wextra -c -o "$out/current.o" "$out/$file.c" >"$p.lock" 2>&1 || st=$?
    echo "$st" > "$p.status"; if [[ -f $out/current.o ]];then sha256sum "$out/current.o" | cut -d' ' -f1 >"$p.elf";else echo none >"$p.elf";fi
   done
   for ext in out err status elf;do cmp "$out/$memory-$file-$policy-parent.$ext" "$out/$memory-$file-$policy-candidate.$ext";done
   echo "$memory $file $policy" >>"$out/status"
  done
 done
 "$root/lock.sh" taskset -c 2 "${wrap[@]}" env BUSTER_TEST_PP_GRAMMAR_STREAM=2 BUSTER_TEST_PP_GRAMMAR_REPORT=1 "$root/results/$tag/compiler" -c -o "$out/current.o" "$out/input.c" > "$out/$memory-trace.out" 2>"$out/$memory-trace.err"
 if [[ $memory == limit ]];then grep -q 'take=0' "$out/$memory-trace.err";else grep -q 'take=1' "$out/$memory-trace.err";fi
done;rm -f "$out/current.o";date -u +%FT%TZ > "$out/done"
