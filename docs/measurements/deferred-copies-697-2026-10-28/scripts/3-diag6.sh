#!/bin/bash
# Whether populating a lane's per-name columns when they are laid out (patch_populate.py, which 3-diag4.sh found to give
# h16x19.c, h16x38.c and x16x19.c main3-nothp's walks on 8 lanes) suits the frozen sqlite3.c and four of c-testsuite's
# programs too: main3-nothp, item2-nothp and item2-nothp-pop on 8 lanes with every lane, three rounds, a round's runs in
# one lock hold, the trees' order rotating by unit and round.
D=/home/david/buster-fast-bench/697-cloud
cd "$D" || exit 1
export EXCLUSIVE_OWNER=claude-697-cloud
export EXCLUSIVE_TITLE="#697 deferred bodies (cloud session): a diagnostic of item 2's lanes on the 9700X"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/697"
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
cat > "$D/3-diag6-round.sh" <<'INNER'
#!/bin/bash
D=/home/david/buster-fast-bench/697-cloud
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
round="$1"; place="$2"; shift 2
trees=(main3-nothp item2-nothp item2-nothp-pop)
for unit in "$@"; do
    case "$unit" in
        sqlite) file="$corpus/sqlite/sqlite3.c"; passes=12 ;;
        0*) file="$D/c-testsuite/tests/single-exec/$unit.c"; passes=24 ;;
        *) file="$D/inputs/synthetic/$unit.c"; passes=24 ;;
    esac
    for ((k = 0; k < 3; k += 1)); do
        "$D/3-runs.sh" "$D/3-diag6.txt" "$round" "$unit" "$file" "$passes" "${trees[$(((k + place) % 3))]}:8:every"
    done
    place=$((place + 1))
done
INNER
chmod +x "$D/3-diag6-round.sh"
for round in 1 2 3; do
    ~/buster-fast-bench/exclusive.sh "$D/3-diag6-round.sh" "$round" "$round" sqlite 00213 00182 00204 00200 h2x40 > /dev/null 2>> "$D/3-queue.lock.txt"
    sleep 20
done
echo "3-diag6 done $(date -Is)" >> "$D/chain.out"
