#!/bin/bash
# Placements: each tree relinked with its frontend unit (the lexer and the refine pass) shifted by six amounts, one
# hold per tree (the builds exist; shifts relinks), then time-runs under ab (which takes the lock per process): main,
# the lexer head, the refine experiment and main again, 6 placements x 2 copies x 3 runs, -c and -fsyntax-only of the
# frozen sqlite3.c, CPU 2, two rounds.
cd ~/buster-fast-bench/1555-claude
export EXCLUSIVE_OWNER=claude-1555 EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1555
shifts="0 704 1408 2048 2752 3456"
for t in main lexer refine; do
    EXCLUSIVE_TITLE="#1555 shifts $t" ~/buster-fast-bench/exclusive.sh bash -c "cd $t && env BUSTER_HOST_ARCH=znver5 ./build.sh shifts ../shifts/$t main_unit_frontend.c $shifts" > stage6-shifts-$t.log 2>&1 || { echo "shifts $t FAILED"; tail -5 stage6-shifts-$t.log; exit 1; }
    sha256sum shifts/$t/compiler-*
done
cd run
source ../main/tools/microarch/workloads.sh
export LC_ALL=C LC_NUMERIC=C SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
builds=()
for b in main:main lexer:lexer refine:refine main-again:main; do
    for s in $shifts; do builds+=(--build "${b%%:*}" "../shifts/${b#*:}/compiler-$s"); done
done
EXCLUSIVE_TITLE="#1555 placements A/B" ./bin/compiler-main ab --rounds 2 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh ./bin/compiler-main \
    -- time-runs --runs 3 --copies 2 "${builds[@]}" --list "${COMMON[@]}" "${SQLITE[@]}" -c -o scratch/tr-sq.o --lanes 1 \
    --list "${COMMON[@]}" "${SQLITE[@]}" -fsyntax-only > results/placements.log 2>&1
echo "ab exit=$?"
grep -v "^ *[0-9]" results/placements.log | tail -60
echo stage6-done
