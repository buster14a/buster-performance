#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window";root=$PWD;source ./corpora.sh
until [[ -e results/ppdecode/.built && -e decode-check/done ]];do sleep 2;done
base="$HOME/buster-fast-bench/2850-codex-step2/trees/sourcebb8";basecc="$HOME/buster-fast-bench/2850-codex-step2/results/sourcebb8/compiler"
out=$root/decode-time;mkdir -p "$out";exec 9>"$HOME/buster-fast-bench/2850-codex-step2/our-timing.lock"
labels=(before off writer physical decode)
for r in {0..4};do
 flock -x 9
 for corpus in sqlite lua musl main;do
  case $corpus in
   sqlite) eval "args=($sqlite_arguments)";;
   lua) args=("$lua/lvm.c");;
   musl) eval "raw=($musl_arguments)";args=();for a in "${raw[@]}";do [[ $a == *.c ]] && break;args+=("$a");done;args+=("$musl/src/stdio/vfprintf.c");;
   main) args=(-march=znver5 -Isrc -fwrapv -funsigned-char --predefines "$root/oracle/predefines.h" src/buster/compiler/main.c);;
  esac
  for pos in {0..4};do
   tag=${labels[$(((r*2+pos)%5))]};p=$out/$r-$corpus-$pos-$tag;cc=$root/results/ppdecode/compiler;pp=off;use=off
   opt=(env -u BUSTER_TEST_PP_RETURN_DECODE -u BUSTER_TEST_PP_RETURN_REPORT -u NODE_SOURCE_NATIVE_ORACLE -u NODE_SOURCE_COMPACT_REPORT -u NODE_SPLICE_REPORT)
   case $tag in before)cc=$basecc;;writer)pp=stream;;physical)pp=stream;use=publish;;decode)pp=stream;opt+=(BUSTER_TEST_PP_RETURN_DECODE=on);;esac
   opt+=(BUSTER_TEST_PP_RETURN_USE="$use" BUSTER_TEST_PP_RETURN_WINDOW="$pp")
   (cd "$base" && "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 perf stat -x ";" --no-big-num -e cycles:u,cycles:k,instructions:u,minor-faults,cpu-migrations -o "$p.perf" -- "$@" >"$p.out" 2>"$p.stages"' _ "$p" "${opt[@]}" BUSTER_HUGE_PAGES=1 "$cc" --time-stages --node-window-source --lanes 1 -c -o "$out/current.o" "${args[@]}" >"$p.stages.lock" 2>&1)
   (cd "$base" && "$root/lock.sh" taskset -c 2 env -u BUSTER_HUGE_PAGES "${opt[@]}" "$root/baseline/compiler" time-runs --runs 2 --warmups 1 --executable "$cc" --list --node-window-source --lanes 1 -c -o "$out/current.o" "${args[@]}" >"$p.wall" 2>"$p.wall.err")
   sha256sum "$out/current.o" | cut -d' ' -f1 >"$p.sha256";echo "$r $corpus $pos $tag" >>"$out/status"
  done
 done
 flock -u 9
done
rm -f "$out/current.o";date -u +%FT%TZ >"$out/done"
