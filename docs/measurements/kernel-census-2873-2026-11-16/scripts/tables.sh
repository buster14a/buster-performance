#!/bin/bash
# tables.sh RESULTS OUT: every table of the record from the raw results (RESULTS: raw/results), with the reducers
# in scripts/tools built first (cc -O2). The CPU-wide recordings in the record are trimmed (scripts/trim.sh); the
# record's tables were made from them before trimming, where the rows "outside the compile: other tasks" are not empty.
set -eu
results=$1
out=$2
here=$(cd "$(dirname "$0")" && pwd)
mkdir -p "$out"
for tool in kcensus mapnames kowners krows; do
    cc -O2 -Wall -o "$out/$tool" "$here/tools/$tool.c"
done
# The mappings' names: mapnames on the strace, each owner's frames from llvm-symbolizer (raw/results/maps), the sites.
"$out/mapnames" "$results/maps/strace.txt" > "$out/names.txt"
"$here/label.sh" "$out/names.txt" "$results/maps/owners-table.txt" "$here/sites.txt" 2101248 > "$out/labels.txt"
reduce()
{
    local directory=$1
    local name=$2
    local regular=()
    local busy=()
    for stages in "$directory"/stages-*.txt; do
        local n=${stages##*/stages-}
        n=${n%.txt}
        local script="$out/$name-script-$n.txt"
        zcat "$directory/script-$n.txt.gz" > "$script"
        if grep -q -P '^time-process\thuge-pages\tsystem$' "$stages"; then
            regular+=("$stages" "$script")
        else
            busy+=("$stages" "$script")
        fi
    done
    "$out/kcensus" --names "$out/labels.txt" --fills "$results/memsets/memsets.txt" "$out/$name" "${regular[@]}"
    if ((${#busy[@]} != 0)); then
        "$out/kcensus" --names "$out/labels.txt" --fills "$results/memsets/memsets.txt" "$out/$name-busy" "${busy[@]}"
    fi
    rm -f "$out/$name"-script-*.txt
}
reduce "$results/cpuwide" cpuwide
reduce "$results/kernel" task
reduce "$results/reads" reads
"$out/kowners" "$out/cpuwide-fault-mappings.tsv" "$out/reads-ops.tsv" > "$out/owners.tsv"
# The scale: the compile's kernel cycles counted on CPU 2 unrecorded (cputotals: the compile under the harness, less the
# harness with /usr/bin/true in its place, plus true's own process by its task counters, procbench), over the recorded
# compile's own.
own=$("$out/krows" "$out/cpuwide-causes.tsv" 1 716136 | tail -1 | cut -f2)
scale=$(echo "scale=6; (87.229 - 0.949 + 0.230) / $own" | bc)
"$out/krows" "$out/cpuwide-causes.tsv" "$scale" 716136 > "$out/rows.tsv"
echo "scale $scale" >> "$out/rows.tsv"
gzip -9f "$out"/*-samples.tsv "$out"/*-faults.tsv
rm -f "$out/kcensus" "$out/mapnames" "$out/kowners" "$out/krows"
