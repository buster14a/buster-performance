#!/bin/bash
# The final tree (final4: main3 with final4.diff, item 2 with the deferred state's own arenas in base pages and a lane's
# per-name columns committed for the names a reading has) against item2-nothp-pop (the whole names arena committed),
# item2-nothp (nothing committed) and main3-nothp, on 8 lanes with every lane, on the units where those differed
# (3-diag4.sh, 3-diag6.sh), two rounds, a round's runs in one lock hold, the trees' order rotating by unit and round.
# Arguments: MAIN.
D=/home/david/buster-fast-bench/697-cloud
cd "$D" || exit 1
export EXCLUSIVE_OWNER=claude-697-cloud
export EXCLUSIVE_TITLE="#697 deferred bodies (cloud session): a diagnostic of item 2's lanes on the 9700X"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/697"
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
"$D/3-build.sh" "$1" final4 || { echo "3-diag7 build failed $(date -Is)" >> "$D/chain.out"; exit 1; }
cat > "$D/3-diag7-round.sh" <<'INNER'
#!/bin/bash
D=/home/david/buster-fast-bench/697-cloud
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
round="$1"; place="$2"; shift 2
trees=(final4 item2-nothp-pop item2-nothp main3-nothp)
for unit in "$@"; do
    case "$unit" in
        sqlite) file="$corpus/sqlite/sqlite3.c"; passes=12 ;;
        0*) file="$D/c-testsuite/tests/single-exec/$unit.c"; passes=24 ;;
        *) file="$D/inputs/synthetic/$unit.c"; passes=24 ;;
    esac
    for ((k = 0; k < 4; k += 1)); do
        "$D/3-runs.sh" "$D/3-diag7.txt" "$round" "$unit" "$file" "$passes" "${trees[$(((k + place) % 4))]}:8:every"
    done
    place=$((place + 1))
done
INNER
chmod +x "$D/3-diag7-round.sh"
for round in 1 2; do
    ~/buster-fast-bench/exclusive.sh "$D/3-diag7-round.sh" "$round" "$round" sqlite 00213 00204 00182 h2x40 h16x19 x16x19 b16x77 > /dev/null 2>> "$D/3-queue.lock.txt"
    sleep 20
done
echo "3-diag7 done $(date -Is)" >> "$D/chain.out"
