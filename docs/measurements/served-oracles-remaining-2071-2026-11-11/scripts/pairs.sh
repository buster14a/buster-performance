#!/bin/bash
# Pairs each after run's converted commands (part 4 of test-preprocessor's cases and the repository's units) with the
# befores on the same row and CPU model: per command, row and CPU, the befores' count, mean, minimum and maximum wall
# seconds and their mean CPU seconds (the parallel runner's), then each after with the changes from those means. Reads results/hosted/{before,after}-*.tsv (hosted-times.sh's).
# Usage: pairs.sh RESULTS_HOSTED_DIRECTORY
set -euo pipefail
directory=$1
awk -F'\t' '
    function command(title) { return title ~ /part 4 of 4/ ? "part 4" : title ~ /translation units/ ? "units" : "" }
    function model(cpu) { sub(/ [0-9]+-Core Processor/, "", cpu); sub(/^AMD /, "", cpu); sub(/ CPU @.*/, "", cpu); sub(/^(Intel\(R\) Xeon\(R\) Platinum|INTEL\(R\) XEON\(R\) PLATINUM) /, "Xeon ", cpu); sub(/^Intel\(R\) Xeon\(R\) /, "Xeon ", cpu); return cpu }
    FNR == 1 { after = FILENAME ~ /after-/ }
    {
        c = command($5)
        if (c == "") next
        key = c "\t" $2 "\t" model($4)
        if (after) { afters[++count] = key "\t" $1 "\t" $6 "\t" $7 }
        else { n[key] += 1; sum[key] += $6; cpu_sum[key] += $7; if (!(key in low) || $6 < low[key]) low[key] = $6; if (!(key in high) || $6 > high[key]) high[key] = $6; runs[key] = runs[key] " " $1 }
    }
    END {
        print "befores: command\trow\tcpu\tcount\tmean\tmin\tmax\tmean CPU s"
        for (key in n) printf "%s\t%d\t%.1f\t%.1f\t%.1f\t%.1f\n", key, n[key], sum[key] / n[key], low[key], high[key], cpu_sum[key] / n[key] | "sort"
        close("sort")
        print "afters: command\trow\tcpu\trun\twall\tCPU s\tbefore wall mean (count)\twall change\tbefore CPU mean\tCPU change"
        for (i = 1; i <= count; i += 1)
        {
            split(afters[i], f, "\t")
            key = f[1] "\t" f[2] "\t" f[3]
            if (key in n) printf "%s\t%.1f (%d)\t%+.1f%%\t%.1f\t%+.1f%%\n", afters[i], sum[key] / n[key], n[key], 100 * (f[5] / (sum[key] / n[key]) - 1), cpu_sum[key] / n[key], 100 * (f[6] / (cpu_sum[key] / n[key]) - 1)
            else printf "%s\tnone\t\n", afters[i]
        }
    }
' "$directory"/before-*.tsv "$directory"/after-*.tsv
