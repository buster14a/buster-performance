#!/bin/bash
# #113's first lane, campaign 1: the three ways to take the parts (variants: --take first, race, ends) on every lane the
# bodies can take (--every-lane), on 2, 3, 4 and 8 lanes (first) or 2 and 8 (race and ends), three rounds of the jobs in
# jobs1.txt, a lock hold per batch of about 11 jobs (batch.sh), 30 s apart.
D=~/buster-fast-bench/deferred-first-claude
cd "$D" || exit 1
export EXCLUSIVE_OWNER=claude-deferred-first
export EXCLUSIVE_TITLE="#113 deferred reader: the first lane reads the costliest part (campaign 1, takes and grid)"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/113#issuecomment-6404376681"
L="$D/log1.txt"
: > "$L"
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
total=$(wc -l < "$D/jobs1.txt")
for round in 1 2 3; do
    for ((first = 0; first < total; first += 11)); do
        ~/buster-fast-bench/exclusive.sh "$D/batch.sh" "$L" "$round" "$D/jobs1.txt" "$first" 11 > /dev/null 2>> "$D/queue1.lock.txt"
        sleep 30
    done
done
echo done >> "$L"
