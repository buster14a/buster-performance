#!/usr/bin/env bash
set -euo pipefail
w=$(pwd);p=final-evidence
while [[ ! -f $p/candidate-build.status ]];do sleep 3;done
[[ $(cat "$p/candidate-build.status") == 0 ]]
for mode in normal debug;do
 CORES_TITLE="Measure all 25 compiler changes on real $mode C source" CORES_LINK=https://github.com/buster14a/buster/pull/3144 cores -n1 -- python local-compiler-pair.py "$mode" final-control/build/compiler final-candidate/build/compiler "$p/paired-$mode" "$mode" >"$p/$mode-run.log" 2>&1
 python summarize-compile.py "$p/paired-$mode" "$mode" "$p/$mode-processes.tsv" >"$p/$mode-summary.txt"
done
touch "$p/paired-ready"
bash "$p/qualify.sh" candidate
ln -sfn "$w/eighteen-evidence/eighteen-control-own-stage2" "$p/final-control-own-stage2"
ln -sfn "$w/eighteen-evidence/eighteen-control-own-stage3" "$p/final-control-own-stage3"
python "$p/compare-common.py"
python - <<'PY'
from pathlib import Path
import csv,hashlib
p=Path('final-evidence');rows=[]
for v in ['control','candidate']:
 a=p/f'final-{v}-own-stage2';b=p/f'final-{v}-own-stage3'
 for f in sorted(list(a.glob('unit-*.o'))+[a/'compiler']):
  sha=lambda x: hashlib.file_digest(x.open('rb'),'sha256').hexdigest()
  h=sha(f);h2=sha(b/f.name);rows.append([v,f.name,f.stat().st_size,h,h2,h==h2])
assert len(rows)==88 and all(x[-1] for x in rows)
with (p/'fixedpoints.tsv').open('w') as o:t=csv.writer(o,delimiter='\t',lineterminator='\n');t.writerow(['variant','artifact','size','stage2_sha256','stage3_sha256','identical']);t.writerows(rows)
PY
for s in "$p"/final-candidate-*.status;do [[ $(cat "$s") == 0 ]];done
touch "$p/qualified"
