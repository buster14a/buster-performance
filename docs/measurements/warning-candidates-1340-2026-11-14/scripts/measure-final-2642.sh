#!/usr/bin/env bash
set -euo pipefail
cd "$HOME/buster-fast-bench/1340-codex-2642"
mkdir -p measure-final
EXCLUSIVE_OWNER=codex-2642 EXCLUSIVE_TITLE="PR 2642 paired SQLite measurement" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2642 \
  "$HOME/buster-fast-bench/exclusive.sh" timeout -k 5 180 bash -c '
set -euo pipefail
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
printf "start "; date -Is
cat /proc/loadavg
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -12
sha256sum base/build/compiler head/build/compiler "$C/sqlite/sqlite3.c"
args=(-c --lanes 1 --predefines "$C/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include" -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$C/sqlite" "$C/sqlite/sqlite3.c" --time-stages)
for round in {0..30}; do
  if ((round % 2)); then versions=(head base); else versions=(base head); fi
  for version in "${versions[@]}"; do
    for mode in default off extra; do
      extra=(); [[ "$mode" == off ]] && extra=(-w); [[ "$mode" == extra ]] && extra=(-Wall -Wextra)
      taskset -c 2 "$version/build/compiler" "${args[@]}" "${extra[@]}" -o "measure-final/$version-$mode-$round.o" >"measure-final/$version-$mode-$round.stdout" 2>"measure-final/$version-$mode-$round.stderr"
      sha256sum "measure-final/$version-$mode-$round.o" >> measure-final/object-hashes.txt
    done
  done
done
printf "end "; date -Is
cat /proc/loadavg
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -12
' >measure-final/hold.log 2>&1
echo success > measure-final/result
