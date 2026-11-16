#!/bin/bash
# tables.sh RESULTS OUT: the record's tables from its raw results (RESULTS: raw/results/musl), with the reducers in
# scripts/tools built first (cc -O2). The rows' scale is an unrecorded pass's kernel cycles on CPU 2 over the recorded
# ones (less perf's own and the stage clock's), for each mode.
set -eu
results=$1
out=$2
here=$(cd "$(dirname "$0")" && pwd)
mkdir -p "$out"
for tool in kcensus kowners krows; do
    cc -O2 -Wall -o "$out/$tool" "$here/tools/$tool.c"
done
zcat "$results/script-0.txt.gz" | "$out/kcensus" --units "$out/musl" -
zcat "$results/script-command-1.txt.gz" | "$out/kcensus" --units "$out/musl-command" -
"$out/kowners" "$out/musl-fault-mappings.tsv" - "$here/reservation-labels.tsv" > "$out/musl-owners.tsv"
# The one command's reservations come in another order (its lane's pool, more of them): they keep their numbers.
"$out/kowners" "$out/musl-command-fault-mappings.tsv" - > "$out/musl-command-owners.tsv"
units=$(awk -F'\t' 'NR > 1 {n += 1; t += $4} END {print n, t}' "$results/tokens.tsv")
count=${units% *}
tokens=${units#* }
# What the recording sampled on CPU 2 a compile, less perf's own and the stage clock's (kcensus's summary).
recorded()
{
    awk -F'\t' '$1 == "sampled kernel cycles a compile" {s = $2} $1 == "perf'"'"'s own a compile" {p = $2}
        $1 == "the stage clock'"'"'s own a compile" {c = $2} END {printf "%.0f", s - p - c}' "$1"
}
# The unrecorded passes: the units a process each (musl-faults.sh's two clean passes, their mean), the one command
# (musl-totals.sh's three rounds, their median).
units_cpu=$(grep -h ',cycles:k,' "$results"/faults-[01].csv | cut -d, -f1 | awk '{s += $1; n += 1} END {printf "%.0f", s / n}')
command_cpu=$(grep -h ',cycles:k,' "$results"/totals-*-command-*.csv | cut -d, -f1 | sort -n | sed -n 2p)
units_scale=$(echo "scale=6; $units_cpu / ($(recorded "$out/musl-summary.txt") * $count)" | bc)
command_scale=$(echo "scale=6; $command_cpu / $(recorded "$out/musl-command-summary.txt")" | bc)
"$out/krows" "$out/musl-causes.tsv" "$units_scale" "$(echo "scale=6; $tokens / $count" | bc)" > "$out/musl-rows.tsv"
echo "scale $units_scale; units $count; tokens $tokens; unrecorded kernel cycles on CPU 2 $units_cpu" >> "$out/musl-rows.tsv"
"$out/krows" "$out/musl-command-causes.tsv" "$command_scale" "$tokens" > "$out/musl-command-rows.tsv"
echo "scale $command_scale; tokens $tokens; unrecorded kernel cycles on CPU 2 $command_cpu" >> "$out/musl-command-rows.tsv"
gzip -9f "$out"/*-samples.tsv "$out"/*-faults.tsv "$out"/*-mappings.tsv
rm -f "$out/kcensus" "$out/kowners" "$out/krows"
