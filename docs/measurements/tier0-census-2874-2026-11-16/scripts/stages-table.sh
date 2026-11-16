#!/bin/bash
# stages-table.sh LABEL: the stage clock's runs (stages.sh, results/LABEL/stages-N.txt) as a table: each stage's median,
# least and greatest milliseconds over the runs, and the row's stages' sum (from Tier 0 to the object's write) in
# milliseconds and, by perf stat's cycles a millisecond of the same compile (stat-sqlite3.txt: user and kernel cycles
# over the task's clock), in cycles a token. No lock: it reads files. results/LABEL/tables/stages.txt.
set -u
cd "$(dirname "$0")"
# The record keeps scripts/ beside results/; on the 9700X the scripts are in the directory that holds results/.
[ -d results ] || cd ..
label=$1
out=results/$label
tokens=$(awk '$1 == "time-process" && $2 == "tokens" { print $3; exit }' "$out/stages-1.txt")
rate=$(awk -F, '$3 == "cycles:u" { u = $1 } $3 == "cycles:k" { k = $1 } $3 == "task-clock" { ms = $1 } END { printf "%.1f", (u + k) / ms }' "$out/stat-sqlite3.txt")
{
    echo "stage median-ms least greatest runs"
    for stage in setup preprocess parse type-table check-input check-expressions check-declarations static-data check-program select lower tier0 emit-setup branch-sizing encode unwind code-atoms debug publish-data object-build object-write release total; do
        for f in "$out"/stages-[0-9]*.txt; do awk -v s="$stage" '$1 == "time-stage" && $2 == s { print $3 }' "$f"; done | sort -g |
            awk -v s="$stage" '{ v[NR] = $1 } END { if (NR) printf "%s %.3f %.3f %.3f %d\n", s, NR % 2 ? v[(NR + 1) / 2] : (v[NR / 2] + v[NR / 2 + 1]) / 2, v[1], v[NR], NR }'
    done
} > "$out/tables/stages.txt"
awk -v tokens="$tokens" -v rate="$rate" '
    $1 ~ /^(tier0|emit-setup|branch-sizing|encode|unwind|code-atoms|publish-data|object-build|object-write)$/ { row += $2 }
    $1 == "total" { total = $2 }
    END {
        printf "the row (tier0 to object-write) %.3f ms of %.3f; at %.1f cycles a ms (perf stat: user and kernel cycles over the task clock) %.2f M cycles, %.1f a token of %d\n", row, total, rate, row * rate / 1e6, row * rate / tokens, tokens
    }' "$out/tables/stages.txt" >> "$out/tables/stages.txt"
cat "$out/tables/stages.txt"
