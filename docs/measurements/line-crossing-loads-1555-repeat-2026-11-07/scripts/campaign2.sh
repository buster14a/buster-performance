#!/bin/bash
# #1555's repeat, trimmed (campaign.sh stopped after its first 20 runs: with the lock taken per run and CI holding it
# for long stretches, its ~160 runs would have taken about a day). Each run is still one run of one.sh, which takes the
# host's lock for that run alone; ab takes it itself per time-runs process. A run already in the manifest with status 0
# is not repeated. Steps: probes (once each), counters (-c, six rounds), profiles (one each, whole reports), the lexer's
# in-process comparison, the refine phase, placements.
set -u
root=$HOME/buster-fast-bench/1555-claude-r2
run=$root/run
one=$root/one.sh
cd "$run" || exit 2
export LC_ALL=C LC_NUMERIC=C SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
source "$root/trees/main/tools/microarch/workloads.sh"
SCRATCH=scratch
step()
{
    echo "$(date -Is) step: $*" >> "$root/runs/steps"
}
done_already()
{
    grep -qx "$1 0" "$root/runs/manifest"
}
once()
{
    local name=$1
    shift
    done_already "$name" || "$one" "$name" "$@"
}

step "probes (trimmed: once each)"
for cfg in "0 0 32" "0 40 32" "1 40 8" "1 0 8" "3 0 64" "3 1 64" "4 0 0"; do
    n=probe1-${cfg// /-}-r1
    once $n -- perf stat -x, -o "$root/runs/$n/perf.csv" -e cycles:u,instructions:u,ls_misal_loads.ma64:u,ls_dispatch.ld_dispatch:u taskset -c 2 "$root/probe/split-probe" $cfg 20000
done
for cfg in "32 0" "32 40" "33 40" "64 0" "64 1"; do
    n=probe2-${cfg// /-}-r1
    once $n -- perf stat -x, -o "$root/runs/$n/perf.csv" -e cycles:u,instructions:u,ls_misal_loads.ma64:u,ls_dispatch.ld_dispatch:u taskset -c 2 "$root/probe/split-probe2" $cfg 20000
done

step "counters (trimmed: -c, six rounds)"
variants=(main lexer refine)
for r in $(seq 6); do
    for i in 0 1 2; do
        v=${variants[$(( (i + r) % 3 ))]}
        workload "$v" sq-c
        n=counters-r$r-$v-sq-c
        once $n -- perf stat -x, -o "$root/runs/$n/perf.csv" -e cycles:u,instructions:u,ls_misal_loads.ma64:u,ls_dispatch.ld_dispatch:u taskset -c 2 "${WL[@]}"
    done
done

step "profiles (trimmed: one each)"
for v in main lexer refine; do
    workload "$v" sq-c
    n=profile-r1-$v
    once $n -- perf record -q -e ls_misal_loads.ma64:u -c 997 -o "$root/runs/$n/perf.data" taskset -c 2 "${WL[@]}"
    once report-r1-$v -- perf report -i "$root/runs/$n/perf.data" --stdio --no-children --sort symbol
done

step "lexer variants (trimmed)"
once lexer-variants-sqlite3_c -- taskset -c 2 bin/compiler-bench benchmark-lexer "$run/corpus/sqlite/sqlite3.c"
once lexer-variants-sqlite3_c-no-separators -- taskset -c 2 bin/compiler-bench benchmark-lexer --no-digit-separators "$run/corpus/sqlite/sqlite3.c"
once lexer-variants-libc -- taskset -c 2 bin/compiler-bench benchmark-lexer "$HOME/azp-bench/c-tokenizer/corpus/libc"
once lexer-variants-src -- taskset -c 2 bin/compiler-bench benchmark-lexer "$root/trees/main/src"

step "refine phase (trimmed: three rounds)"
for r in 1 2 3; do
    if [ $((r % 2)) = 1 ]; then order="main refine"; else order="refine main"; fi
    for v in $order; do
        once refine-phase-r$r-$v -- taskset -c 2 bin/compiler-$v benchmark-refinement --only refine_tokens_64 corpus/sqlite/sqlite3.c
    done
done

step placements
shifts="0 704 1408 2048 2752 3456"
for t in main lexer refine; do
    once shifts-$t -- bash -c "cd $root/trees/$t && env BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh shifts $root/shifts/$t main_unit_frontend.c $shifts"
done
sha256sum "$root"/shifts/*/compiler-* > "$root/runs/shifted-executables"
builds=()
for b in main:main lexer:lexer refine:refine main-again:main; do
    for s in $shifts; do builds+=(--build "${b%%:*}" "$root/shifts/${b#*:}/compiler-$s"); done
done
mkdir -p "$root/runs/placements"
EXCLUSIVE_OWNER=claude-1555 EXCLUSIVE_TITLE="#1555 repeat: placements (ab, one time-runs process per hold)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1555 \
    bin/compiler-main ab --rounds 4 --cpu 2 --lock "$HOME/buster-fast-bench/exclusive.sh" bin/compiler-main \
    -- time-runs --runs 1 --copies 2 "${builds[@]}" --list "${COMMON[@]}" "${SQLITE[@]}" -c -o scratch/tr-sq.o --lanes 1 \
    --list "${COMMON[@]}" "${SQLITE[@]}" -fsyntax-only > "$root/runs/placements/ab.log" 2> "$root/runs/placements/ab.stderr"
echo "ab $?" >> "$root/runs/manifest"
step done
