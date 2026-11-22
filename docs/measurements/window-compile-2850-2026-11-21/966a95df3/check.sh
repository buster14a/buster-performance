#!/bin/bash
set -eu
cd "$(dirname "$0")"
for unit in sqlite main; do
 BUSTER_SOURCE_VERIFY_CHILDREN=1 BUSTER_SOURCE_CURSOR_ORACLE=1 BUSTER_SOURCE_DIRTY_ORACLE=1 BUSTER_SOURCE_CLASS_ORACLE=1 BUSTER_SOURCE_FILE_AUDIT=1 BUSTER_SOURCE_RESIDENCY_AUDIT=1 BUSTER_CONTROL_EARLY_AUDIT=1 bash real.sh "$unit" fused
 BUSTER_SOURCE_POISON_COLUMNS=1 BUSTER_CONTROL_EARLY_POISON=1 bash real.sh "$unit" poison
done
python3 edges.py > edges.log
bash runtime.sh > runtime.log
bash policy.sh sqlite main lua musl >policies.log
