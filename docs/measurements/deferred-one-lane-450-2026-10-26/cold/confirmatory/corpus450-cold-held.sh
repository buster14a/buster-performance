#!/bin/bash
set -euo pipefail
cd /home/david/buster-fast-bench/codex-449-450-451-20261026
test "${BUSTER_9700X_HELD:-}" = 1
mkdir -p logs/450-cold-corpus
test ! -e logs/450-cold-corpus/campaign-started
date -Is > logs/450-cold-corpus/campaign-started
bash held.sh timeout --signal=TERM --kill-after=1s 55s bash corpus450-cold.sh > logs/450-cold-corpus/group-all.log 2>&1
printf 'All five complete paired corpus rounds passed.\n'
