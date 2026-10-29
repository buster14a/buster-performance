#!/bin/bash
# Which of item 2's commits reads h16x19.c, h16x38.c and x16x19.c slower than main3 on 8 lanes once the deferred state's
# own arenas are in base pages (3-diag3.sh): main3 and main3 with stepA.diff (the type index), stepAB.diff (and the
# per-name columns) and item2.diff (and the proxies), each with patch_nothp.py, and item2's with patch_populate.py too;
# on 8 lanes with every lane, two rounds, a round's runs in two lock holds, the trees' order rotating by unit and round.
D=/home/david/buster-fast-bench/697-cloud
cd "$D" || exit 1
export EXCLUSIVE_OWNER=claude-697-cloud
export EXCLUSIVE_TITLE="#697 deferred bodies (cloud session): a diagnostic of item 2's lanes on the 9700X"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/697"
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
make_tree()
{
    local name="$1" diff="$2" populate="$3"
    rm -rf "$name" && cp -a main3 "$name" || return 1
    if [ -n "$diff" ]; then (cd "$name" && git apply "../$diff") || return 1; fi
    python3 patch_nothp.py "$name/src/buster/compiler/c_check_deferred.c" || return 1
    if [ -n "$populate" ]; then python3 patch_populate.py "$name/src/buster/compiler/c_check_deferred.c" || return 1; fi
    echo "== $(date -Is) build $name" >> 3-diag4-builds.txt
    (cd "$name" && ~/buster-fast-bench/exclusive.sh env BUSTER_DEBUG_INFO=0 ./build.sh) >> 3-diag4-builds.txt 2>&1
}
make_tree stepA-nothp stepA.diff "" || exit 1
make_tree stepAB-nothp stepAB.diff "" || exit 1
make_tree item2-nothp-pop item2.diff yes || exit 1
cat > "$D/3-diag4-half.sh" <<'INNER'
#!/bin/bash
D=/home/david/buster-fast-bench/697-cloud
round="$1"; place="$2"; shift 2
trees=(main3-nothp stepA-nothp stepAB-nothp item2-nothp item2-nothp-pop)
for unit in "$@"; do
    for ((k = 0; k < 5; k += 1)); do
        "$D/3-runs.sh" "$D/3-diag4.txt" "$round" "$unit" "$D/inputs/synthetic/$unit.c" 24 "${trees[$(((k + place) % 5))]}:8:every"
    done
    place=$((place + 1))
done
INNER
chmod +x "$D/3-diag4-half.sh"
for round in 1 2; do
    ~/buster-fast-bench/exclusive.sh "$D/3-diag4-half.sh" "$round" $((round * 6)) h16x19 h16x38 x16x19 > /dev/null 2>> "$D/3-queue.lock.txt"
    sleep 20
    ~/buster-fast-bench/exclusive.sh "$D/3-diag4-half.sh" "$round" $((round * 6 + 3)) h16x10 l16x38f384 b16x77 > /dev/null 2>> "$D/3-queue.lock.txt"
    sleep 20
done
echo "3-diag4 done $(date -Is)" >> "$D/chain.out"
