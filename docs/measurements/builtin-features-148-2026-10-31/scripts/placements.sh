#!/usr/bin/env bash
# The builtins' target features (buster #148, #775): #509's comparison over placements and copies. Each tree is built
# with its checker's unit shifted by six offsets spread over a page (./build.sh shifts), each build in a hold of the lock
# of its own; then ab runs time-runs for 3 rounds, each process in a hold of its own: every placement of base, head and
# base again (the comparison's floor) from 3 fresh copies, 3 runs, -c of the frozen sqlite3.c and of stb_image.
set -uo pipefail
dir="$HOME/buster-fast-bench/builtin-features-148-claude"
cd "$dir" || exit 1
export EXCLUSIVE_OWNER=claude-builtin-features-148 EXCLUSIVE_TITLE="#148/#775 builtins' required target features: placements" \
    EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/775#issuecomment-6541522441
shifts="0 688 1376 2064 2752 3440"
for tree in base head; do
    (cd "$tree" && BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh shifts "$dir/shifts/$tree" main_unit_checker.c $shifts) > "shifts-$tree.log" 2> "shifts-$tree.stderr"
    echo "shifts $tree status $?" >> "shifts-$tree.log"
    sha256sum "$dir/shifts/$tree"/compiler-* >> "shifts-$tree.log"
done
builds=()
for b in base:base head:head base-again:base; do
    for s in $shifts; do builds+=(--build "${b%%:*}" "$dir/shifts/${b#*:}/compiler-$s"); done
done
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
./head/build/compiler ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh ./head/build/compiler \
    -- time-runs --runs 3 --copies 3 "${builds[@]}" --list -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 \
    -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o "$dir/placement-sqlite.o" > placements-sqlite.log 2> placements-sqlite.stderr
echo "placements sqlite status $?" >> placements-sqlite.log
./head/build/compiler ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh ./head/build/compiler \
    -- time-runs --runs 3 --copies 3 "${builds[@]}" --list -c -march=native "-I$dir/stb" "$dir/stb/stb_image.c" -o "$dir/placement-stb.o" > placements-stb.log 2> placements-stb.stderr
echo "placements stb status $?" >> placements-stb.log
echo done > placements.done
