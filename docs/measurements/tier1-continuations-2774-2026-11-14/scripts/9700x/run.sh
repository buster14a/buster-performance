#!/usr/bin/env bash
# run.sh: setup.sh then chain.sh, as one detached unit.
W=$HOME/buster-fast-bench/2774-claude
cd $W || exit 1
echo "$(date -u +%FT%TZ) setup start" >> chain.log
BASE_SHA=9e4809c07aa8951388b18f72ed6d6b7eb28b3a54 HEAD_SHA=245ad0662398861f0ea6ce96cabb2cc45283d966 ./setup.sh >> chain.log 2>&1 || { echo "$(date -u +%FT%TZ) setup FAILED" >> chain.log; exit 1; }
echo "$(date -u +%FT%TZ) setup done" >> chain.log
exec ./chain.sh
