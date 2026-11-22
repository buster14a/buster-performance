#!/usr/bin/env bash
# identity.sh: identity.py over main's Release build (the #3130/#3143 record's, the same main commit and build
# settings), the PR's Release builds without and with the define, and main's with the define, under one hold of the
# lock; then each against main.
set -euo pipefail
. "$HOME/buster-fast-bench/3067-claude/env.sh"
cd "$W"
export W
sha256sum bin/main-release bin/off-release bin/on-release bin/main-on-release
"$LOCK" timeout -k 10 900 taskset -c 0-7 python3 -I "$W/identity.py" "$W/logs/identity" main=bin/main-release off=bin/off-release on=bin/on-release main-on=bin/main-on-release
for pair in main:off main:on main:main-on; do
    a=${pair%%:*}; b=${pair#*:}
    echo "== $a against $b"
    paste logs/identity/$a.tsv logs/identity/$b.tsv | awk -F'\t' 'NR > 1 { n[$1]++; if ($1 != $6 || $2 != $7) bad = 1; if ($3 != 0 || $8 != 0) failed[$1]++; if ($3 == $8 && $4 == $9) same[$1]++; else { diff[$1]++; print "DIFFERS", $1, $2, $3, $8 } } END { for (k in n) printf "%s: %d units, %d identical, %d differ, %d failed\n", k, n[k], same[k], diff[k], failed[k]; if (bad) print "ROW ORDER MISMATCH" }' | sort
done
touch identity.done
