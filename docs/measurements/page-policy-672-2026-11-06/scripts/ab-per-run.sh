#!/bin/bash
# usage: ab-per-run.sh OUT A_LABEL A A_SHA256 B_LABEL B B_SHA256
# 7 rounds; in each, the counts 1, 8, 2 and 4 in turn, and for each count both builds, alternating which goes first.
# One hold of the 9700X's lock per run: lock.sh (exclusive.sh) around one one-run.sh, never around several. This
# script itself holds no lock. It stops at the first run that fails (a lock that isn't held, a changed identity, a
# compile that fails or leaves no object) and exits nonzero without writing `done`. After the last run it requires every
# object of every run to have one SHA-256, and only then writes `done`.
# Pending: the hardware coordinator's admission of the runs, and review of whether a batch of N concurrent compiles may
# count as one run.
set -u
cd ~/buster-fast-bench/672-claude
out=$1; la=$2; a=$3; ha=$4; lb=$5; b=$6; hb=$7
if [ -e "$out" ]; then
    echo "ab-per-run.sh: $out exists" >&2
    exit 2
fi
mkdir -p "$out"
sha256sum "$a" "$b" /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c > "$out/identities.sha256"
failed=0
for r in 1 2 3 4 5 6 7; do
    for n in 1 8 2 4; do
        if (( (r + n) % 2 == 0 )); then order="$la $lb"; else order="$lb $la"; fi
        for x in $order; do
            if [ "$x" = "$la" ]; then C=$a; h=$ha; else C=$b; h=$hb; fi
            if [ "$failed" = 0 ] && ! ./lock.sh ./one-run.sh "$out" "$x" "$C" "$h" "$n" "$r"; then
                failed=1
                echo "ab-per-run.sh: round $r, $x on $n failed; stopping" >&2
            fi
        done
    done
done
if [ "$failed" = 0 ]; then
    hashes=$(cat "$out"/runs/*/objects.sha256 | cut -d' ' -f1 | sort -u | wc -l)
    objects=$(cat "$out"/runs/*/objects.sha256 | wc -l)
    expected=$((7 * 2 * (1 + 8 + 2 + 4)))
    if [ "$hashes" = 1 ] && [ "$objects" = "$expected" ]; then
        echo "done: $objects objects, one SHA-256" >> "$out/runs.txt"
    else
        failed=1
        echo "ab-per-run.sh: $objects objects of $expected, $hashes SHA-256s" >&2
    fi
fi
exit $failed
