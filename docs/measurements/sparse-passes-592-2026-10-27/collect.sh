#!/bin/bash
# #592: the record's files from the final A/B: every stage report and perf stat's counters, the objects' and the
# compilers' hashes, and each tree's files by sha256. Run under the lock, after run-final.sh.
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
cd "$here"
record="$here/record"
rm -rf "$record"
mkdir -p "$record"
for tree in main2 head; do
    for round in $(seq 1 15); do
        sed "s/^/$tree round $round\t/" "final/stages-$tree-$round.txt"
    done
done > "$record/stages.txt"
for tree in main2 head; do
    for round in 1 2 3 4; do
        grep -v '^#' "final/stat-$tree-$round.txt" | grep -v '^$' | sed "s/^/$tree round $round,/"
    done
done > "$record/stat.txt"
grep -E '^[0-9a-f]{64}  ' ab-final.log > "$record/objects.txt"
sha256sum main2/build/compiler head/build/compiler > "$record/compilers.txt"
for tree in main2 head; do
    (cd "$tree" && find . -path ./build -prune -o -type f -print | LC_ALL=C sort | xargs sha256sum) > "$record/tree-$tree.txt"
done
grep -E '^build exit|^build\.sh: [0-9]+ sources compiled' build-main2.log build-head.log > "$record/builds.txt"
uname -r > "$record/host.txt"
clang --version | head -1 >> "$record/host.txt"
sha256sum /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c >> "$record/host.txt"
echo collected
# The scripts' own lines only: exclusive.sh's messages about other holders of the lock name other sessions.
{ grep -E '^build exit [0-9]+$|^build\.sh: [0-9]+ sources compiled' build-main2.log | sed 's/^/main2: /'
  grep -E '^build exit [0-9]+$|^build\.sh: [0-9]+ sources compiled' build-head.log | sed 's/^/head: /'
  grep -E '^[0-9a-f]{64}  |^ab done$|^ab exit [0-9]+$' ab-final.log; } > "$record/run.log"
cp ab.sh run-final.sh summary.sh collect.sh "$record/"
echo "run.log written"
