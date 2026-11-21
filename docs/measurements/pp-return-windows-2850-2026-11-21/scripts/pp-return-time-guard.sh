#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window";root=$PWD;source ./corpora.sh
until [[ -e results/returnguard/.built && -e returnguard-meter/done ]];do sleep 2;done
base=$HOME/buster-fast-bench/2850-codex-step2/trees/chainprbase6e9
out=$root/returnguard-time;mkdir -p "$out";exec 9>"$HOME/buster-fast-bench/2850-codex-step2/our-timing.lock"
labels=(before off stream replay)
for r in {0..5};do
 flock -x 9
 for corpus in sqlite lua musl main;do
  case $corpus in
   sqlite) eval "args=($sqlite_arguments)";;
   lua) args=("$lua/lvm.c");;
   musl) eval "raw=($musl_arguments)";args=();for a in "${raw[@]}";do [[ $a == *.c ]] && break;args+=("$a");done;args+=("$musl/src/stdio/vfprintf.c");;
   main) args=(-march=znver5 -Isrc -fwrapv -funsigned-char --predefines "$root/oracle/predefines.h" src/buster/compiler/main.c);;
  esac
  file=${args[-1]};opts=("${args[@]:0:${#args[@]}-1}")
  for pos in {0..3};do
   idx=$(((r+pos)%4));if ((r>=4));then idx=$((3-idx));fi
   tag=${labels[$idx]}; variant=returnguard;[[ $tag != before ]] || variant=before
   p=$out/$r-$corpus-$pos-$tag
   (cd "$base" && "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 perf stat -x ";" --no-big-num -e cycles:u,cycles:k,instructions:u,minor-faults,cpu-migrations -o "$p.perf" -- "$@" >"$p.front" 2>"$p.front.err"' _ "$p" env BUSTER_TEST_PP_RETURN_WINDOW="$tag" "$root/returnguard-meter/$variant" "${opts[@]}" -- "$file" >"$p.front.lock" 2>&1)
   cc=$root/results/$variant/compiler
   (cd "$base" && "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 "$@" >"$p.out" 2>"$p.stages"' _ "$p" env BUSTER_HUGE_PAGES=1 BUSTER_TEST_PP_RETURN_WINDOW="$tag" "$cc" --time-stages -c -o "$out/current.o" "${args[@]}" >"$p.stages.lock" 2>&1)
   (cd "$base" && "$root/lock.sh" taskset -c 2 env -u BUSTER_HUGE_PAGES BUSTER_TEST_PP_RETURN_WINDOW="$tag" "$root/baseline/compiler" time-runs --runs 2 --warmups 1 --executable "$cc" --list -c -o "$out/current.o" "${args[@]}" >"$p.wall" 2>"$p.wall.err")
   if [[ $tag == stream ]];then
    (cd "$base" && "$root/lock.sh" taskset -c 2 env BUSTER_TEST_PP_RETURN_WINDOW="$tag" BUSTER_TEST_PP_RETURN_CONSUME=1 "$root/returnguard-meter/$variant" "${opts[@]}" -- "$file" >"$p.consume" 2>"$p.consume.err")
   fi
   sha256sum "$out/current.o" | cut -d' ' -f1 >"$p.sha256";echo "$r $corpus $pos $tag" >>"$out/status"
  done
 done
 flock -u 9
done
rm -f "$out/current.o";date -u +%FT%TZ >"$out/done"
