#!/bin/bash
set -euo pipefail
root=/home/david/Documents/Codex/2026-10-26/claim-and-solve-three-buster-performance
cd "$root"
record=work/performance/docs/measurements/deferred-one-lane-450-2026-10-26
test -s work/campaign/450-check-raw.tar
mkdir -p work/campaign/check450 "$record/affinity/raw" "$record/affinity/acceptance" "$record/affinity/local-validation"
tar -xf work/campaign/450-check-raw.tar --exclude=head450-check/build/compiler -C work/campaign/check450
cp -a work/campaign/check450/logs/450-check/. "$record/affinity/raw/"
cp -a work/campaign/check450/logs/450-check-acceptance/. "$record/affinity/acceptance/"
for script in group450-check.sh batch450-check.sh provenance450-check.sh queue450-check.sh build450-check.sh lanes450-check.sh; do
    cp "work/campaign/check450/$script" "$record/affinity/"
done
cp work/campaign/run450-check.log "$record/affinity/native-preparation.log"
for log in build lanes-test deferred-test call-graph; do
    cp "work/issue450/.git/450-affinity-final-$log.log" "$record/affinity/local-validation/"
done
cp work/issue450/.git/450-affinity-final-call-graph.trace "$record/affinity/local-validation/"
cp work/issue450/.git/450-affinity-final-validation.md "$record/affinity/local-validation/README.md"
cp work/issue450/.git/affinity-sanitize-entry.c "$record/affinity/local-validation/"
cp work/issue450/.git/450-integration-audit.md "$record/affinity/local-validation/integration-audit.md"
for when in before after; do
    sed -n '/^[[:xdigit:]]\{64\}  /p' "$record/affinity/acceptance/provenance-$when.log" > "work/campaign/450-check-$when.sha256"
    test "$(wc -l < "work/campaign/450-check-$when.sha256")" -eq 226
done
cmp work/campaign/450-check-before.sha256 work/campaign/450-check-after.sha256
cd "$record/affinity"
"$root/work/issue450/.git/summary450" summary raw/paired-*.log raw/sweep-*.log > summary.tsv
"$root/work/issue450/.git/summary450" rows raw/paired-*.log raw/sweep-*.log > rows.tsv
test "$(wc -l < summary.tsv)" -eq 461
test "$(wc -l < rows.tsv)" -eq 1097
cd "$root"
bash work/campaign/public-logs.sh "$record/affinity"
printf 'Validated 226 unchanged hashes; 548 deferred processes; 1096 lane rows; 460 summary rows.\n'
