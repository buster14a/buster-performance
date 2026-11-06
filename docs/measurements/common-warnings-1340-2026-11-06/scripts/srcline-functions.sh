#!/bin/bash
# srcline-functions.sh SOURCE SRCLINE: check_driver_common_warnings' per-line samples (srcline.sh's output) summed by
# the function of c_check_common_warnings.c (at the measured commit) whose definition starts at or above each line;
# lines of other files are summed by file. SOURCE: git show 9fa45bbb:src/buster/compiler/c_check_common_warnings.c
awk 'NR == FNR {
        if ($0 ~ /^(static |inline |void |bool |uint|int |Check|BUSTER_)[^;]*\(/ && $0 !~ /;[[:space:]]*$/) {
            n = $0; sub(/\(.*/, "", n); k = split(n, a, /[ *]+/); start[++c] = FNR; name[c] = a[k]
        }
        next
    }
    {
        s = $1; split($2, f, ":"); total += s
        if (f[1] != "c_check_common_warnings.c") { by["file:" f[1]] += s; next }
        l = f[2] + 0
        if (l == 0) { by["(line 0)"] += s; next }
        fn = "?"
        for (i = c; i >= 1; i--) if (start[i] <= l) { fn = name[i]; break }
        by[fn] += s
    }
    END { for (k in by) printf "%d\t%.1f\t%s\n", by[k], 100 * by[k] / total, k; printf "%d\t100.0\ttotal\n", total }' "$1" "$2" | sort -t$'\t' -k1,1nr
