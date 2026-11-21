#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window";root=$PWD;source ./corpora.sh
until [[ -f results/digit1/.built ]];do sleep 1;done
out=$root/digit-check;mkdir -p "$out";src=$HOME/buster-fast-bench/2850-codex-step2/trees/chainprbase6e9
cat >"$out/fixture.c" <<'C'
int f(int x) { int q = x + 5; return q * 2 - x; }
int main(void) { return f(1) - 11; }
C
cd "$src"
for c in fixture sqlite lua musl main;do
 case $c in
  fixture) args=("$out/fixture.c");;
  sqlite) eval "args=($sqlite_arguments)";;lua) args=("$lua/lvm.c");;
  musl) eval "raw=($musl_arguments)";args=();for a in "${raw[@]}";do [[ $a == *.c ]] && break;args+=("$a");done;args+=("$musl/src/stdio/vfprintf.c");;
  main) args=(-march=znver5 -Isrc -fwrapv -funsigned-char --predefines "$root/oracle/predefines.h" src/buster/compiler/main.c);;
 esac
 for op in default wall;do
  opts=();[[ $op != wall ]] || opts=(-Wall -Wextra)
  if [[ -e "$out/$c-$op-complete" || $c == fixture && -f "$out/sqlite-default-fault.sha256" ]];then continue;fi
  for mode in before off writer read fault;do
   if [[ $mode == fault && ( $op != default || ( $c != fixture && $c != sqlite ) ) ]];then continue;fi
   exe=$root/results/digit1/compiler; [[ $mode != before ]] || exe=$root/results/before/compiler
   p=$out/$c-$op-$mode;st=0
   "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 "$@" >"$p.stdout" 2>"$p.stderr"' _ "$p" env BUSTER_TEST_SMALL_DECIMAL="$mode" BUSTER_TEST_SMALL_DECIMAL_REPORT=1 "$exe" "${opts[@]}" -c -o "$p.o" "${args[@]}" >"$p.lock" 2>&1 || st=$?
   echo "$st" >"$p.status";test "$st" = 0;sha256sum "$p.o" >"$p.sha256"
   sed -E '/^pp-(digits|digit-consumed):/d' "$p.stderr" >"$p.diag"
   if [[ $mode == off || $mode == writer || $mode == read ]];then cmp "$out/$c-$op-before.o" "$p.o";cmp "$out/$c-$op-before.diag" "$p.diag";fi
   if [[ $mode == fault ]];then
    if cmp -s "$out/$c-$op-before.o" "$p.o";then echo same >"$p.fault-result";[[ $c != fixture ]];else echo changed >"$p.fault-result";fi
   fi
   if [[ $c == fixture && $op == default ]];then
    "$root/lock.sh" taskset -c 2 gcc "$p.o" -o "$p.exe" >"$p.link" 2>&1
    st=0;"$root/lock.sh" taskset -c 2 "$p.exe" >"$p.run" 2>&1 || st=$?; echo "$st" >"$p.exit";rm -f "$p.exe"
    if [[ $mode == fault ]];then test "$st" != 0;else test "$st" = 0;fi
   fi
   echo "$c $op $mode" >>"$out/status"
  done
  rm -f "$out/$c-$op"-*.o;touch "$out/$c-$op-complete"
 done
done
date -u +%FT%TZ >"$out/done"
