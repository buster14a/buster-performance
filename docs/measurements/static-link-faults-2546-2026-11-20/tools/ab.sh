#!/bin/bash
# ab.sh ROUNDS "NAME|ENV|COMPILER" ... -- ARGS...: interleaved fresh-process runs of each config, medians of the
# runtime/executable/write stage rows (--time-stages) and of the three's sum.
rounds=$1; shift
configs=()
while [ "$1" != "--" ]; do configs+=("$1"); shift; done
shift
out=$(mktemp -d)
for r in $(seq $rounds); do
    for c in "${configs[@]}"; do
        IFS='|' read -r name envs compiler <<< "$c"
        env $envs "$compiler" "$@" --time-stages 2>&1 | grep -E "^time-stage	(runtime|executable|write)	" | sed "s/^/$name	/" >> $out/rows
    done
done
python3 -I - $out/rows <<'PY'
import sys, statistics, collections
rows = collections.defaultdict(lambda: collections.defaultdict(list))
order = []
for line in open(sys.argv[1]):
    f = line.rstrip('\n').split('\t')
    name, stage = f[0], f[2]
    if name not in order: order.append(name)
    rows[name][stage].append((float(f[3]), int(f[6]), int(f[7])))
for name in order:
    parts = []
    tot = [sum(x) for x in zip(*[[r[0] for r in rows[name][s]] for s in ('runtime', 'executable', 'write')])]
    for stage in ('runtime', 'executable', 'write'):
        r = rows[name][stage]
        parts.append('%s %.3f ms %d flt %d kb' % (stage, statistics.median(x[0] for x in r), statistics.median(x[1] for x in r), statistics.median(x[2] for x in r)))
    print('%-8s n=%d link %.3f ms | %s' % (name, len(tot), statistics.median(tot), ' | '.join(parts)))
PY
rm -rf $out
