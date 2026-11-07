#!/bin/bash
# #1555's repeat, the profiles again at half the sampling rate: at -c 997 perf throttled (the host's
# perf_event_max_sample_rate is 63300; 19 throttle events per run) and sampled about half the events. Each run is one
# run of one.sh, which takes the host's lock for that run alone.
set -u
root=$HOME/buster-fast-bench/1555-claude-r2
run=$root/run
one=$root/one.sh
cd "$run" || exit 2
export LC_ALL=C LC_NUMERIC=C SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
source "$root/trees/main/tools/microarch/workloads.sh"
SCRATCH=scratch
echo "$(date -Is) step: profiles at -c 1997" >> "$root/runs/steps"
for v in main lexer refine; do
    workload "$v" sq-c
    n=profile1997-$v
    "$one" $n -- perf record -q -e ls_misal_loads.ma64:u -c 1997 -o "$root/runs/$n/perf.data" taskset -c 2 "${WL[@]}"
    "$one" report1997-$v -- bash -c "perf report -i $root/runs/$n/perf.data --stats | grep -E 'SAMPLE events|THROTTLE|LOST' ; perf report -i $root/runs/$n/perf.data --stdio --no-children --sort symbol"
done
echo "$(date -Is) step: done (profiles at -c 1997)" >> "$root/runs/steps"
