#!/bin/bash
# All 16 parts of test-checker-driver under CI's options, 6 at a time, by COMPILER: the parts' summed wall time and
# CPU, and each part's line in driver16-LABEL.txt. driver16.sh LABEL COMPILER [nothp]
set -u
export LC_ALL=C
label=$1; compiler=$2; thp=${3:-}
D=$HOME/.cache/claude-pr2056-review/2030
: > "$D/driver16-$label.txt"
TIMEFORMAT='%R %U %S'
{ time seq 1 16 | xargs -P 6 -I{} "$D/driver.sh" "d16-$label-{}" "$compiler" "{}/16" "" "" "$thp"; } 2> "$D/driver16-$label.time"
grep "^d16-$label-" "$D/driver.txt" > "$D/driver16-$label.txt"
awk -v label="$label" -v total="$(cat "$D/driver16-$label.time")" '
    { split($0, f, " "); wall += f[4]; user += f[5]; sys += f[6]; if ($3 != "rc=0") failed += 1; n += 1 }
    END { printf "%s: %d parts, %d failed, summed wall %.1f s, user %.1f s, sys %.1f s; all parts %s (wall user sys)\n", label, n, failed, wall, user, sys, total }' \
    "$D/driver16-$label.txt" | tee -a "$D/driver16.txt"
