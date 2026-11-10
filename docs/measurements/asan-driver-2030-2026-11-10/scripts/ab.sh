#!/bin/bash
# Part 1/16 by the base (PIE) and the fixed-address builds at the same time on two cores of one cores grant, without
# transparent huge pages (as on Ubuntu's runners), ROUNDS rounds: each pair sees the same load.
set -u
D=$HOME/.cache/claude-pr2056-review/2030
rounds=${1:-2}
read -r -a cpus <<< "$(echo "${CORES_CPUS:-2,3}" | tr ',' ' ')"
for ((round = 1; round <= rounds; round++)); do
    taskset -c "${cpus[0]}" "$D/driver.sh" "ab$round-base" "$D/compiler-asan" 1/16 "" "" nothp &
    taskset -c "${cpus[2]:-${cpus[1]}}" "$D/driver.sh" "ab$round-fixed" "$D/compiler-fixed" 1/16 "" "" nothp &
    wait
done
grep '^ab[0-9]-' "$D/driver.txt" | cut -c1-80
