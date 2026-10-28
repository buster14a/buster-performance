#!/bin/bash
# One lock hold's jobs (exclusive.sh runs this): jobs FIRST to FIRST + COUNT - 1 of JOBS in ROUND's order, which starts
# 7 jobs further on each round, each job's runs in an order that starts one run further on each round. A job is a line
# UNIT PASSES RUN..., UNIT a path under the work directory or `sqlite` (the frozen corpus's sqlite3.c). Arguments: LOG
# ROUND JOBS FIRST COUNT.
D=~/buster-fast-bench/deferred-first-claude
L="$1"
round="$2"
jobs="$3"
first="$4"
count="$5"
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
mapfile -t lines < "$jobs"
total=${#lines[@]}
for ((i = first; i < first + count && i < total; i += 1)); do
    read -r -a job <<< "${lines[$(((i + (round - 1) * 7) % total))]}"
    unit="${job[0]}"
    passes="${job[1]}"
    runs=("${job[@]:2}")
    n=${#runs[@]}
    ordered=()
    for ((k = 0; k < n; k += 1)); do
        ordered+=("${runs[$(((k + round) % n))]}")
    done
    file="$D/$unit"
    if [ "$unit" = sqlite ]; then
        file="$corpus/sqlite/sqlite3.c"
    fi
    "$D/runs.sh" "$L" "$round" "$unit" "$file" "$passes" "${ordered[@]}"
done
