#!/usr/bin/env bash
set -euo pipefail
w=$(pwd);p=tip-evidence
while [[ ! -e "$p/built" ]];do sleep 4;done
bash "$p/qualify.sh" candidate
while [[ ! -e "$p/control-verified" ]];do sleep 4;done
python "$p/compare-common.py"
python - <<'PY'
from pathlib import Path
import csv,hashlib
p=Path('tip-evidence');rows=[]
for v in ['control','candidate']:
 a=p/f'tip-{v}-own-stage2';b=p/f'tip-{v}-own-stage3'
 for f in sorted(list(a.glob('unit-*.o'))+[a/'compiler']):
  sha=lambda x: hashlib.file_digest(x.open('rb'),'sha256').hexdigest()
  h=sha(f);h2=sha(b/f.name);rows.append([v,f.name,f.stat().st_size,h,h2,h==h2])
assert len(rows)==88 and all(x[-1] for x in rows)
with (p/'fixedpoints.tsv').open('w') as o:t=csv.writer(o,delimiter='\t',lineterminator='\n');t.writerow(['variant','artifact','size','stage2_sha256','stage3_sha256','identical']);t.writerows(rows)
PY
for s in "$p"/tip-candidate-*.status;do [[ $(cat "$s") == 0 ]];done
touch "$p/qualified"
