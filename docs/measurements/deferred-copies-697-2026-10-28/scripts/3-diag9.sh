#!/bin/bash
# Whether the lanes' excess walks on eight lanes (3-diag4.sh) are their clears of check_input_run's arena of rare
# columns (#572), whose huge pages a body's first write allocates (3-diag5.sh): item2-nothp and final4 with that arena in
# base pages (patch_sparse.py: item2-nothp-sparse, final4-sparse), against item2-nothp, final4 and main3-nothp, on 8
# lanes with every lane, two rounds, a round's runs in one lock hold; then final4's cycles with call chains on h16x19.c
# (cyclemap.py, cyclemap2.py), in holds of their own.
D=/home/david/buster-fast-bench/697-cloud
cd "$D" || exit 1
export EXCLUSIVE_OWNER=claude-697-cloud
export EXCLUSIVE_TITLE="#697 deferred bodies (cloud session): a diagnostic of item 2's lanes on the 9700X"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/697"
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
for t in item2-nothp final4; do
    rm -rf "$t-sparse" && cp -a "$t" "$t-sparse" && python3 patch_sparse.py "$t-sparse/src/buster/compiler/c_check_input.c" || exit 1
    (cd "$t-sparse" && nice -n 19 sha256sum build.sh && find src -type f | LC_ALL=C sort | xargs nice -n 19 sha256sum) > "source-$t-sparse.sha256"
    echo "== $(date -Is) build $t-sparse" >> 3-diag9-builds.txt
    (cd "$t-sparse" && ~/buster-fast-bench/exclusive.sh env BUSTER_DEBUG_INFO=0 ./build.sh) >> 3-diag9-builds.txt 2>&1 || exit 1
done
cat > "$D/3-diag9-round.sh" <<'INNER'
#!/bin/bash
D=/home/david/buster-fast-bench/697-cloud
round="$1"; place="$2"; shift 2
trees=(item2-nothp-sparse final4-sparse item2-nothp final4 main3-nothp)
for unit in "$@"; do
    for ((k = 0; k < 5; k += 1)); do
        "$D/3-runs.sh" "$D/3-diag9.txt" "$round" "$unit" "$D/inputs/synthetic/$unit.c" 24 "${trees[$(((k + place) % 5))]}:8:every"
    done
    place=$((place + 1))
done
INNER
chmod +x "$D/3-diag9-round.sh"
for round in 1 2; do
    ~/buster-fast-bench/exclusive.sh "$D/3-diag9-round.sh" "$round" "$round" h16x19 h16x38 x16x19 b16x77 l16x38f384 h16x10 > /dev/null 2>> "$D/3-queue.lock.txt"
    sleep 20
done
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
options=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
echo "== $(date -Is) cycles final4 h16x19" >> "$D/3-diag9.txt"
~/buster-fast-bench/exclusive.sh perf record -q -e cycles -F 20000 -g -o "$D/3-diag9-final4-cycles.data" "$D/final4/build/compiler" benchmark-checker-deferred --passes 6 --lanes 8 --every-lane --cpus 2,0,1,3,4,5,6,7 "${options[@]}" "$D/inputs/synthetic/h16x19.c" >> "$D/3-diag9.txt" 2>&1
echo "exit=$? $(date -Is)" >> "$D/3-diag9.txt"
~/buster-fast-bench/exclusive.sh bash -c '
D=/home/david/buster-fast-bench/697-cloud
perf script -i "$D/3-diag9-final4-cycles.data" -F pid,tid,ip,sym 2>/dev/null > "$D/3-diag9-final4-cycles.txt"
python3 "$D/cyclemap.py" < "$D/3-diag9-final4-cycles.txt" > "$D/3-diag9-final4-cyclemap.txt"
python3 "$D/cyclemap2.py" check_input_declaration check_deferred_part type_initialize syscall < "$D/3-diag9-final4-cycles.txt" > "$D/3-diag9-final4-lane-kernel-chains.txt"
perf script -i "$D/3-diag5-item2-nothp-cycles.data" -F pid,tid,ip,sym 2>/dev/null | python3 "$D/cyclemap2.py" check_input_declaration check_deferred_part type_initialize syscall > "$D/3-diag5-item2-nothp-lane-kernel-chains.txt"
rm -f "$D/3-diag9-final4-cycles.txt"'
echo "3-diag9 done $(date -Is)" >> "$D/chain.out"
