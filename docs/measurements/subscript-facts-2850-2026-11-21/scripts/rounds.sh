#!/usr/bin/env bash
set -euo pipefail
d=$(cd "$(dirname "$0")" && pwd); shared="$HOME/buster-fast-bench/2850-codex-step2"
for (( r=1; r<=7; r++ )); do 
    modes=(AA AB); if ((r%2 == 0)); then modes=(AB AA); fi
    for source_key in sqlite lua musl; do
        (
            flock -x 8
            for v in "${modes[@]}"; do "$shared/lock.sh" bash "$d/sample.sh" "$r" "$v" "$source_key"; done
        ) 8>"$shared/our-timing.lock"
    done
done
