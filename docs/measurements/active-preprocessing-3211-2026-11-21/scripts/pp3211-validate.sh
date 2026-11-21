#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/3211-active-refinement"
label=${1:-pilot2}
until test -f "results/$label/.built"; do sleep 3; done
root=$PWD
cc=$root/results/$label/compiler
out=$root/check-$label
mkdir -p "$out" fixtures
python3 fixtures.py fixtures
source ./corpora.sh
eval "sql=($sqlite_arguments)"
feature=(-DSQLITE_ENABLE_FTS5 -DSQLITE_ENABLE_FTS3 -DSQLITE_ENABLE_SESSION -DSQLITE_ENABLE_PREUPDATE_HOOK -DSQLITE_ENABLE_GEOPOLY -DSQLITE_ENABLE_DBSTAT_VTAB)
for c in sqlite features shell all-active off on reject unfinished macro-args; do
 case $c in
 sqlite) args=("${sql[@]}");;
 features) args=("${feature[@]}" "${sql[@]}");;
 shell) args=("-I$sqlite" "$sqlite/shell.c");;
 *) args=(-std=gnu17 -trigraphs -fraw-string-literals -Ifixtures "$root/fixtures/$c.c");;
 esac
 for mode in E E-comments E-macro-comments syntax object; do
  case $mode in
   E) opts=(-E);;
   E-comments) opts=(-E -C);;
   E-macro-comments) opts=(-E -CC);;
   syntax) opts=(-fsyntax-only -Wall -Wextra);;
   object) opts=(-c -o "$out/current.o");;
  esac
  for cfg in 0 1; do
    dst=$out/$c-$mode-$cfg; rm -f "$out/current.o"
    status=0
    "$root/lock.sh" bash -c 'p=$1;shift; exec taskset -c 2 "$@" >"$p.out" 2>"$p.err"' _ "$dst" env BUSTER_TEST_ACTIVE_REFINEMENT=$cfg BUSTER_TEST_ACTIVE_REFINEMENT_COUNTS=1 "$cc" "${opts[@]}" "${args[@]}" > "$dst.lock" 2>&1 || status=$?
    echo "$status" >"$dst.status"
    grep '^active-refinement ' "$dst.err" >"$dst.counts" || true
    sed '/^active-refinement /d' "$dst.err" >"$dst.diag"
    sha256sum "$dst.out" | cut -d' ' -f1 >"$dst.stdout-sha"
    if test -f "$out/current.o"; then sha256sum "$out/current.o" | cut -d' ' -f1 >"$dst.object-sha"; fi
  done
  mismatch=0
  for key in status stdout-sha diag object-sha; do
    a="$out/$c-$mode-0.$key"; b="$out/$c-$mode-1.$key"; if test -f "$a" || test -f "$b"; then cmp -s "$a" "$b" || mismatch=1; fi
  done
  echo "$c $mode $(cat "$out/$c-$mode-0.status") $(cat "$out/$c-$mode-1.status") $mismatch" | tee -a "$out/results"
  if [[ $mismatch == 1 && $c == sqlite && $mode == E ]]; then break 2; fi
  rm -f "$out/$c-$mode-0.out" "$out/$c-$mode-1.out"
 done
done
date -u +%FT%TZ > "$out/done"
