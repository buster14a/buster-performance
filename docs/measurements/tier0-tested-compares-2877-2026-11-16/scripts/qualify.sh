#!/bin/bash
# qualify.sh LABEL: the self-host qualification (tools/ci/selfhost.c, as .github/workflows/selfhost.yml runs it) of
# trees/LABEL's sources by results/LABEL/compiler: every unit compiled by it and linked, the smoke commands run by the
# result, and the probes compiled by both and compared. One hold of the lock. results/LABEL/qualify.log, and the
# qualification's summary and timings in results/LABEL/qualify/.
set -u
cd "$(dirname "$0")"
label=$1
out=$PWD/results/$label
tree=$PWD/trees/$label
rm -rf "$out/qualify" "$out/qualify-work"
mkdir -p "$out/qualify-work"
./lock.sh bash -c "
    head -1 /var/lib/buster-9700x/owner | cut -c1-200
    cd $tree && ./build.sh print-sources > $out/qualify-work/sources.argv && BUSTER_DEBUG_INFO=0 ./build.sh print-compile-flags --config Release > $out/qualify-work/flags.argv &&
    clang -std=c17 -O2 -Wall -Wextra -Werror -fno-strict-aliasing tools/ci/selfhost.c -o $out/qualify-work/qualify &&
    $out/qualify-work/qualify $out/compiler $out/qualify-work/sources.argv $out/qualify-work/flags.argv $out/qualify-work/result 900" > "$out/qualify.log" 2>&1
echo "status $?" >> "$out/qualify.log"
mkdir -p "$out/qualify"
cp "$out/qualify-work/result/summary.md" "$out/qualify-work/result/timings.tsv" "$out/qualify-work/result/PASS" "$out/qualify/" 2>/dev/null
rm -rf "$out/qualify-work"
test -s "$out/qualify/PASS" && echo passed || echo "not passed"
tail -3 "$out/qualify.log"
