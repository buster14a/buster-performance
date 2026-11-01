#!/usr/bin/env bash
# queue-4.sh BASE HEAD REVISION: the merged head against the main it merged: both builds, head's tests, the
# micro-benchmark and the measurements (micro.sh and measure.sh), then #142's campaigns at the merged head with seeds
# no earlier campaign used (80 programs at both tiers, seeds 3400 to 3438; 40 by --tier1 --scalar, seeds 3600 to 3618).
. ~/buster-fast-bench/claude-141-reciprocal/common.sh
./build.sh "$1" "$2"
grep -q "^exit 0" logs-build/$2.log && grep -q "^exit 0" logs-build/$1.log || exit 1
./tests.sh "$2"
./micro.sh "$1" "$2"
./measure.sh "$1" "$2"
./campaign.sh "$2" "$3" 3400 3438
./campaign.sh "$2" "$3" 3600 3618 scalar
echo done > queue-4.done
