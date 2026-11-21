#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window";root=$PWD;source ./corpora.sh
baseline=$HOME/buster-fast-bench/2850-codex-step2/trees/chainprbase6e9
out=$root/location-safe-time; mkdir -p "$out"
until [[ -e location-oracle/built && -e results/locsafe/.built ]];do sleep 2;done
exec 9>"$HOME/buster-fast-bench/2850-codex-step2/our-timing.lock"
labels=(before off record restore view)
for r in {0..4};do
 flock -x 9
 for c in sqlite lua musl main;do
  case $c in
   sqlite) eval "args=($sqlite_arguments)";;
   lua) args=("$lua/lvm.c");;
   musl) eval "raw=($musl_arguments)"; args=();for a in "${raw[@]}";do [[ $a == *.c ]] && break;args+=("$a");done;args+=("$musl/src/stdio/vfprintf.c");;
   main) args=(-march=znver5 -Isrc -fwrapv -funsigned-char --predefines "$root/oracle/predefines.h" src/buster/compiler/main.c);;
  esac
  file=${args[-1]};opts=("${args[@]:0:${#args[@]}-1}")
  for pos in {0..4};do
   mode=${labels[$(((r*2+pos)%5))]};tag=locsafe;meter=locations;[[ $mode != before ]] || { tag=before;meter=before; }
   p=$out/$r-$c-$pos-$mode;cc=$root/results/$tag/compiler
   (
    cd "$baseline"
    export BUSTER_TEST_PP_FILE_LOCATIONS=$mode
    "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 perf stat -x ";" --no-big-num -e cycles:u,cycles:k,instructions:u,minor-faults,cpu-migrations -o "$p.pp.perf" -- "$@" >"$p.pp" 2>"$p.pp.err"' _ "$p" "$root/location-oracle/$meter-meter" "${opts[@]}" -- "$file" >"$p.pp.lock" 2>&1
    "$root/lock.sh" taskset -c 2 env BUSTER_LOCATION_CONSUME=1 "$root/location-oracle/$meter-meter" "${opts[@]}" -- "$file" >"$p.consume" 2>"$p.consume.err"
    "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 perf stat -x ";" --no-big-num -e cycles:u,cycles:k,instructions:u,minor-faults,cpu-migrations -o "$p.print.perf" -- "$@" >"$p.print.stdout" 2>"$p.print.stderr"' _ "$p" "$cc" -E -P -o "$out/current.i" "${args[@]}" >"$p.print.lock" 2>&1
    sha256sum "$out/current.i" | cut -d' ' -f1 >"$p.print.sha256"
    "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 perf stat -x ";" --no-big-num -e cycles:u,cycles:k,instructions:u,minor-faults,cpu-migrations -o "$p.perf" -- "$@" >"$p.o.stdout" 2>"$p.stages"' _ "$p" env BUSTER_HUGE_PAGES=1 "$cc" --time-stages -c -o "$out/current.o" "${args[@]}" >"$p.o.lock" 2>&1
    "$root/lock.sh" taskset -c 2 env -u BUSTER_HUGE_PAGES "$root/baseline/compiler" time-runs --runs 2 --warmups 1 --executable "$cc" --list -c -o "$out/current.o" "${args[@]}" >"$p.wall" 2>"$p.wall.err"
    sha256sum "$out/current.o" | cut -d' ' -f1 >"$p.sha256"
   )
   echo "$r $c $pos $mode" >>"$out/status"
  done
 done
 flock -u 9
done
rm -f "$out/current.o" "$out/current.i";date -u +%FT%TZ >"$out/done"
