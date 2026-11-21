#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window";root=$PWD;source ./corpora.sh
until [[ -f grammarfinal-oracle/done ]];do sleep 2;done
meters=$root/grammarfinal-meter;mkdir -p "$meters"
clang=$(sed -n 's/.*toolchain: clang \([^ ]*\) (.*/\1/p' "$root/results/grammarfinal/build.log"|head -1)
for target in parent bank;do src=$root/trees/enumqueuebase;defs=();[[ $target != bank ]] || { src=$root/trees/grammarfinal;defs=(-DPP_GRAMMAR); }
 "$root/lock.sh" taskset -c 2 "$clang" "${defs[@]}" -std=gnu17 -march=znver5 -O3 -g0 -fwrapv -funsigned-char -I"$src/src" pp-grammar-meter.c -o "$meters/$target-meter" >"$meters/$target.build" 2>&1
done
out=$root/grammarfinal-time;mkdir -p "$out";exec 9>"$HOME/buster-fast-bench/2850-codex-step2/our-timing.lock"
cd "$HOME/buster-fast-bench/2850-codex-step2/trees/chainprbase6e9"
for r in {0..5};do for c in sqlite main lua musl;do
 case $c in
 sqlite) eval "args=($sqlite_arguments)";;
 main) args=(-march=znver5 -Isrc -fwrapv -funsigned-char --predefines "$root/oracle/predefines.h" src/buster/compiler/main.c);;
 lua)args=("$lua/lvm.c");;
 musl)eval "raw=($musl_arguments)";args=();for a in "${raw[@]}";do [[ $a == *.c ]] && break;args+=("$a");done;args+=("$musl/src/stdio/vfprintf.c");;
 esac
 f=${args[-1]};opts=("${args[@]:0:${#args[@]}-1}")
 case $r in 0) arms=(parent off write take);;1) arms=(off write take parent);;2) arms=(write take parent off);;
 3) arms=(take write off parent);;4) arms=(parent take write off);;5) arms=(off parent take write);;esac
 flock -x 9
 for pos in 0 1 2 3;do arm=${arms[$pos]};cc=$root/results/grammarfinal/compiler;meter=$meters/bank-meter;mode=0
 [[ $arm != parent ]] || { cc=$root/results/enumqueuebase/compiler;meter=$meters/parent-meter; };[[ $arm != write ]] || mode=1;[[ $arm != take ]] || mode=2
 p="$out/$r-$c-$pos-$arm"
 "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 perf stat -x ";" --no-big-num -e cycles:u,cycles:k,instructions:u,minor-faults,cpu-migrations -o "$p.rawperf" -- "$@" >"$p.front" 2>"$p.raw.err"' _ "$p" env BUSTER_TEST_PP_GRAMMAR_STREAM="$mode" "$meter" "${opts[@]}" -- "$f" >"$p.raw.lock" 2>&1
 "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 perf stat -x ";" --no-big-num -e cycles:u,cycles:k,instructions:u,minor-faults,cpu-migrations -o "$p.perf" -- "$@" >"$p.out" 2>"$p.stages"' _ "$p" env BUSTER_TEST_PP_GRAMMAR_STREAM="$mode" BUSTER_HUGE_PAGES=1 "$cc" --time-stages -c -o "$out/current.o" "${args[@]}" >"$p.stages.lock" 2>&1
 "$root/lock.sh" taskset -c 2 env -u BUSTER_HUGE_PAGES BUSTER_TEST_PP_GRAMMAR_STREAM="$mode" "$root/baseline/compiler" time-runs --runs 2 --warmups 1 --executable "$cc" --list -c -o "$out/current.o" "${args[@]}" >"$p.wall" 2>"$p.wall.err"
 sha256sum "$out/current.o" |cut -d' ' -f1 >"$p.sha256";cmp "$p.sha256" "$root/first-history-enum-queue-parent/$c-default.sha256"
 if [[ $c == sqlite && $arm == take ]];then
  "$root/lock.sh" taskset -c 2 env BUSTER_TEST_PP_GRAMMAR_STREAM=2 BUSTER_TEST_PP_GRAMMAR_CONSUME=1 "$meter" "${opts[@]}" -- "$f" >"$p.consume" 2>"$p.consume.lock"
 fi
 echo "$r $c $pos $arm" >>"$out/status"
 done;flock -u 9
done;done; rm "$out/current.o";date -u +%FT%TZ > "$out/done"
