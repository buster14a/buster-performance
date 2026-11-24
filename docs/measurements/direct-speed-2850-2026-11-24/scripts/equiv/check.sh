#!/bin/bash
# check.sh [NAME]: the checkout's build/compiler over the corpus against base.tsv; prints the differing rows.
set -uo pipefail
name=${1:-cand}
cd /home/user/dp/equiv
./run.sh /home/user/buster/build/compiler "$name.tsv" > "$name.summary" 2>&1
if cmp -s base.tsv "$name.tsv"; then echo "EQUIVALENT: $(wc -l < "$name.tsv") units, $(awk -F'\t' '$6=="direct"' "$name.tsv" | wc -l) direct"; else echo "DIFFERENT:"; diff base.tsv "$name.tsv" | head -40; diff base.tsv "$name.tsv" | grep -c '^>' ; fi
