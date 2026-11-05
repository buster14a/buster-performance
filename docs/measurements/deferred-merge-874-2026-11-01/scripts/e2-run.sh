#!/bin/bash
# E2 for #874: the remaining units' fix and control cold readings, in one lock hold each.
. ~/buster-fast-bench/874-verify/scripts/env.sh
~/buster-fast-bench/exclusive.sh "$D/scripts/e2-batch.sh" "$@"
