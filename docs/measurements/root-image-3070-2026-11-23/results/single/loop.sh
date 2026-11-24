#!/usr/bin/env bash
# usage: loop.sh COMPILER KIND   (run inside perf stat)
. "$(dirname "$0")/vars.sh"
C=$1
if [ "$2" = empty ]; then for ((i = 1; i <= 300; i += 1)); do "$C" -c "${opts[@]}" "$D/empty/e$i.c"; done
else for u in "${units[@]}"; do "$C" -c "${opts[@]}" "$u" 2> /dev/null; done; fi
