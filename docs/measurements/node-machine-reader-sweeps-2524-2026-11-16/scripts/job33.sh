#!/bin/bash
# job33.sh: which loads of C's and T's meet a store in flight more often in w2 than in u3? sweeps-annotate.sh on both,
# 40 passes, node_machine_contexts and node_machine_type (in w2 their Release part's names).
set -u
cd "$(dirname "$0")"
./sweeps-annotate.sh u3 plain 40 node_machine_contexts node_machine_type
./sweeps-annotate.sh w2 plain 40 node_machine_contexts node_machine_type node_machine_contexts.buster_split node_machine_type.buster_split
echo "job33 done $(date -u +%FT%TZ)" >> results/job33.log
