#!/usr/bin/env bash
# collect.sh RUN: the vector sanitizer rows' tables from the run's vector draws' logs, into $S/costs-out.
set -euo pipefail
S=/tmp/claude-0/-home-user/5d6a3fea-9106-5ce4-ab13-13cbb66e8428/scratchpad/vector
run=$1
logs=$S/logs-$run
mkdir -p "$logs" "$S/costs-out"
$S/jobs.sh "$run" '.jobs[] | select(.name | test(" / Vector draw [0-9]+, candidate [0-9]+ \\(")) | select(any(.steps[]?; .name == "Run correctness tests within the hosted CPU budget" and (.conclusion == "success" or .conclusion == "failure"))) | .id' > "$logs/jobs.txt"
while IFS= read -r job; do
    [ -s "$logs/$job.log" ] || gh api "repos/buster14a/buster/actions/jobs/$job/logs" > "$logs/$job.log"
done < "$logs/jobs.txt"
wc -l < "$logs/jobs.txt"
cd /home/user/buster-wt/vector-sanitizers
$S/costs collect --tests tools/ci/correctness.tests --output "$S/costs-out" "$logs"/*.log
