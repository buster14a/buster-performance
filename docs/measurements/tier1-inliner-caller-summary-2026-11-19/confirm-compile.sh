#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
project=$1
rounds=$2
shift 2
export MEASUREMENT_TITLE="Tier 1 $project compiler throughput"
case "$project" in
 lea) export MEASUREMENT_LINK=https://github.com/buster14a/buster/pull/3117;;
 inline) export MEASUREMENT_LINK=https://github.com/buster14a/buster/pull/3119;;
 *) exit 2;;
esac
workloads=("$@")
for ((round=0; round<=rounds; ++round)); do
  for ((pos=0; pos<${#workloads[@]}; ++pos)); do
    workload=${workloads[(pos+round)%${#workloads[@]}]}
    variants=(base head)
    if (( (round+pos)%2 )); then variants=(head base); fi
    for v in "${variants[@]}"; do
      label="$project-$round-$v-$workload"
      if [[ -s results/$label.stat ]]; then continue; fi
      ./when-free.sh timeout -k 2 15 ./compile-one.sh "$label" "$project-$v" "$workload"
      sleep 2.5
    done
  done
done
