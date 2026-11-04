#!/usr/bin/env bash
# branches.sh SHOW.txt FILE FIRST LAST: the branch counts llvm-cov show --show-branches=count gives FILE's lines FIRST to
# LAST, one line per instantiation of the file (sum them, as the record's counts do).
gawk -v file="$2" -v first="$3" -v last="$4" '
    /^\/.*:$/ { current = $0; next }
    index(current, file ":") == 0 { next }
    /Branch \(/ { match($0, /Branch \(([0-9]+):([0-9]+)\): \[True: ([0-9.kM]+), False: ([0-9.kM]+)\]/, m); if (m[1] >= first && m[1] <= last) print m[1] ":" m[2], "T=" m[3], "F=" m[4] }
' "$1"
