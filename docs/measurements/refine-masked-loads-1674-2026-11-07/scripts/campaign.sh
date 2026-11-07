#!/bin/bash
# #1674 on the 9700X: main against stage 1's masked loads for every batch. Every build, test, compile, benchmark and
# perf run is one run of one.sh, which takes the host's lock for that run alone; ab takes it per time-runs process.
# Steps: identities, builds, test, outputs, counters, placement builds, the refine phase at every placement (main, the
# head and main again, in an order that rotates by placement and round), the whole drivers over placements.
set -u
root=$HOME/buster-fast-bench/1674-claude
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
    for t in main head; do
        echo "tree $t $(git -C "$root/trees/$t" rev-parse HEAD) porcelain=[$(git -C "$root/trees/$t" status --porcelain | tr '\n' ' ')]"
    done
    sha256sum corpus/sqlite/sqlite3.c corpus/provenance/gnu17-pinned-predefines.txt
    clang --version | head -1
    perf --version
    uname -r
    grep -m1 'model name' /proc/cpuinfo
} > "$root/runs/identities" 2>&1

step builds
for t in main head; do
    "$one" build-$t -- bash -c "cd $root/trees/$t && env BUSTER_HOST_ARCH=znver5 ./build.sh"
    cp "$root/trees/$t/build/compiler" bin/compiler-$t
done
sha256sum bin/compiler-* > "$root/runs/executables"
for t in main head; do
    echo "tree $t after build: porcelain=[$(git -C "$root/trees/$t" status --porcelain | tr '\n' ' ')]" >> "$root/runs/identities"
done

step test
"$one" test-refinement-head -- taskset -c 2 bin/compiler-head test-refinement "$root/trees/head/src"

step outputs
for w in sq-c sq-syn sq-E; do
    for v in main head; do
        workload "$v" "$w"
        "$one" output-$w-$v -- taskset -c 2 "${WL[@]}"
    done
done
{
    for w in sq-c sq-syn sq-E; do
        for f in stdout stderr status; do
            if cmp -s "$root/runs/output-$w-main/$f" "$root/runs/output-$w-head/$f"; then echo "$w $f same"; else echo "$w $f DIFFERENT"; fi
        done
    done
    cmp -s scratch/main-sq.o scratch/head-sq.o && echo "sq-c object same" || echo "sq-c object DIFFERENT"
    cmp -s scratch/main-sq.i scratch/head-sq.i && echo "sq-E output same" || echo "sq-E output DIFFERENT"
    sha256sum scratch/*-sq.o scratch/*-sq.i
} > "$root/runs/outputs-compared"

step counters
variants=(main head)
for r in $(seq 6); do
    for i in 0 1; do
        v=${variants[$(( (i + r) % 2 ))]}
        workload "$v" sq-c
        n=counters-r$r-$v-sq-c
        "$one" $n -- perf stat -x, -o "$root/runs/$n/perf.csv" -e cycles:u,instructions:u,ls_dispatch.ld_dispatch:u taskset -c 2 "${WL[@]}"
    done
done

step placement-builds
shifts="0 704 1408 2048 2752 3456"
for t in main head; do
    "$one" shifts-$t -- bash -c "cd $root/trees/$t && env BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh shifts $root/shifts/$t main_unit_frontend.c $shifts"
done
sha256sum "$root"/shifts/*/compiler-* > "$root/runs/shifted-executables"

step refine-phase
builds=(main head main-again)
for corpus in sqlite3_c:"$run/corpus/sqlite/sqlite3.c":3 libc:"$HOME/azp-bench/c-tokenizer/corpus/libc":1 src:"$root/trees/main/src":1; do
    name=${corpus%%:*}
    rest=${corpus#*:}
    path=${rest%:*}
    rounds=${rest##*:}
    for r in $(seq "$rounds"); do
        p=0
        for s in $shifts; do
            p=$((p + 1))
            for i in 0 1 2; do
                b=${builds[$(( (i + p + r) % 3 ))]}
                t=${b%-again}
                "$one" phase-$name-r$r-p$s-$b -- taskset -c 2 "$root/shifts/$t/compiler-$s" benchmark-refinement --only refine_tokens_64 "$path"
            done
        done
    done
done

step placements
wl=()
for b in main:main head:head main-again:main; do
    for s in $shifts; do wl+=(--build "${b%%:*}" "$root/shifts/${b#*:}/compiler-$s"); done
done
mkdir -p "$root/runs/placements"
EXCLUSIVE_OWNER=claude-1674 EXCLUSIVE_TITLE="#1674: placements (ab, one time-runs process per hold)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1674 \
    bin/compiler-main ab --rounds 4 --cpu 2 --lock "$HOME/buster-fast-bench/exclusive.sh" bin/compiler-main \
    -- time-runs --runs 1 --copies 2 "${wl[@]}" --list "${COMMON[@]}" "${SQLITE[@]}" -c -o scratch/tr-sq.o --lanes 1 \
    --list "${COMMON[@]}" "${SQLITE[@]}" -fsyntax-only > "$root/runs/placements/ab.log" 2> "$root/runs/placements/ab.stderr"
echo "ab $?" >> "$root/runs/manifest"
step done
