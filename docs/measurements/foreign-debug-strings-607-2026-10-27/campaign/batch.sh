#!/usr/bin/env bash
# One bounded campaign invocation; release the host after ~90 s of useful work.
set -euo pipefail
cd "$(dirname "$0")/.."
start=$SECONDS
if [[ ! -f results/inputs.sha256 ]]; then
    bash campaign/setup.sh > setup.log 2>&1
fi
if [[ ! -f results/driver-patch.sha256 ]] || ! sha256sum -c --status results/driver-patch.sha256; then
    bash campaign/build-drivers.sh > build-drivers.log 2>&1
fi
if [[ ! -f results/offsets/DONE ]]; then
    bash campaign/offsets.sh
    touch results/offsets/DONE
fi
for case_name in duplicate-10 duplicate-100 duplicate-1000 unique-10 unique-100 unique-1000 dwarf64-10 real; do
    for compression in plain zlib; do
        [[ ! -e STOP ]] || exit 0
        [[ ! -e "results/$case_name-$compression/DONE" ]] || continue
        [[ ! -e "results/$case_name-$compression/FAILED" ]] || continue
        (( SECONDS - start < 90 )) || exit 0
        if bash campaign/case.sh "$case_name" "$compression" 11; then
            touch "results/$case_name-$compression/DONE"
        else
            printf '%s-%s FAILED\n' "$case_name" "$compression"
            touch "results/$case_name-$compression/FAILED"
        fi
    done
done
for marker in results/*/FAILED; do
    [[ ! -f "$marker" ]] || exit 1
done
clang -O2 -Wall -Wextra -Werror campaign/summarize.c -o campaign/summarize
campaign/summarize > results/summary.tsv
sha256sum campaign/*.c campaign/*.sh campaign/*.patch > results/harness.sha256
touch COMPLETE
