#!/usr/bin/env bash
# jobs.sh RUN [JQ]: every job of the run's latest attempt, page by page (the proxy refuses the API's own next links).
run=$1
filter=${2:-'.jobs[] | "\(.id)\t\(.status)\t\(.conclusion)\t\(.started_at)\t\(.completed_at)\t\(.name)"'}
for page in 1 2 3 4 5 6; do
    out=$(gh api "repos/buster14a/buster/actions/runs/$run/jobs?per_page=100&page=$page" --jq "$filter") || exit 1
    [ -n "$out" ] || break
    printf '%s\n' "$out"
done
