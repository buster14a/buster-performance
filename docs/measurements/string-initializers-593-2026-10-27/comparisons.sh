#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
echo $$ > comparisons.pid
export EXCLUSIVE_OWNER=codex-593
export EXCLUSIVE_TITLE="Buster #593 matched string initializer comparisons"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/593
lock="$HOME/buster-fast-bench/exclusive.sh"
"$lock" clang -std=c17 -O2 -Wall -Wextra -Werror compare.c -o compare > logs/compare-build.log 2> logs/compare-build-lock.log
id=0
for kind in strings repeated wide records pointers characters integers; do
    for first in 0 3; do
        last=3
        if ((first == 3)); then last=4; fi
        if test -f STOP; then echo 'comparison stopped'; exit 1; fi
        echo "start kind=$kind first=$first last=$last"
        status=0
        "$lock" taskset -c 2 ./compare "$kind" "$id" "$first" "$last" \
            > "logs/comparison-$kind-$first.csv" 2> "logs/comparison-$kind-$first-lock.log" || status=$?
        if ((status == 77)); then echo 'comparisons status=0'; exit 0; fi
        if ((status != 0)); then exit "$status"; fi
        echo "done kind=$kind first=$first last=$last"
        sleep 10
    done
    id=$((id + 1))
done
echo 'comparisons status=0'
