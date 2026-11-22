#!/usr/bin/env bash
# identity.sh: identity.py over the three Release builds under one hold of the lock, then the pairs compared.
set -euo pipefail
. "$HOME/buster-fast-bench/3130-claude/env.sh"
cd "$W"
export W
"$LOCK" timeout -k 10 900 python3 -I "$W/identity.py" "$W/logs/identity" main=bin/main-release pr3130=bin/3130-release pr3143=bin/3143-release
for pair in main:pr3130 pr3130:pr3143; do
    a=${pair%%:*}; b=${pair#*:}
    echo "== $a against $b"
    paste logs/identity/$a.tsv logs/identity/$b.tsv | awk -F'\t' 'NR > 1 { n[$1]++; if ($2 != $7) bad = 1; if ($3 == $8 && $4 == $9) same[$1]++; else { diff[$1]++; print "DIFFERS", $1, $2, $3, $8 } } END { for (k in n) printf "%s: %d units, %d identical, %d differ\n", k, n[k], same[k], diff[k]; if (bad) print "ROW ORDER MISMATCH" }' | sort
done
