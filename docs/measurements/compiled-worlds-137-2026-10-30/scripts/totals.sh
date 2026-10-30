#!/bin/bash
# Sums the cross-check's runs over sweep logs: per run kind (clang and GCC's record runs, the compiled runs against clang
# and against GCC, the extension runs), signatures, arguments, checks and failures, and the seeds whose command failed.
# Usage: totals.sh LOG...
awk '
    /^cross-check +(clang|gcc|compiled clang|compiled gcc), [0-9]+-byte vectors: [0-9]+ signatures/ {
        line = $0
        sub(/^cross-check +/, "", line)
        kind = line
        sub(/, [0-9]+-byte vectors:.*$/, "", kind)
        n = split(line, w, " ")
        for (i = 1; i <= n; i += 1) {
            if (w[i] == "signatures,") signatures[kind] += w[i - 1]
            if (w[i] == "arguments,") arguments[kind] += w[i - 1]
            if (w[i] == "checks") checks[kind] += w[i + 1]
            if (w[i] == "failures") failures[kind] += w[i + 1]
        }
        runs[kind] += 1
    }
    /^cross-check +extension, / {
        n = split($0, w, " ")
        for (i = 1; i <= n; i += 1) {
            if (w[i] == "checks") checks["extension"] += w[i + 1]
            if (w[i] == "failures") failures["extension"] += w[i + 1]
        }
        runs["extension"] += 1
    }
    /^test-calling-convention:/ { bad += 1 }
    END {
        for (k in runs) printf "%s: %d runs, %d signatures, %d arguments, %d checks, %d failures\n", k, runs[k], signatures[k], arguments[k], checks[k], failures[k]
        printf "failing commands: %d\n", bad
    }
' "$@"
