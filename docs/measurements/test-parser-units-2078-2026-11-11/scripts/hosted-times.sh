#!/bin/bash
# Prints, for each hosted run id given and each of its successful plain shards, the row, shard and runner CPU with: a
# `shard` line (the shard's total and its longest command) and a `parser` line for each test-parser command, from the
# parallel runner's report ("TITLE: passed in WALL s, CPU s of CPU"). Needs curl and jq. Logs are cached in $CACHE (default ./hosted-cache). GITHUB_TOKEN, if set,
# authenticates the requests.
set -euo pipefail
API=https://api.github.com/repos/buster14a/buster/actions
CACHE=${CACHE:-./hosted-cache}
mkdir -p "$CACHE"
fetch() {
    if [ ! -s "$2" ]; then
        curl -sSL ${GITHUB_TOKEN:+-H "Authorization: Bearer $GITHUB_TOKEN"} -o "$2" "$1"
    fi
}
printf 'kind\trun\trow\tshard\tcpu\twall_s\tcpu_s\tcommand\n'
for run in "$@"; do
    fetch "$API/runs/$run/jobs?per_page=100" "$CACHE/run-$run.json"
    # Each job as "id<TAB>conclusion<TAB>name".
    jq -r '.jobs[] | "\(.id)\t\(.conclusion)\t\(.name)"' "$CACHE/run-$run.json" |
    while IFS=$'\t' read -r id conclusion name; do
        case "$name" in *"Clang 23, "*", none, O3, shard "*) ;; *) continue ;; esac
        [ "$conclusion" = success ] || continue
        row=$(sed 's/.*Clang 23, \([a-z0-9-]*\), none.*/\1/' <<< "$name")
        shard=$(sed 's/.*shard \([0-9]\) of 4.*/\1/' <<< "$name")
        fetch "$API/jobs/$id/logs" "$CACHE/$id.log"
        cpu=$(sed -n 's/^[0-9T:.-]*Z model name[[:space:]]*: //p' "$CACHE/$id.log" | head -1 | tr -d '\r')
        total=$(sed -n 's/.*parallel: [0-9]* commands in \([0-9.]*\) s.*/\1/p' "$CACHE/$id.log" | head -1)
        longest=$(sed -n 's/.*##\[group\]\(.*\): passed in \([0-9.]*\) s.*/\2\t\1/p' "$CACHE/$id.log" | sort -t$'\t' -k1,1 -g | tail -1)
        printf 'shard\t%s\t%s\t%s\t%s\t%s\t\tlongest %s s: %s\n' "$run" "$row" "$shard" "$cpu" "$total" "${longest%%$'\t'*}" "${longest#*$'\t'}"
        sed -n 's/.*##\[group\]\(Test the parser[^:]*\): passed in \([0-9.]*\) s, \([0-9.]*\) s of CPU.*/\2\t\3\t\1/p' "$CACHE/$id.log" |
        while IFS=$'\t' read -r wall cpu_s title; do
            printf 'parser\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "$run" "$row" "$shard" "$cpu" "$wall" "$cpu_s" "$title"
        done
    done
done
