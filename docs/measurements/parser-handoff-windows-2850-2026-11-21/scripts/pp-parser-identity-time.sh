#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window";root=$PWD
until [[ -f results/identity/.built ]];do sleep 2;done
source ./corpora.sh
base=$HOME/buster-fast-bench/2850-codex-step2/trees/chainprbase6e9
mkdir -p identity-time;out=$root/identity-time
exec 9>"$HOME/buster-fast-bench/2850-codex-step2/our-timing.lock"
labels=(before off on)
for round in {0..5}; do
 flock -x 9
 for corpus in sqlite lua musl main;do
  case $corpus in
   sqlite) eval "args=($sqlite_arguments)";;
   lua) args=("$lua/lvm.c");;
   main) args=(-march=znver5 -Isrc -fwrapv -funsigned-char --predefines "$root/oracle/predefines.h" src/buster/compiler/main.c);;
   musl) eval "raw=($musl_arguments)";args=();for a in "${raw[@]}";do [[ $a == *.c ]] && break;args+=("$a");done;args+=("$musl/src/stdio/vfprintf.c");;
  esac
  for pos in 0 1 2;do
   k=$(((round+pos)%3));if ((round>=3));then k=$((2-k));fi
   tag=${labels[$k]};p="$out/$round-$corpus-$pos-$tag";cc="$root/results/identity/compiler";policy=(env -u BUSTER_TEST_PARSE_IDENTITY -u BUSTER_TEST_PARSE_SOURCE_POISON);[[ $tag != on ]] || policy+=(BUSTER_TEST_PARSE_IDENTITY=1);[[ $tag != before ]] || cc="$root/baseline/compiler"
   ln -sfn "$cc" "$out/cc"
   (cd "$base" && "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 "$@" >"$p.kernels" 2>"$p.kernels.err"' _ "$p" "${policy[@]}" BUSTER_HUGE_PAGES=1 "$out/cc" benchmark-parser --passes 7 "${args[@]}" >"$p.kernel.lock" 2>&1)
   (cd "$base" && "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 perf stat -x ";" --no-big-num -e cycles:u,instructions:u,minor-faults,cpu-migrations -o "$p.perf" -- "$@" >"$p.out" 2>"$p.stages"' _ "$p" "${policy[@]}" BUSTER_HUGE_PAGES=1 "$out/cc" --time-stages -c -o "$out/current.o" "${args[@]}" >"$p.stage.lock" 2>&1)
   (cd "$base" && "$root/lock.sh" taskset -c 2 env -u BUSTER_HUGE_PAGES "${policy[@]}" "$root/baseline/compiler" time-runs --runs 2 --warmups 1 --executable "$out/cc" --list -c -o "$out/current.o" "${args[@]}" >"$p.wall" 2>"$p.wall.err")
   sha256sum "$out/current.o" | cut -d' ' -f1 >"$p.sha256";echo "$round $corpus $pos $tag" >>"$out/status"
  done
 done
 flock -u 9
done
rm -f "$out/current.o";date -u +%FT%TZ >"$out/done"
