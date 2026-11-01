#!/usr/bin/env bash
# queue-1.sh BASE HEAD REVISION: builds, head's tests, the micro-benchmark, the measurements, then #142's campaigns at the
# head (80 programs at both tiers, seeds 3000 to 3038; 40 by --tier1 --scalar, seeds 3200 to 3218).
. ~/buster-fast-bench/claude-141-reciprocal/common.sh
./build.sh "$1" "$2"
grep -q "^exit 0" logs-build/$2.log && grep -q "^exit 0" logs-build/$1.log || exit 1
./tests.sh "$2"
./micro.sh "$1" "$2"
./measure.sh "$1" "$2"
./campaign.sh "$2" "$3" 3000 3038
./campaign.sh "$2" "$3" 3200 3218 scalar
echo done > queue-1.done
