#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window";root=$PWD;source ./corpora.sh
until [[ -f macrobank-probes/done ]];do sleep 2;done
out=$root/macrobank-time;mkdir -p "$out";exec 9>"$HOME/buster-fast-bench/2850-codex-step2/our-timing.lock"
cd "$HOME/buster-fast-bench/2850-codex-step2/trees/chainprbase6e9"
for r in {0..5};do for c in sqlite main lua musl;do
 case $c in
 sqlite) eval "args=($sqlite_arguments)";;
 main) args=(-march=znver5 -Isrc -fwrapv -funsigned-char --predefines "$root/oracle/predefines.h" src/buster/compiler/main.c);;
 lua)args=("$lua/lvm.c");;
 musl)eval "raw=($musl_arguments)";args=();for a in "${raw[@]}";do [[ $a == *.c ]] && break;args+=("$a");done;args+=("$musl/src/stdio/vfprintf.c");;
 esac
 f=${args[-1]};opts=("${args[@]:0:${#args[@]}-1}")
 case $r in 0) arms=(parent off on);;1) arms=(off on parent);;2) arms=(on parent off);;
 3) arms=(on off parent);;4) arms=(parent on off);;5) arms=(off parent on);;esac
 flock -x 9
 for pos in 0 1 2;do arm=${arms[$pos]};cc=$root/results/macrobank/compiler;meter=$root/macrobank-probes/bank-meter;mode=0
 [[ $arm != parent ]] || { cc=$root/results/enumqueuebase/compiler;meter=$root/macrobank-probes/parent-meter; };[[ $arm != on ]] || mode=1
 p="$out/$r-$c-$pos-$arm"
 "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 perf stat -x ";" --no-big-num -e cycles:u,cycles:k,instructions:u,minor-faults,cpu-migrations -o "$p.rawperf" -- "$@" >"$p.front" 2>"$p.raw.err"' _ "$p" env BUSTER_TEST_PP_FILE_MACRO_BANK="$mode" "$meter" "${opts[@]}" -- "$f" >"$p.raw.lock" 2>&1
 "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 perf stat -x ";" --no-big-num -e cycles:u,cycles:k,instructions:u,minor-faults,cpu-migrations -o "$p.perf" -- "$@" >"$p.out" 2>"$p.stages"' _ "$p" env BUSTER_TEST_PP_FILE_MACRO_BANK="$mode" BUSTER_HUGE_PAGES=1 "$cc" --time-stages -c -o "$out/current.o" "${args[@]}" >"$p.stages.lock" 2>&1
 "$root/lock.sh" taskset -c 2 env -u BUSTER_HUGE_PAGES BUSTER_TEST_PP_FILE_MACRO_BANK="$mode" "$root/baseline/compiler" time-runs --runs 2 --warmups 1 --executable "$cc" --list -c -o "$out/current.o" "${args[@]}" >"$p.wall" 2>"$p.wall.err"
 sha256sum "$out/current.o" |cut -d' ' -f1 >"$p.sha256";cmp "$p.sha256" "$root/first-history-enum-queue-parent/$c-default.sha256"
 echo "$r $c $pos $arm" >>"$out/status"
 done;flock -u 9
done;done; rm "$out/current.o";date -u +%FT%TZ > "$out/done"
