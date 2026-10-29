#!/bin/bash
# Two controls of abZ2's difference in user cycles: (1) perf stat of the front end's and the caches' events, the branch
# mispredictions and the TLB misses of base's and the head's executables at the checker unit's shift 0 (abZ2's
# compiler-0) and of a copy of base's (aa), in three rounds whose order rotates; (2) abZ2's comparison over placements
# again, the front end's unit (main_unit_frontend.c) shifted instead of the checker's. Every run takes the lock on its
# own and runs pinned to CPU 2.
set -u
export EXCLUSIVE_OWNER=claude-126-cloud EXCLUSIVE_TITLE="solve #126 (cloud session): 9d's head against its parent, events and front end placements" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/126
lock=~/buster-fast-bench/exclusive.sh
unset CPATH C_INCLUDE_PATH BUSTER_ORACLE_CACHE
here=~/buster-fast-bench/claude-126-cloud/abZ
export TMPDIR=$here/tmp
mkdir -p "$TMPDIR"
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
system=(-nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
lower=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}" "$corpus/sqlite/sqlite3.c")
check=(--clang-features "${lower[@]}")
cd "$here"
mkdir -p events && cp shifts/base/compiler-0 events/base && cp shifts/base/compiler-0 events/aa && cp shifts/h9d/compiler-0 events/h9d
# Five counters at a time: three sets, each with the instructions and the cycles.
front=instructions:u,cycles:u,branch-misses:u,ic_tag_hit_miss.instruction_cache_miss:u,op_cache_hit_miss.op_cache_miss:u
memory=instructions:u,cycles:u,bp_l1_tlb_miss_l2_tlb_hit:u,bp_l1_tlb_miss_l2_tlb_miss.all:u,ls_any_fills_from_sys.all:u
decode=instructions:u,cycles:u,de_src_op_disp.x86_decoder:u,l2_cache_req_stat.ic_dc_miss_in_l2:u
order=(base aa h9d)
for round in 1 2 3; do
    for i in "${!order[@]}"; do
        tree=${order[$(( (i + round - 1) % ${#order[@]} ))]}
        for set in front memory decode; do
            echo "== round $round tree $tree lower $set" >> events.log
            $lock perf stat -x, -e ${!set} -r 11 taskset -c 2 events/$tree -c -o /dev/null "${lower[@]}" 2>> events.log >/dev/null
            echo "== round $round tree $tree drive $set" >> events.log
            $lock perf stat -x, -e ${!set} -r 11 taskset -c 2 events/$tree -fsyntax-only "${check[@]}" 2>> events.log >/dev/null
        done
    done
done
echo "events done"
shifts="0 768 1536 2304 3072 3840"
copies=/tmp/claude-126-abZ3
rm -rf front && mkdir front
for tree in base h9d; do
    (cd $tree && $lock env BUSTER_DEBUG_INFO=0 LC_NUMERIC=C ./build.sh shifts ../front/$tree main_unit_frontend.c $shifts > ../front_$tree.log 2>&1) || { echo "front shifts $tree failed"; tail -3 front_$tree.log; exit 1; }
    echo "shifted $tree's front end: $(grep -c 'bytes later' front_$tree.log) placements"
done
builds=()
for b in base:base h9d:h9d base-again:base; do
    for s in $shifts; do builds+=(--build "${b%%:*}" "front/${b#*:}/compiler-$s"); done
done
rm -rf "$copies" && mkdir -p "$copies"
base/build/compiler ab --rounds 3 --cpu 2 --lock $lock base/build/compiler \
    -- time-runs --runs 3 --copies 3 --directory "$copies" "${builds[@]}" --list -c -o /dev/null "${lower[@]}" --list -fsyntax-only "${check[@]}" > front.log 2>&1
echo "ab status $?"
rm -rf "$copies"
sha256sum events/* front/*/compiler-* > abZ3.sha256
echo done
