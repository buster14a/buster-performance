#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/3211-active-refinement"
tag=$1
until test -f "results/$tag/.built"; do sleep 3; done
out="$PWD/rejected-$tag"; mkdir -p "$out"; python fixtures-raw.py fixtures-extra; python fixtures-rejected.py fixtures-extra
for c in skipped-notes skipped-unfinished skipped-raw quoted-hidden locations; do
 for mode in E syntax object; do
  case $mode in E) opts=(-E);; syntax) opts=(-fsyntax-only -Wall -Wextra);; object) opts=(-c -o "$out/current.o");; esac
  for v in 0 1; do
   d="$out/$c-$mode-$v"
   rm -f "$out/current.o"; st=0
   ./lock.sh bash -c 'd=$1;shift; taskset -c 2 "$@" >"$d.out" 2>"$d.err"' _ "$d" env BUSTER_TEST_ACTIVE_REFINEMENT=$v BUSTER_TEST_ACTIVE_REFINEMENT_COUNTS=1 "$PWD/results/$tag/compiler" "${opts[@]}" -std=gnu17 -Wc23-extensions -Ifixtures-extra "$PWD/fixtures-extra/$c.c" >"$d.lock" 2>&1 || st=$?
   echo "$st" > "$d.status"
   if test -f "$out/current.o"; then sha256sum "$out/current.o" | cut -d' ' -f1 > "$d.object-sha"; fi
   sha256sum "$d.out" | cut -d' ' -f1 >"$d.stdout-sha"
   grep '^active-refinement ' "$d.err" >"$d.counts" || :
   sed '/^active-refinement /d' "$d.err" >"$d.diag"
  done
  diff=0
  for k in status object-sha stdout-sha diag; do
   a="$out/$c-$mode-0.$k"; b="$out/$c-$mode-1.$k"; if test -f "$a" || test -f "$b"; then cmp -s "$a" "$b" || diff=1; fi
  done
  echo "$c $mode $(cat "$out/$c-$mode-0.status") $(cat "$out/$c-$mode-1.status") $diff" >>"$out/results"
  if [[ $diff == 0 ]]; then rm -f "$out/$c-$mode-0.out" "$out/$c-$mode-1.out"; fi
 done
done
date -u +%FT%TZ > "$out/done"
