#!/bin/bash
# Makes this record's logs from the raw ones (RAW/9700x, RAW/mutants): keeps only the lines its own scripts and tools
# print. exclusive.sh's waiting messages name the jobs that held the 9700X (their commands, titles and links), and the
# laptop's cores queue names other sessions, so both are left out.
set -eu
raw=$1
out=$2
keep() { grep -E "$1" "$2" > "$3" || true; }
for f in status.log status2.log; do keep '^[0-9]{2}:[0-9]{2}:[0-9]{2} ' "$raw/9700x/$f" "$out/9700x/$f"; done
for f in build-base.log build-head.log build-base2.log build-head2.log; do keep '^build\.sh: ' "$raw/9700x/$f" "$out/9700x/$f"; done
for f in times.log times2.log; do
    keep '^(base|head|base2|head2) test-[a-z-]+ [0-9.]+ s wall [0-9.]+ user [0-9.]+ sys$' "$raw/9700x/$f" "$out/9700x/$f"
done
for f in time-runs.log time-runs2.log; do
    keep '^(run [0-9]+ list [0-9]+ (base|head|main) copy [0-9]+: .*, status -?[0-9]+|list [0-9]+ (base|head|main) copy [0-9]+ \[.*\]: [0-9]+ runs, median .*|list [0-9]+, (wall time \(ms\)|user cycles \(millions\)):|  (base|head|main): [0-9]+ runs, median .*|time-runs: done, [0-9]+ failed processes)$' "$raw/9700x/$f" "$out/9700x/$f"
done
keep '^(cores: #[0-9]+ granted .*|mutant [12] .*|test-check-lanes: FAIL: .*)$' "$raw/mutants/mutants.log" "$out/mutants/mutants.log"
