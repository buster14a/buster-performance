#!/usr/bin/env bash
set -euo pipefail
d=$(cd "$(dirname "$0")" && pwd)
shared="$HOME/buster-fast-bench/2850-codex-step2"
export BUSTER_BENCH_TITLE='2850 projected subscript facts' BUSTER_BENCH_URL=https://github.com/buster14a/buster/issues/2850
for (( r=$1; r<=$2; r++ )); do
 (
    flock -x 8
    labels=(base project); if ((r % 2 == 0)); then labels=(project base); fi
    for label in "${labels[@]}"; do
        "$shared/lock.sh" bash "$d/remote-sample.sh" "$r" "$label" "$3" "$4" "$5"
    done
 ) 8>"$shared/our-timing.lock"
done
