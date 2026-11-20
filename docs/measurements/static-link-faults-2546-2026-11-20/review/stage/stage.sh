#!/bin/sh
# stage.sh RUNS SOURCE ENV-ASSIGNMENTS -- COMPILER... : interleaved runs of `-static SOURCE` per compiler (each given as
# NAME=PATH[:ENV=VALUE]), printing for each the executable stage's medians: ms, minor faults, peak-kb-added.
runs=$1; src=$2; shift 2
out=$(mktemp -d /tmp/claude-0/-home-user/95f322c7-a439-5fec-9eac-68c48a1474ca/scratchpad/s2546/rv2/st.XXXX)
for i in $(seq 1 $runs); do
  for spec in "$@"; do
    name=${spec%%=*}; rest=${spec#*=}; path=${rest%%:*}; envs=""; [ "$rest" != "$path" ] && envs=$(echo "${rest#*:}" | tr ":" " ")
    env $envs $path -static --time-stages $src -o $out/a.out 2> $out/err || echo "fail $name"
    grep -P "^time-stage\texecutable\t" $out/err | cut -f3,6,7 >> $out/$name.tsv
  done
done
for spec in "$@"; do
  name=${spec%%=*}
  python3 -c "
import statistics,sys
rows=[l.split() for l in open('$out/$name.tsv')]
ms=[float(r[0]) for r in rows]; f=[int(r[1]) for r in rows]; k=[int(r[2]) for r in rows]
print('$name', 'runs', len(rows), 'ms', round(statistics.median(ms),3), 'faults', statistics.median(f), 'min', min(f), 'max', max(f), 'peak-kb', statistics.median(k), 'min', min(k), 'max', max(k))
"
done
