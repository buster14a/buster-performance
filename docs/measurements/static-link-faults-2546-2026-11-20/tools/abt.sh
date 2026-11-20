#!/bin/bash
# abt.sh ROUNDS "NAME|ENV|COMPILER" ... -- ARGS...: interleaved fresh-process runs with PROTO_T=1; medians of the
# bind_end and link_check lines and of the executable stage.
rounds=$1; shift
configs=()
while [ "$1" != "--" ]; do configs+=("$1"); shift; done
shift
out=$(mktemp -d)
for r in $(seq $rounds); do
    for c in "${configs[@]}"; do
        IFS='|' read -r name envs compiler <<< "$c"
        env PROTO_T=1 $envs taskset -c 3 "$compiler" "$@" --time-stages 2>&1 | grep -E "^proto |^time-stage	(executable|write)	" | sed "s/^/$name	/" >> $out/rows
    done
done
python3 -I - $out/rows <<'PY'
import sys, statistics, collections
rows = collections.defaultdict(lambda: collections.defaultdict(list))
order = []
for line in open(sys.argv[1]):
    f = line.rstrip('\n').split('\t')
    name = f[0]
    if name not in order: order.append(name)
    if f[1].startswith('proto '):
        w = f[1].split()
        rows[name][w[1]].append(float(w[2]))
    else:
        rows[name][f[2]].append(float(f[3]))
for name in order:
    print('%-6s ' % name + ' | '.join('%s %.3f' % (k, statistics.median(v)) for k, v in rows[name].items()))
PY
rm -rf $out
