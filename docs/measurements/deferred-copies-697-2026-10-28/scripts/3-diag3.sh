#!/bin/bash
# Whether the lanes' 2 MB clears (3-diag2.sh: do_huge_pmd_wp_page under check_input_declaration, most of a woken lane's
# time) are in the deferred state's own arenas: main3 and item2 against their copies with those arenas in base pages
# (patch_nothp.py), on 8 lanes with every lane, on the units item 2 read worse on 8 lanes than main3 and two controls,
# two rounds, each run a process and a lock hold of its own, the trees' order rotating by unit and round.
D=/home/david/buster-fast-bench/697-cloud
cd "$D" || exit 1
export EXCLUSIVE_OWNER=claude-697-cloud
export EXCLUSIVE_TITLE="#697 deferred bodies (cloud session): a diagnostic of item 2's lanes on the 9700X"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/697"
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
for t in main3 item2; do
    rm -rf "$t-nothp" && cp -a "$t" "$t-nothp" && python3 patch_nothp.py "$t-nothp/src/buster/compiler/c_check_deferred.c" || exit 1
    echo "== $(date -Is) build $t-nothp" >> 3-diag3-builds.txt
    (cd "$t-nothp" && ~/buster-fast-bench/exclusive.sh env BUSTER_DEBUG_INFO=0 ./build.sh) >> 3-diag3-builds.txt 2>&1 || exit 1
done
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
trees=(item2 item2-nothp main3 main3-nothp)
place=0
for round in 1 2; do
    for unit in h16x19 l16x10f192 x16x19 h16x38 h16x10 sqlite; do
        if [ "$unit" = sqlite ]; then file="$corpus/sqlite/sqlite3.c"; passes=12; else file="$D/inputs/synthetic/$unit.c"; passes=24; fi
        for ((k = 0; k < 4; k += 1)); do
            tree="${trees[$(((k + place) % 4))]}"
            ~/buster-fast-bench/exclusive.sh "$D/3-runs.sh" "$D/3-diag3.txt" "$round" "$unit" "$file" "$passes" "$tree:8:every" > /dev/null 2>> "$D/3-queue.lock.txt"
        done
        place=$((place + 1))
    done
done
echo "3-diag3 done $(date -Is)" >> "$D/chain.out"
