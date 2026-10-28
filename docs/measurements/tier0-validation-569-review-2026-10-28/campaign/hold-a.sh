#!/usr/bin/env bash
# #569's first hold of the host's lock (queue3.sh): head's object of sqlite3.c beside main's (queue.sh made it), the
# switch's build, the switch's object in each mode, then measure-compile of head against main and of main against head.
set -u
source "$(dirname "$0")/common.sh"
echo "== head object $(date +%T)"
(cd "$D/head" && taskset -c 2 ./build/compiler "${options[@]}" -o "$D/sqlite3-head.o")
echo "head object status $?"
sha256sum "$D/sqlite3-main.o" "$D/sqlite3-head.o"
echo "== build switch $(date +%T)"
(cd "$D/switch" && BUSTER_DEBUG_INFO=0 ./build.sh 2>&1 | tail -2)
echo "== switch objects $(date +%T)"
for m in "${modes[@]}"; do
    BUSTER_569_VALIDATE=$m taskset -c 2 "$D/switch/build/compiler" "${options[@]}" -o "$D/sqlite3-switch-$m.o"
    echo "switch object $m status $?"
done
sha256sum "$D"/sqlite3-switch-*.o
echo "== measure head against main $(date +%T)"
(cd "$D/head" && taskset -c 2 ./build/compiler measure-compile --runs 21 --reference "$D/main/build/compiler" -- "${options[@]}" > "$D/measure-head.txt" 2>&1)
echo "measure head status $?"
echo "== measure main against head $(date +%T)"
(cd "$D/main" && taskset -c 2 ./build/compiler measure-compile --runs 21 --reference "$D/head/build/compiler" -- "${options[@]}" > "$D/measure-main.txt" 2>&1)
echo "measure main status $?"
