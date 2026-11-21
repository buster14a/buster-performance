#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window";root=$PWD;source ./corpora.sh
base="$HOME/buster-fast-bench/2850-codex-step2/results/constbaseb86/compiler";cand="$root/results/enumdemand/compiler";until [[ -f $root/enum-corpus/done ]];do sleep 2;done
out=$root/enum-time;mkdir -p "$out";exec 9>"$HOME/buster-fast-bench/2850-codex-step2/our-timing.lock"
cd "$HOME/buster-fast-bench/2850-codex-step2/trees/chainprbase6e9"
for r in {0..6};do
 for c in main mainwall lua sqlite musl;do
  flags=();policy=default;j=$c
  case $c in
  sqlite) eval "args=($sqlite_arguments)";;
  lua) args=("$lua/lvm.c");;
  musl) eval "raw=($musl_arguments)";args=();for a in "${raw[@]}";do [[ $a == *.c ]] && break;args+=("$a");done;args+=("$musl/src/stdio/vfprintf.c");;
  main|mainwall) args=(-march=znver5 -Isrc -fwrapv -funsigned-char --predefines "$root/oracle/predefines.h" src/buster/compiler/main.c);j=main;if [[ $c == mainwall ]];then flags=(-Wall);policy=wall;fi;;
  esac
  arms=(base cand);if ((r%2));then arms=(cand base);fi;flock -x 9
  for pos in 0 1;do tag=${arms[$pos]};cc=${!tag};p="$out/$r-$c-$pos-$tag"
   "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 perf stat -x ";" --no-big-num -e cycles:u,cycles:k,instructions:u,minor-faults,cpu-migrations -o "$p.perf" -- "$@" >"$p.out" 2>"$p.stages"' _ "$p" env BUSTER_HUGE_PAGES=1 "$cc" --time-stages "${flags[@]}" -c -o "$out/current.o" "${args[@]}" >"$p.stages.lock" 2>&1
   "$root/lock.sh" taskset -c 2 env -u BUSTER_HUGE_PAGES "$root/baseline/compiler" time-runs --runs 2 --warmups 1 --executable "$cc" --list "${flags[@]}" -c -o "$out/current.o" "${args[@]}" >"$p.wall" 2>"$p.wall.err"
   sha256sum "$out/current.o" | cut -d' ' -f1 >"$p.sha256";cmp "$p.sha256" "$root/first-history-enum-parent/$j-$policy.sha256";echo "$r $c $pos $tag" >>"$out/status"
  done
  flock -u 9
 done
done;rm "$out/current.o";date -u +%FT%TZ >"$out/done"
