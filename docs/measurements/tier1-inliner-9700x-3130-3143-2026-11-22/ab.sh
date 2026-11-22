#!/usr/bin/env bash
# ab.sh: main, #3130, #3143 and main again (the floor) as Release znver5 builds, each from 2 fresh copies, by
# time-runs under ab, pinned to CPU 2, each time-runs process one hold of the lock: SQLite's release (-O2 --tier1)
# compile and Lua's parser, as the PRs' own local pairs ran them (one lane).
set -uo pipefail
. "$HOME/buster-fast-bench/3130-claude/env.sh"
cd "$W"
cp bin/main-release bin/harness
mkdir -p /dev/shm/claude3130-copies /dev/shm/claude3130-out
builds=(--build main bin/main-release --build pr3130 bin/3130-release --build pr3143 bin/3143-release --build main-again bin/main-release)
common=(-O2 -march=znver5 --lanes 1 -w --tier1)
sqlite=("${common[@]}" -DSQLITE_THREADSAFE=0 -DSQLITE_OMIT_LOAD_EXTENSION inputs/sqlite3.c -c -o /dev/shm/claude3130-out/sqlite.o)
lua=("${common[@]}" -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX inputs/lua/lparser.c -c -o /dev/shm/claude3130-out/lparser.o)
rounds=${1:-6}
log=logs/ab-$(date -u +%H%M%S).log
echo "$log"
bin/harness ab --rounds "$rounds" --cpu 2 --lock "$W/lockwrap.sh" bin/harness \
    -- time-runs --runs 3 --copies 2 --directory /dev/shm/claude3130-copies "${builds[@]}" --list "${sqlite[@]}" \
    -- time-runs --runs 15 --copies 2 --directory /dev/shm/claude3130-copies "${builds[@]}" --list "${lua[@]}" > "$log" 2>&1
echo "ab exit $?" >> "$log"
