#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/3211-active-refinement"
label=${1:-pilot2}
root=$PWD
until test -f "results/base/.built" && test -s "check-$label/results"; do sleep 3; done
if ! grep -qx 'sqlite E 0 0 0' "check-$label/results"; then echo 'The initial marker output or diagnostics disagree'; exit 1; fi
out="$root/timing-$label"
mkdir -p "$out"
source ./corpora.sh
eval "sql=($sqlite_arguments)"
features=(-DSQLITE_ENABLE_FTS5 -DSQLITE_ENABLE_FTS3 -DSQLITE_ENABLE_SESSION -DSQLITE_ENABLE_PREUPDATE_HOOK -DSQLITE_ENABLE_GEOPOLY -DSQLITE_ENABLE_DBSTAT_VTAB)
labels=(base off on)
exec 9>"$HOME/buster-fast-bench/2850-codex-step2/our-timing.lock"
for n in 0 1 2 3 4 5; do
 flock -x 9
 for c in sqlite features shell all-active; do
  case $c in sqlite) args=("${sql[@]}");; features) args=("${features[@]}" "${sql[@]}");; shell) args=("-I$sqlite" "$sqlite/shell.c");; all-active) args=(fixtures/all-active.c);; esac
  for i in 0 1 2; do
   k=$(((n+i)%3)); if ((n>=3)); then k=$((2-k)); fi
   tag=${labels[k]}; p="$out/$n-$c-$i-$tag"; ctl=0; exe="$root/results/$label/compiler"
   [[ $tag != on ]] || ctl=1; [[ $tag != base ]] || exe="$root/results/base/compiler"
   ln -sfn "$exe" "$out/cc"
   st=0
   "$root/lock.sh" env BUSTER_TEST_ACTIVE_REFINEMENT=$ctl BUSTER_HUGE_PAGES=1 taskset -c 2 perf stat -x ';' --no-big-num -e cycles:u,cycles:k,instructions:u,instructions:k,minor-faults,cpu-migrations -o "$p.stat" -- "$out/cc" --time-stages -c -o "$out/current.o" "${args[@]}" >"$p.out" 2>"$p.err" || st=$?
   echo "$n $c $i $tag $st" >>"$out/status"
   if test "$st" = 0; then sha256sum "$out/current.o" | cut -d' ' -f1 >"$p.sha"; else continue; fi
   "$root/lock.sh" env -u BUSTER_HUGE_PAGES BUSTER_TEST_ACTIVE_REFINEMENT=$ctl taskset -c 2 "$root/results/base/compiler" time-runs --runs 1 --warmups 1 --executable "$out/cc" --list -c -o "$out/current.o" "${args[@]}" >"$p.wall" 2>"$p.wall-err"
  done
 done
 flock -u 9
done
date -u +%FT%TZ >"$out/done"
