#!/bin/bash
# tables.sh: the record's generated tables from its own raw files, run in the record's directory (the one that holds
# 9700x/ and scripts/): the three ladder runs as Markdown (tools/runs_table.py), the calibration and the prototype
# (tools/proto_table.py). tables/models.txt is not made here: its tools read callgrind's per-instruction rows and the
# disassemblies, which the record leaves out for their size (each tool's header has its inputs).
set -eu
mkdir -p tables
markdown()
{
    awk -F'\t' 'NR == 1 { print; next }
        NR == 2 { printf "|"; for (i = 1; i <= NF; i++) printf " %s |", $i; printf "\n|"; for (i = 1; i <= NF; i++) printf " %s |", (i == 1 ? "---" : "---:"); printf "\n"; next }
        { printf "|"; for (i = 1; i <= NF; i++) printf " %s |", $i; printf "\n" }'
}
for run in ladder-top ladder-bottom ladder-inline2; do
    python3 scripts/tools/runs_table.py "9700x/$run/runs.tsv" | markdown > "tables/$run.md"
done
# The calibration's runs have no program column (speedtest1 alone).
awk -F'\t' 'BEGIN { OFS = "\t" } { print $1, $2, "speedtest1", $3, $4, $5, $6, $7, $8, $9, $10 }' 9700x/exp/runs.tsv > tables/.calibration-runs.tsv
python3 scripts/tools/proto_table.py tables/.calibration-runs.tsv > tables/calibration.txt
rm -f tables/.calibration-runs.tsv
python3 scripts/tools/proto_table.py 9700x/proto/runs.tsv > tables/prototype.txt
# The compiler built by each compiler: medians by workload and build.
for runs in runs runs-ladder runs-proto; do
    [ -f "9700x/selfhost/$runs.tsv" ] || continue
    echo "## $runs"
    awk -F'\t' '$1 == "measured" { k = $3 "\t" $4; n[k]++; ms[k, n[k]] = $5; cy[k, n[k]] = $6; ins[k, n[k]] = $7 }
        function median(a, k, c,    i, j, t, v) { for (i = 1; i <= c; i++) v[i] = a[k, i]; for (i = 1; i <= c; i++) for (j = i + 1; j <= c; j++) if (v[j] < v[i]) { t = v[i]; v[i] = v[j]; v[j] = t }
            return c % 2 ? v[(c + 1) / 2] : (v[c / 2] + v[c / 2 + 1]) / 2 }
        END { for (k in n) printf "%s\truns %d\tms %.1f\tuser cycles M %.1f\tinstructions G %.2f\n", k, n[k], median(ms, k, n[k]), median(cy, k, n[k]) / 1e6, median(ins, k, n[k]) / 1e9 }' "9700x/selfhost/$runs.tsv" | sort
done > tables/selfhost.txt
