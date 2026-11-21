#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window";root=$PWD;source ./corpora.sh
until [[ -f results/digits8replay/.built && -f digits8-guard/done && -f digits8-check/done ]];do sleep 2;done
out=$root/digits8-replay;mkdir -p "$out";exec 9>"$HOME/buster-fast-bench/2850-codex-step2/our-timing.lock"
cc=$root/results/digits8replay/compiler;cd "$HOME/buster-fast-bench/2850-codex-step2/trees/chainprbase6e9"
labels=(old new paired)
for r in {0..5};do
 for c in sqlite lua musl main;do
  case $c in
   sqlite) eval "args=($sqlite_arguments)";; lua) args=("$lua/lvm.c");;
   musl) eval "raw=($musl_arguments)";args=();for a in "${raw[@]}";do [[ $a == *.c ]] && break;args+=("$a");done;args+=("$musl/src/stdio/vfprintf.c");;
   main) args=(-march=znver5 -Isrc -fwrapv -funsigned-char --predefines "$root/oracle/predefines.h" src/buster/compiler/main.c);;
  esac
  flock -x 9
  for pos in {0..2};do
   tag=${labels[$(((pos+r)%3))]};if ((r>2));then tag=${labels[$((2-(pos+r)%3))]};fi;p="$out/$r-$c-$pos-$tag"
   "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 perf stat -x ";" --no-big-num -e cycles:u,cycles:k,instructions:u,minor-faults,cpu-migrations -o "$p.perf" -- "$@" >"$p.out" 2>"$p.err"' _ "$p" env BUSTER_HUGE_PAGES=1 BUSTER_TEST_DECIMAL_EIGHT_REPLAY="$tag" "$cc" -c -o "$out/current.o" "${args[@]}" >"$p.lock" 2>&1
   hash=$(sha256sum "$out/current.o" | cut -d' ' -f1); expected=$(cut -d' ' -f1 "$root/digits8-check/$c-default-before.sha256");test "$hash" = "$expected"
   echo "$hash" >"$p.sha256";echo "$r $c $pos $tag" >>"$out/status"
  done
  flock -u 9
 done
done
rm -f "$out/current.o";date -u +%FT%TZ >"$out/done"
