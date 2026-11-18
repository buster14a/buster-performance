#!/bin/bash
# #2924 C8's gate, validation's route (#2972): experiment-route.patch, experiment.patch plus each validation call's
# tables (locals, calls, arguments) and route (1 where tier0_validate_entries takes the scalar body by size), one run of
# objects.sh with every area on its vector path, under the lock on CPU 2.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: Tier 0's validation route" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2972
L=~/buster-fast-bench/exclusive.sh
mkdir -p logs/route ticks-route
if [ ! -d src-route ]; then git clone -q --shared src src-route || exit 1; fi
git -C src-route checkout -q --detach c280bdca9 && git -C src-route reset -q --hard && git -C src-route apply "$D/experiment-route.patch" || { echo "patch failed" >> logs/route/status.txt; exit 1; }
(cd src-route && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/route/build.log" 2>&1) || { echo "build failed" >> logs/route/status.txt; exit 1; }
cp src-route/build/compiler compiler-route
objects=/dev/shm/claude-2924-c8gate-route
rm -f ticks-route/0-1.txt
BUSTER_TIER0_SCALAR_AREAS=0 BUSTER_TIER0_AREA_TICKS="$D/ticks-route/0-1.txt" $L timeout -k 5 1500 taskset -c 2 "$D/objects.sh" "$D/compiler-route" "$objects/t" "$D/src" > logs/route/ticks.log 2>&1
echo "route: $(grep -v '^exclusive' logs/route/ticks.log | tr '\n' ' ') $(wc -l < ticks-route/0-1.txt) lines" >> logs/route/status.txt
rm -rf "$objects"
date -u +%FT%TZ > logs/route/.done
