#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/1383-struct-codex"
export EXCLUSIVE_OWNER=codex-1383-struct
export EXCLUSIVE_TITLE="Recover direction 3 of 1383: paired measurements"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1383
test -x bin/base
test -x bin/head
mkdir -p runs
if ! test -f results.tsv; then
    printf 'input\trevision\tround\twall_us\tmaxrss_kb\tminor_faults\tmajor_faults\tstatus\n' > results.tsv
fi
pids=()
keys=()
launch()
{
    local input=$1 revision=$2 round=$3
    if awk -F '\t' -v f="$input" -v v="$revision" -v r="$round" '$1==f && $2==v && $3==r {found=1} END {exit !found}' results.tsv; then
        return
    fi
    local key="$input.$revision.$round"
    "$HOME/buster-fast-bench/exclusive.sh" taskset -c 2 bash run-one.sh "$input" "$revision" "$round" "$key" > "runs/$key.log" 2>&1 &
    pids+=("$!")
    keys+=("$key")
    sleep 0.05
}
finish_batch()
{
    local failed=0
    for pid in "${pids[@]}"; do
        if ! wait "$pid"; then
            failed=1
        fi
    done
    for key in "${keys[@]}"; do
        test -f "runs/$key.tsv"
        cat "runs/$key.tsv" >> results.tsv
    done
    pids=()
    keys=()
    test "$failed" -eq 0
}
# Complete all missing warmups before enqueueing recorded runs.
for input in file250000.c local250000.c flat1000000.c float50000.c; do
    launch "$input" base 0
    launch "$input" head 0
done
finish_batch
# Each independent process has its own lock acquisition; no series holds the machine.
for input in file250000.c local250000.c flat1000000.c float50000.c; do
    for round in 1 2 3 4 5; do
        order="base head"
        if test $((round % 2)) -eq 1; then order="head base"; fi
        for revision in $order; do launch "$input" "$revision" "$round"; done
    done
done
finish_batch
"$HOME/buster-fast-bench/exclusive.sh" taskset -c 2 bash verify_objects.sh > object-comparison.log 2>&1
echo measurement-status=0
