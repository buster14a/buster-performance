#!/usr/bin/env bash
# ab.sh ROUNDS: main and the PR (both Release znver5 builds with -DBUSTER_TIER1_PRIVATE_VALUES=1, inert on main) and
# main again (the floor), each from 2 fresh copies, by time-runs under ab, each time-runs process one hold of the lock:
# --tier1 -c of the Zen 4 record's three inputs (SQLite's amalgamation, Lua's 34 units, musl's 1,336 units), each one
# compiler process, with its flags and environment, on one core (CPU 2) and on six (CPUs 2 to 7, --lanes 6).
set -uo pipefail
. "$HOME/buster-fast-bench/3067-claude/env.sh"
cd "$W"
rounds=${1:-6}
cp bin/main-on-release bin/harness
out=/dev/shm/claude3067-out
mkdir -p /dev/shm/claude3067-copies "$out"
builds=(--build main "$W/bin/main-on-release" --build pr "$W/bin/on-release" --build main-again "$W/bin/main-on-release")
sys=(-nostdinc -isystem "$CORPUS/headers/usr/lib/clang/23/include" -isystem "$CORPUS/headers/usr/local/include" -isystem "$CORPUS/headers/usr/include")
m="$CORPUS/libc/musl"; g="$CORPUS/musl-generated/obj"
sqlite=(-std=gnu17 "${sys[@]}")
lua=(-std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX "${sys[@]}")
musl=(-std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 "-I$m/arch/x86_64" "-I$m/arch/generic" "-I$g/src/internal" "-I$m/src/include" "-I$m/src/internal" "-I$g/include" "-I$m/include")
mapfile -t sqlite_files < inputs/sqlite.files
mapfile -t lua_files < inputs/lua.files
mapfile -t musl_files < inputs/musl.files
export LC_ALL=C SOURCE_DATE_EPOCH=1700000000 BUSTER_EXIT_HELPER=0 BUSTER_HUGE_PAGES=1 BUSTER_TEST_HOST_BUSY=0
stamp=$(date -u +%H%M%S)
for cores in 1 6; do
    if [ "$cores" = 1 ]; then cpus=2; pin=(--cpu 2); wrap="$W/lockwrap.sh"; else cpus=2,3,4,5,6,7; pin=(); wrap="$W/lockwrap6.sh"; fi
    lanes=(--lanes "$cores" --lane-cpus "$cpus" --tier1 -c)
    log="$W/logs/ab-$cores-$stamp.log"
    echo "$log"
    (cd "$out" && "$W/bin/harness" ab --rounds "$rounds" "${pin[@]}" --lock "$wrap" "$W/bin/harness" \
        -- time-runs --runs 3 --copies 2 --directory /dev/shm/claude3067-copies "${builds[@]}" --list "${lanes[@]}" "${sqlite[@]}" "${sqlite_files[@]}" \
        -- time-runs --runs 6 --copies 2 --directory /dev/shm/claude3067-copies "${builds[@]}" --list "${lanes[@]}" "${lua[@]}" "${lua_files[@]}" \
        -- time-runs --runs 3 --copies 2 --directory /dev/shm/claude3067-copies "${builds[@]}" --list "${lanes[@]}" "${musl[@]}" "${musl_files[@]}") > "$log" 2>&1
    echo "ab exit $?" >> "$log"
    ls "$out" | grep -c '\.o$' >> "$log"
done
touch ab.done
