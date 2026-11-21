#!/bin/bash
set -eu
d=$(cd "$(dirname "$0")" && pwd);cc=$1; rev=$2
cd "$d/../switch-inputs"; source ../switch-local-args.sh;eval "args=($sqlite_arguments)"
for mode in plain source;do
 f=();if [[ $mode = source ]];then f+=(--node-window-source);fi
 perf record -q -o "$d/$rev/$mode.perf" -e instructions:u -c 100000 -- bash -c 'for n in 1 2 3 4;do "$@" || exit;done' _ "$cc" --lanes 1 "${f[@]}" -c "${args[@]}" -o "$d/$rev/profile.o"
 perf report --stdio -i "$d/$rev/$mode.perf" --no-children --show-total-period --percent-limit 0.01 -s dso,symbol --field-separator '|' > "$d/$rev/$mode.profile" 2>/dev/null
done
