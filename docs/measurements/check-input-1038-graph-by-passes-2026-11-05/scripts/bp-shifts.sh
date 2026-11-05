#!/bin/bash
# Usage: bp-shifts.sh OUT -- base and head at six placements of the checker's unit, three fresh copies each, rotated (#509)
out="$1"
mkdir -p "$out"
export EXCLUSIVE_OWNER=claude-1038 EXCLUSIVE_TITLE="GitHub issue #1038" EXCLUSIVE_LINK=https://claude.ai/code/session_01TiDLnvzc6A3cz2qD5dSRLw
root=~/buster-fast-bench/1038-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
shifts="0 640 1344 2048 2752 3456"
rm -rf "$out/shifts"
for tree in base head; do
  (cd "$root/$tree" && BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh shifts "$out/shifts/$tree" main_unit_checker.c $shifts) > "$out/shifts-$tree.log" 2>&1 || { echo "shifts $tree failed" > "$out/done"; exit 1; }
done
builds=()
for b in base:base head:head base-again:base; do
  for s in $shifts; do builds+=(--build "${b%%:*}" "$out/shifts/${b#*:}/compiler-$s"); done
done
"$root/base/build/compiler" ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "$root/base/build/compiler" \
  -- time-runs --runs 3 --copies 3 "${builds[@]}" --list "${options[@]}" -o "$out/shifts.o" > "$out/shifts.txt" 2>&1
echo done > "$out/done"
