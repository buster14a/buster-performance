#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
grep -Fxq COMPLETE constfcc-fixture.log
grep -Eq '^test-checker: [0-9]+ checks, 0 failures$' constfcc-checker.log
for group in sqlite main lua musl;do
 while ! grep -Fxq 'PREFLIGHT COMPLETE' "constfcc-$group-full.log" 2>/dev/null; do sleep 3; done
 grep -Fxq COMPLETE "constfcc-$group-audit.log"
done
python3 - <<'PY'
import csv
for g,(n,t,r,m) in {'sqlite':(1,716136,2356,4759),'main':(1,2433922,27201,67186),'lua':(34,571543,781,1986),'musl':(1336,5039639,2895,4005)}.items():
 with open(f'results/constant-sources-constfcc-{g}/checks.tsv') as f: q=list(csv.DictReader(f,delimiter='\t'))
 got=len(q),*(sum(int(e[k]) for e in q) for k in ['tokens','roots','removed'])
 print(g,got,flush=True)
 assert got==(n,t,r,m)
PY
touch results/constfcc/release-timing
echo RELEASED
