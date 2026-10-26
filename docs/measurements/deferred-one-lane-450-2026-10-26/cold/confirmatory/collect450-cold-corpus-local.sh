#!/bin/bash
set -euo pipefail
root=/home/david/Documents/Codex/2026-10-26/claim-and-solve-three-buster-performance
cd "$root"
record=work/performance/docs/measurements/deferred-one-lane-450-2026-10-26/cold/confirmatory
test -s work/campaign/450-cold-corpus-raw.tar
mkdir -p work/campaign/cold450-corpus "$record/raw"
tar -xf work/campaign/450-cold-corpus-raw.tar -C work/campaign/cold450-corpus
cp -a work/campaign/cold450-corpus/logs/450-cold-corpus/. "$record/raw/"
cp work/campaign/cold450-corpus/corpus450-cold.sh work/campaign/cold450-corpus/corpus450-cold-held.sh "$record/"
cp work/campaign/run450-cold-corpus.log "$record/native-queue.log"
cp work/campaign/450-cold-corpus-collection.log "$record/collection.log"
for when in before after; do
    sed -n '/^[[:xdigit:]]\{64\}  /p' "$record/raw/provenance-$when.log" > "work/campaign/450-cold-corpus-$when.sha256"
    test "$(wc -l < "work/campaign/450-cold-corpus-$when.sha256")" -eq 226
done
cmp work/campaign/450-cold-corpus-before.sha256 work/campaign/450-cold-corpus-after.sha256
cmp work/campaign/450-cold-before.sha256 work/campaign/450-cold-corpus-before.sha256
cd "$record"
"$root/work/campaign/summary450-wide" summary raw/paired-*.log > summary.tsv
"$root/work/campaign/summary450-wide" rows raw/paired-*.log > rows.tsv
test "$(wc -l < summary.tsv)" -eq 439
test "$(wc -l < rows.tsv)" -eq 4381
cd "$root"
bash work/campaign/public-logs.sh "$record"
printf 'Validated226unchangedidentityrows;2190independentprocesses;4380lanerows;438pairedsummaries.\n'
