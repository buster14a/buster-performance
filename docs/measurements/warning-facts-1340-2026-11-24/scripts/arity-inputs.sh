#!/usr/bin/env bash
set -eu
for n in 256 1024 4096 8192; do
    awk -v n="$n" 'BEGIN {
        printf "void sink("
        for (i=1; i<=n; i++) printf "%sfloat", i==1 ? "" : ","
        print ");"
        print "void probe(void) { sink("
        for (i=1; i<n; i++) print "1,"
        print "16777217); }"
    }' >"1340-args-$n.c"
done
