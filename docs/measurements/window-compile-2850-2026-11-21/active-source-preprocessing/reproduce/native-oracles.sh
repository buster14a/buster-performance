#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
root=$PWD;out=$root/results/active-source-native-oracles;mkdir -p "$out"
source corpora.sh;eval "args=($sqlite_arguments)"
./lock.sh taskset -c 2 bash -c '
 set -e
 root=$1;out=$2;inc=$3;shift 3
 export PATH="$(bash trees/factsmain0e1d/tools/ci/session-toolchain.sh stage):$PATH"
 clang -c "$@" -o "$out/clang.o" 2>"$out/clang.err"
 clang -I"$inc" -c active-source-sqlite-driver.c -o "$out/driver.o"
 for pair in eager direct;do
  case $pair in eager) compiler=$root/results/factsmain0e1d/compiler;;direct) compiler=$root/results/activesourced03/compiler;;esac
  for features in basic extended;do
   flags=();if [[ $features == extended ]];then flags=(-DSQLITE_ENABLE_FTS5 -DSQLITE_ENABLE_FTS3 -DSQLITE_ENABLE_SESSION -DSQLITE_ENABLE_PREUPDATE_HOOK -DSQLITE_ENABLE_GEOPOLY -DSQLITE_ENABLE_DBSTAT_VTAB);fi
   for policy in default max;do
    diagnostic=();if [[ $policy == max ]];then diagnostic=(-Weverything);fi
    f=$out/$pair-$features-$policy
    "$compiler" -c "${flags[@]}" "${diagnostic[@]}" "$@" -o "$f.o" >"$f.out" 2>"$f.err"
   done
  done
 done
 for f in basic-default basic-max extended-default extended-max;do for kind in o out err;do cmp "$out/eager-$f.$kind" "$out/direct-$f.$kind";done;done
 for arm in clang eager direct;do
  case $arm in clang) o=$out/clang.o;;*) o=$out/$arm-basic-default.o;;esac
  clang -no-pie "$out/driver.o" "$o" -lm -ldl -lpthread -o "$out/$arm-run"
  "$out/$arm-run" >"$out/$arm.sql" 2>"$out/$arm.sqlerr"
  cmp "$out/clang.sql" "$out/$arm.sql";cmp "$out/clang.sqlerr" "$out/$arm.sqlerr"
 done
 cd "$out";sha256sum *.o *.sql *.sqlerr *.err *.out >hashes.tsv
' _ "$root" "$out" "$sqlite" "${args[@]}" >"$out/lease.log" 2>&1
