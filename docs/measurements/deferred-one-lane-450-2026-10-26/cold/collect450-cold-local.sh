#!/bin/bash
set -euo pipefail
root=/home/david/Documents/Codex/2026-10-26/claim-and-solve-three-buster-performance
cd "$root"
record=work/performance/docs/measurements/deferred-one-lane-450-2026-10-26/cold
test -s work/campaign/450-cold-raw.tar
mkdir -p work/campaign/cold450 "$record/raw" "$record/acceptance" "$record/local-validation"
tar -xf work/campaign/450-cold-raw.tar --exclude=base450-cold/build/compiler --exclude=head450-cold/build/compiler -C work/campaign/cold450
cp -a work/campaign/cold450/logs/450-cold/. "$record/raw/"
cp -a work/campaign/cold450/logs/450-cold-acceptance/. "$record/acceptance/"
for script in group450-cold.sh batch450-cold.sh provenance450-cold.sh accept450-cold.sh queue450-cold.sh collect450-cold.sh build450-cold.sh build450-cold-base.sh; do
    cp "work/campaign/cold450/$script" "$record/"
done
cp work/campaign/prepare450-cold-base.log "$record/native-baseline-preparation.log"
cp work/campaign/prepare450-cold-head.log "$record/native-candidate-preparation.log"
for log in 450-cold-direct-object 450-cold-distinct-build 450-cold-distinct-sanitize-build 450-cold-distinct-deferred-test 450-cold-distinct-call-graph; do
    cp "work/issue450/.git/$log.log" "$record/local-validation/"
done
cp work/issue450/.git/450-cold-distinct-call-graph.trace "$record/local-validation/"
cp work/issue450/.git/450-cold-validation.md "$record/local-validation/README.md"
cp work/issue450/.git/cold-sanitize-entry.c work/issue450/.git/450-cold-harness.patch "$record/local-validation/"
for when in before after; do
    sed -n '/^[[:xdigit:]]\{64\}  /p' "$record/acceptance/provenance-$when.log" > "work/campaign/450-cold-$when.sha256"
    test "$(wc -l < "work/campaign/450-cold-$when.sha256")" -eq 226
done
cmp work/campaign/450-cold-before.sha256 work/campaign/450-cold-after.sha256
cd "$record"
"$root/work/issue450/.git/summary450" summary raw/paired-*.log raw/sweep-*.log > summary.tsv
"$root/work/issue450/.git/summary450" rows raw/paired-*.log raw/sweep-*.log > rows.tsv
test "$(wc -l < summary.tsv)" -eq 465
test "$(wc -l < rows.tsv)" -eq 1137
cd "$root"
bash work/campaign/public-logs.sh "$record"
for tree in base450-cold head450-cold; do
    mkdir -p "work/campaign/native-images/$tree/build"
    tar -xOf work/campaign/450-cold-raw.tar "$tree/build/compiler" > "work/campaign/native-images/$tree/build/compiler"
    chmod 444 "work/campaign/native-images/$tree/build/compiler"
    sha256sum "work/campaign/native-images/$tree/build/compiler"
done
printf 'Validated 226 unchanged hashes; 568 deferred processes; 1136 lane rows; 464 summary rows.\n'
