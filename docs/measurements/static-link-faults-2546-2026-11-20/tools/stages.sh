#!/bin/sh
# stages.sh COMPILER RUNS ARGS...: medians of --time-stages' runtime/executable/write rows over RUNS fresh processes.
compiler=$1; runs=$2; shift 2
out=$(mktemp -d)
i=0
while [ $i -lt $runs ]; do
    "$compiler" "$@" --time-stages 2>&1 | grep -E "^time-stage	(runtime|executable|write)	" >> $out/rows
    i=$((i+1))
done
python3 -I - $out/rows <<'PY'
import sys, statistics, collections
rows = collections.defaultdict(list)
for line in open(sys.argv[1]):
    f = line.rstrip('\n').split('\t')
    rows[f[1]].append((float(f[2]), float(f[4]), int(f[5]), int(f[6])))
for stage in ('runtime', 'executable', 'write'):
    r = rows[stage]
    med = lambda k: statistics.median(x[k] for x in r)
    print('%-10s n=%d ms %.3f (min %.3f) system-ms %.3f faults %d peak-kb %d' % (stage, len(r), med(0), min(x[0] for x in r), med(1), med(2), med(3)))
PY
rm -rf $out
