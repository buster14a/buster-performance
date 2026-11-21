#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window";root=$PWD;source ./corpora.sh
until [[ -e results/digitcompact/.built && -e digit-compact-check/done && -e digit-compact-diag/done ]];do sleep 2;done
base="$HOME/buster-fast-bench/2850-codex-step2/trees/chainprbase6e9";basecc="$root/results/before/compiler"
out=$root/digit-compact-time;mkdir -p "$out";exec 9>"$HOME/buster-fast-bench/2850-codex-step2/our-timing.lock"
labels=(before off writer read compact-only compact)
for r in {0..5};do
 for corpus in sqlite lua musl main;do
  flock -x 9
  case $corpus in
   sqlite) eval "args=($sqlite_arguments)";;
   lua) args=("$lua/lvm.c");;
   musl) eval "raw=($musl_arguments)";args=();for a in "${raw[@]}";do [[ $a == *.c ]] && break;args+=("$a");done;args+=("$musl/src/stdio/vfprintf.c");;
   main) args=(-march=znver5 -Isrc -fwrapv -funsigned-char --predefines "$root/oracle/predefines.h" src/buster/compiler/main.c);;
  esac
  for pos in {0..5};do
   tag=${labels[$(((r+pos)%6))]};if ((r%2));then tag=${labels[$((5-(r+pos)%6))]};fi;p=$out/$r-$corpus-$pos-$tag;cc=$root/results/digitcompact/compiler
   [[ $tag != before ]] || cc=$basecc
   opt=(env -u BUSTER_TEST_SMALL_DECIMAL_REPORT BUSTER_TEST_SMALL_DECIMAL="$tag")
   (cd "$base" && "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 perf stat -x ";" --no-big-num -e cycles:u,cycles:k,instructions:u,minor-faults,cpu-migrations -o "$p.perf" -- "$@" >"$p.out" 2>"$p.stages"' _ "$p" "${opt[@]}" BUSTER_HUGE_PAGES=1 "$cc" --time-stages -c -o "$out/current.o" "${args[@]}" >"$p.stages.lock" 2>&1)
   (cd "$base" && "$root/lock.sh" taskset -c 2 env -u BUSTER_HUGE_PAGES "${opt[@]}" "$root/baseline/compiler" time-runs --runs 2 --warmups 1 --executable "$cc" --list -c -o "$out/current.o" "${args[@]}" >"$p.wall" 2>"$p.wall.err")
   sha256sum "$out/current.o" | cut -d' ' -f1 >"$p.sha256";echo "$r $corpus $pos $tag" >>"$out/status"
  done
  flock -u 9
 done
done
rm -f "$out/current.o";date -u +%FT%TZ >"$out/done"
