#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window"
root=$PWD
until [[ -e results/account/.built && -e results/passes/.built ]];do sleep 2;done
source ./corpora.sh
base=$HOME/buster-fast-bench/2850-codex-step2/trees/chainprbase6e9
mkdir -p tree-driver
out=$root/tree-driver
cc=$root/results/account/compiler
prod=$root/results/passes/compiler
exec 9>"$HOME/buster-fast-bench/2850-codex-step2/our-timing.lock"
for round in {0..6}; do
 flock -x 9
 order=(0 4096 4096 0)
 if ((round%2==1));then order=(4096 0 0 4096);fi
 for corpus in sqlite lua musl main; do
  case "$corpus" in
   sqlite) eval "args=($sqlite_arguments)";;
   lua) args=("$lua/lvm.c");;
   main) args=(-march=znver5 -Isrc -fwrapv -funsigned-char --predefines "$root/oracle/predefines.h" src/buster/compiler/main.c);;
   musl) eval "raw=($musl_arguments)";args=();for a in "${raw[@]}";do [[ $a == *.c ]] && break;args+=("$a");done;args+=("$musl/src/stdio/vfprintf.c");;
  esac
  for pos in 0 1 2 3;do
   w=${order[$pos]};p="$out/$round-$corpus-$pos-$w"
   (cd "$base" && "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 "$@" >"$p.out" 2>"$p.stages"' _ "$p" env BUSTER_HUGE_PAGES=1 BUSTER_TEST_PARSE_TREE_CLOCK=1 BUSTER_TEST_PARSE_TREE_TILE="$w" "$cc" --time-stages -c -o "$out/current.o" "${args[@]}" >"$p.stage.lock" 2>&1)
   (cd "$base" && "$root/lock.sh" taskset -c 2 env -u BUSTER_HUGE_PAGES BUSTER_TEST_PARSE_TREE_TILE="$w" "$root/baseline/compiler" time-runs --runs 2 --warmups 1 --executable "$prod" --list -c -o "$out/current.o" "${args[@]}" >"$p.wall" 2>"$p.wall.err")
   sha256sum "$out/current.o" | cut -d' ' -f1 > "$p.sha256"
   echo "$round $corpus $pos $w" >> "$out/status"
  done
 done
 flock -u 9
done
rm -f "$out/current.o"
date -u +%FT%TZ >"$out/done"
