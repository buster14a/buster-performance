#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window";root=$PWD
source ./corpora.sh
base=$HOME/buster-fast-bench/2850-codex-step2/trees/chainprbase6e9
mkdir -p bracket-corpora;out=$root/bracket-corpora
exec 9>"$HOME/buster-fast-bench/2850-codex-step2/our-timing.lock"
for round in {0..4};do
 flock -x 9
 order=(before bracket);if ((round%2==1));then order=(bracket before);fi
 for corpus in lua musl main;do
  case $corpus in
   lua) args=("$lua/lvm.c");;
   main) args=(-march=znver5 -Isrc -fwrapv -funsigned-char --predefines "$root/oracle/predefines.h" src/buster/compiler/main.c);;
   musl) eval "raw=($musl_arguments)";args=();for a in "${raw[@]}";do [[ $a == *.c ]] && break;args+=("$a");done;args+=("$musl/src/stdio/vfprintf.c");;
  esac
  for pos in 0 1;do
   tag=${order[$pos]};p="$out/$round-$corpus-$pos-$tag";cc="$root/results/$tag/compiler"
   (cd "$base" && "$root/lock.sh" bash -c 'p=$1;shift;exec env BUSTER_HUGE_PAGES=1 taskset -c 2 "$@" >"$p.kernels" 2>"$p.kernels.err"' _ "$p" "$cc" benchmark-parser --passes 7 "${args[@]}" >"$p.kernel.lock" 2>&1)
   (cd "$base" && "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 "$@" >"$p.out" 2>"$p.stages"' _ "$p" env BUSTER_HUGE_PAGES=1 "$cc" --time-stages -c -o "$out/current.o" "${args[@]}" >"$p.stage.lock" 2>&1)
   (cd "$base" && "$root/lock.sh" taskset -c 2 env -u BUSTER_HUGE_PAGES "$root/baseline/compiler" time-runs --runs 2 --warmups 1 --executable "$cc" --list -c -o "$out/current.o" "${args[@]}" >"$p.wall" 2>"$p.wall.err")
   sha256sum "$out/current.o" | cut -d' ' -f1 >"$p.sha256";echo "$round $corpus $pos $tag" >>"$out/status"
  done
 done
 flock -u 9
done
rm -f "$out/current.o";date -u +%FT%TZ >"$out/done"
