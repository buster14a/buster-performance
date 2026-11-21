#!/bin/bash
set -euo pipefail
scripts=$(cd "$(dirname "$0")" && pwd)
work=$(cd "$scripts/.." && pwd)
cd "${BUSTER_QA_TREE:-$work/qa3204-24c}"
out=${BUSTER_QA_OUT:-$work/qa3204-24c-results}
perf=${BUSTER_QA_PERF:-$work/qa3204-inputs}
prior=$perf/tests-holes-2850-2026-11-21
compiler=$PWD/build/compiler
export out perf prior compiler scripts
export CORES_LINK=https://github.com/buster14a/buster/pull/3214
mkdir -p "$out/combined"
cat "$out/tests.list" "$out/inline.list" > "$out/combined/inputs.list"
sweep_policy() {
  local policy=$1
  local opts=(-Wall -Wextra)
  if [[ $policy == everything ]]; then opts=(-Weverything -Wno-c++-compat); fi
  CORES_TITLE="3214 24c combined fixtures $policy" cores -n 2 -- python3 "$prior/sweep/sweep.py" "$compiler" "$out/combined/$policy.tsv" 2 "${opts[@]}" < "$out/combined/inputs.list" > "$out/combined/$policy.log"
  python3 - "$out" "$policy" <<'PY'
from pathlib import Path
from collections import Counter
import sys
out=Path(sys.argv[1]);mode=sys.argv[2]
rows=(out/'combined'/f'{mode}.tsv').read_text().splitlines()
start=0
for group in ('tests','inline'):
    ids=(out/f'{group}.list').read_text().splitlines()
    selected=rows[start:start+len(ids)]
    assert [line.split('\t')[0] for line in selected]==ids
    stats=Counter(line.split('\t')[1] for line in selected)
    assert set(stats)<= {'clean','rejected'}
    (out/'sweep'/f'{group}-{mode}.tsv').write_text('\n'.join(selected)+'\n')
    (out/'sweep'/f'{group}-{mode}.log').write_text(str(dict(stats))+'\n')
    start+=len(ids)
assert start==len(rows)
PY
}
sweep_policy wall & wall_job=$!
sweep_policy everything & everything_job=$!
find "$perf" -path '*/probes/cases*.py' | CORES_TITLE='3214 24c fixed 8009 probes' cores -n 2 -- xargs -P 2 -I'{}' bash -ec 'python3 "$prior/probes/probe.py" "$compiler" "$1" > "$out/probes/$(basename "$1" .py).txt"' _ '{}' & probe_job=$!
wait "$wall_job"
wait "$everything_job"
while ! [[ -s "$out/sweep/inline-default.log" ]]; do sleep 2; done
python3 - "$out/ids.json" <<'PY'
import json,re,sys,pathlib
d=pathlib.Path('src/buster/compiler')
names=dict(re.findall(r'CHECK_WARNING_ID_(\w+)\s*=\s*(\d+)',((d/'c_check_warning_ids.c').read_text()+(d/'c_check_warning_events.c').read_text())))
tested=re.findall(r'\[CHECK_WARNING_ID_(\w+)\] = NODE_CENSUS_WARNING_TESTED',(d/'c_check_node_census.c').read_text())
json.dump([(int(names[n]),n,'TESTED','','') for n in tested],open(sys.argv[1],'w'))
PY
CORES_TITLE='3214 24c all 93 warning triggers' cores -n 1 -- python3 "$scripts/extend-triggers.py" "$prior/triggers/triggers.py" "$compiler" "$out/triggers" "$out"/sweep/{inline-default,tests-default,inline-wall,tests-wall,inline-everything,tests-everything}.tsv > "$out/triggers.txt"
wait "$probe_job"
while ! [[ -s "$out/fuzz/66/verified-result.json" && -s "$out/fuzz/65/verified-result.json" && -s "$out/tests/driver-8.status" ]]; do sleep 3; done
python3 - "$out" "$compiler" <<'PY'
import pathlib,json,sys,hashlib
out=pathlib.Path(sys.argv[1]);digest=hashlib.file_digest(open(sys.argv[2],'rb'),'sha256').hexdigest()
for n in range(61,67):
    d=json.loads((out/'fuzz'/str(n)/'verified-result.json').read_text())
    assert d['key'][0]==digest and d['key'][2][:2]==[str(n),'15000']
    assert (out/'fuzz'/f'{n}-early.log').read_text()==d['output']
    (out/'fuzz'/f'{n}.log').write_text(d['output'])
PY
python3 "$scripts/summarize.py" "$out" > "$out/summary.txt"
