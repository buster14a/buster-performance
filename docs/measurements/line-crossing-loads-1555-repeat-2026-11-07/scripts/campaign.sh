#!/bin/bash
# #1555's repeat on the 9700X: every build, test, compile, benchmark, perf stat, perf record and perf report is one
# run of one.sh, which takes the host's lock for that run alone. ab takes it itself for each time-runs process
# (docs/profiling.md). Steps: identities, builds, tests, outputs, probes, counters, profiles, the lexer's in-process
# comparison, the refine phase, placements. Runs from the run root; trees/ holds the clean clones.
set -u
root=$HOME/buster-fast-bench/1555-claude-r2
run=$root/run
one=$root/one.sh
cd "$run" || exit 2
export LC_ALL=C LC_NUMERIC=C SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
source "$root/trees/main/tools/microarch/workloads.sh"
SCRATCH=scratch
mkdir -p scratch bin "$root/runs"
step()
{
    echo "$(date -Is) step: $*" >> "$root/runs/steps"
}

step identities
{
    for t in main lexer refine bench; do
        echo "tree $t $(git -C "$root/trees/$t" rev-parse HEAD) porcelain=[$(git -C "$root/trees/$t" status --porcelain | tr '\n' ' ')]"
    done
    sha256sum corpus/sqlite/sqlite3.c corpus/provenance/gnu17-pinned-predefines.txt
    clang --version | head -1
    perf --version
    uname -r
    grep -m1 'model name' /proc/cpuinfo
} > "$root/runs/identities" 2>&1

step builds
for t in main lexer refine; do
    "$one" build-$t -- bash -c "cd $root/trees/$t && env BUSTER_HOST_ARCH=znver5 ./build.sh"
    cp "$root/trees/$t/build/compiler" bin/compiler-$t
done
"$one" build-bench -- bash -c "cd $root/trees/bench && env BUSTER_HOST_ARCH=znver5 ./build.sh lexer-variant control=src/buster/compiler/c_lexer.c k1=src/buster/compiler/c_lexer_k1_1555.c"
cp "$root/trees/bench/build/compiler" bin/compiler-bench
sha256sum bin/compiler-* > "$root/runs/executables"
for t in main lexer refine bench; do
    echo "tree $t after build: porcelain=[$(git -C "$root/trees/$t" status --porcelain | tr '\n' ' ')]" >> "$root/runs/identities"
done

step tests
"$one" test-lexer-c -- taskset -c 2 bin/compiler-lexer test-lexer
"$one" test-lexer-cplusplus -- taskset -c 2 bin/compiler-lexer test-lexer --cplusplus
"$one" test-lexer-modes -- taskset -c 2 bin/compiler-lexer test-lexer --no-digraphs --no-line-comments
"$one" test-refinement -- taskset -c 2 bin/compiler-refine test-refinement "$root/trees/refine/src"

step outputs
for w in sq-c sq-syn sq-E; do
    for v in main lexer refine; do
        workload "$v" "$w"
        "$one" output-$w-$v -- taskset -c 2 "${WL[@]}"
    done
done
{
    for w in sq-c sq-syn sq-E; do
        for v in lexer refine; do
            for f in stdout stderr status; do
                if cmp -s "$root/runs/output-$w-main/$f" "$root/runs/output-$w-$v/$f"; then echo "$w $v $f same"; else echo "$w $v $f DIFFERENT"; fi
            done
        done
    done
    for v in lexer refine; do
        cmp -s scratch/main-sq.o scratch/$v-sq.o && echo "sq-c $v object same" || echo "sq-c $v object DIFFERENT"
        cmp -s scratch/main-sq.i scratch/$v-sq.i && echo "sq-E $v output same" || echo "sq-E $v output DIFFERENT"
    done
    sha256sum scratch/*-sq.o scratch/*-sq.i
} > "$root/runs/outputs-compared"

step probes
"$one" probe-build -- bash -c "cd $root/probe && clang -O2 -march=znver5 -o split-probe split-probe.c && clang -O2 -march=znver5 -o split-probe2 split-probe2.c && sha256sum split-probe split-probe2 split-probe.c split-probe2.c"
for rep in 1 2 3; do
    for cfg in "0 0 32" "0 40 32" "1 40 8" "1 0 8" "3 0 64" "3 1 64" "4 0 0"; do
        n=probe1-${cfg// /-}-r$rep
        "$one" $n -- perf stat -x, -o "$root/runs/$n/perf.csv" -e cycles:u,instructions:u,ls_misal_loads.ma64:u,ls_dispatch.ld_dispatch:u taskset -c 2 "$root/probe/split-probe" $cfg 20000
    done
    for cfg in "32 0" "32 40" "33 0" "33 40" "64 0" "64 1"; do
        n=probe2-${cfg// /-}-r$rep
        "$one" $n -- perf stat -x, -o "$root/runs/$n/perf.csv" -e cycles:u,instructions:u,ls_misal_loads.ma64:u,ls_dispatch.ld_dispatch:u taskset -c 2 "$root/probe/split-probe2" $cfg 20000
    done
done

step counters
variants=(main lexer refine)
for r in $(seq 10); do
    for i in 0 1 2; do
        v=${variants[$(( (i + r) % 3 ))]}
        for w in sq-c sq-syn; do
            workload "$v" "$w"
            n=counters-r$r-$v-$w
            "$one" $n -- perf stat -x, -o "$root/runs/$n/perf.csv" -e cycles:u,instructions:u,ls_misal_loads.ma64:u,ls_dispatch.ld_dispatch:u taskset -c 2 "${WL[@]}"
        done
    done
done

step profiles
for r in 1 2 3; do
    for v in main lexer refine; do
        workload "$v" sq-c
        n=profile-r$r-$v
        "$one" $n -- perf record -q -e ls_misal_loads.ma64:u -c 997 -o "$root/runs/$n/perf.data" taskset -c 2 "${WL[@]}"
        "$one" report-r$r-$v -- perf report -i "$root/runs/$n/perf.data" --stdio --no-children --sort symbol
    done
done

step lexer-variants
for corpus in "$run/corpus/sqlite/sqlite3.c" "$HOME/azp-bench/c-tokenizer/corpus/libc" "$root/trees/main/src"; do
    c=$(basename "$corpus" | tr . _)
    "$one" lexer-variants-$c -- taskset -c 2 bin/compiler-bench benchmark-lexer "$corpus"
    "$one" lexer-variants-$c-no-separators -- taskset -c 2 bin/compiler-bench benchmark-lexer --no-digit-separators "$corpus"
done

step refine-phase
for r in 1 2 3 4 5; do
    if [ $((r % 2)) = 1 ]; then order="main refine"; else order="refine main"; fi
    for v in $order; do
        "$one" refine-phase-r$r-$v -- taskset -c 2 bin/compiler-$v benchmark-refinement --only refine_tokens_64 corpus/sqlite/sqlite3.c
    done
done

step placements
shifts="0 704 1408 2048 2752 3456"
for t in main lexer refine; do
    "$one" shifts-$t -- bash -c "cd $root/trees/$t && env BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh shifts $root/shifts/$t main_unit_frontend.c $shifts"
done
sha256sum "$root"/shifts/*/compiler-* > "$root/runs/shifted-executables"
builds=()
for b in main:main lexer:lexer refine:refine main-again:main; do
    for s in $shifts; do builds+=(--build "${b%%:*}" "$root/shifts/${b#*:}/compiler-$s"); done
done
mkdir -p "$root/runs/placements"
EXCLUSIVE_OWNER=claude-1555 EXCLUSIVE_TITLE="#1555 repeat: placements (ab, one time-runs process per hold)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1555 \
    bin/compiler-main ab --rounds 6 --cpu 2 --lock "$HOME/buster-fast-bench/exclusive.sh" bin/compiler-main \
    -- time-runs --runs 1 --copies 2 "${builds[@]}" --list "${COMMON[@]}" "${SQLITE[@]}" -c -o scratch/tr-sq.o --lanes 1 \
    --list "${COMMON[@]}" "${SQLITE[@]}" -fsyntax-only > "$root/runs/placements/ab.log" 2> "$root/runs/placements/ab.stderr"
echo "ab $?" >> "$root/runs/manifest"
step done
