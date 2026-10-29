#!/bin/bash
# 3-diag3.sh's runs (its builds done) in fewer lock holds: per round, the units in two halves, a hold each, the trees'
# order rotating by unit and round.
D=/home/david/buster-fast-bench/697-cloud
cd "$D" || exit 1
export EXCLUSIVE_OWNER=claude-697-cloud
export EXCLUSIVE_TITLE="#697 deferred bodies (cloud session): a diagnostic of item 2's lanes on the 9700X"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/697"
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
cat > "$D/3-diag3-half.sh" <<'INNER'
#!/bin/bash
# One hold's runs: ROUND PLACE UNIT...: each unit on 8 lanes with every lane by the four trees, in an order that starts
# one tree further on for each unit after PLACE.
D=/home/david/buster-fast-bench/697-cloud
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
round="$1"; place="$2"; shift 2
trees=(item2 item2-nothp main3 main3-nothp)
for unit in "$@"; do
    if [ "$unit" = sqlite ]; then file="$corpus/sqlite/sqlite3.c"; passes=12; else file="$D/inputs/synthetic/$unit.c"; passes=24; fi
    for ((k = 0; k < 4; k += 1)); do
        "$D/3-runs.sh" "$D/3-diag3.txt" "$round" "$unit" "$file" "$passes" "${trees[$(((k + place) % 4))]}:8:every"
    done
    place=$((place + 1))
done
INNER
chmod +x "$D/3-diag3-half.sh"
for round in 1 2; do
    ~/buster-fast-bench/exclusive.sh "$D/3-diag3-half.sh" "$round" $((round * 6)) h16x19 l16x10f192 x16x19 > /dev/null 2>> "$D/3-queue.lock.txt"
    sleep 20
    ~/buster-fast-bench/exclusive.sh "$D/3-diag3-half.sh" "$round" $((round * 6 + 3)) h16x38 h16x10 sqlite > /dev/null 2>> "$D/3-queue.lock.txt"
    sleep 20
done
echo "3-diag3 done $(date -Is)" >> "$D/chain.out"
