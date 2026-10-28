#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Recompute every paired result from retained process metrics; no timing or external tool execution.
from pathlib import Path
from fractions import Fraction
import csv,hashlib,json,statistics
root=Path(__file__).resolve().parent
rows=[json.loads(line) for line in (root/'trials.jsonl').read_text().splitlines()]
with (root/'plan.tsv').open() as stream: plan=list(csv.DictReader(stream,delimiter='\t'))
assert len(rows)==len(plan)==84
for row,p in zip(rows,plan):
    assert (row['round'],row['kind'],row['label'],row['tree'])==(int(p['round']),p['kind'],p['label'],p['tree'])
    assert row['exit']==0
    assert row==json.loads((root/'logs'/p['job']/'receipt.json').read_text())
expected=json.loads((root/'expected.json').read_text())
for stage in ('before','after'):
    snapshot=json.loads((root/f'{stage}-identities.json').read_text())
    assert snapshot['headers']==expected['headers'] and snapshot['sources']==expected['source_manifests']
    for label,digest in expected['binary_sha256'].items(): assert snapshot['binaries'][label]['sha256']==digest
assert hashlib.sha256((root/'inputs/h64x3.c').read_bytes()).hexdigest()==expected['input_sha256']
assert (root/'wrapper-exit.txt').read_text().strip()=='0'
assert json.loads((root/'controller-result.json').read_text())['completed_trials']==84
by={}
for row in rows: by.setdefault((row['round'],row['kind']),{})[row['label']]=row
pairs=[]; summary={}
for kind,labels in [('ab',('a','b')),('aa',('a1','a2'))]:
    selected=[]
    for rnd in range(1,22):
        before,after=(by[(rnd,kind)][label] for label in labels)
        bo,bm=(Fraction(x['whole']) for x in before['readings']); ao,am=(Fraction(x['whole']) for x in after['readings'])
        whole=(am/bm-1)*100; one=(ao/bo-1)*100; context=((am/ao)/(bm/bo)-1)*100
        pair={'round':rnd,'kind':kind,'before_label':labels[0],'after_label':labels[1],
              'before_one_ns_per_token':str(bo),'after_one_ns_per_token':str(ao),
              'before_whole_ns_per_token':str(bm),'after_whole_ns_per_token':str(am),
              'whole_change_percent':format(float(whole),'.15g'),'one_change_percent':format(float(one),'.15g'),
              'relative_to_one_context_percent':format(float(context),'.15g'),
              'before_exit':before['exit'],'after_exit':after['exit'],
              'before_start_utc':before['start_utc'],'after_start_utc':after['start_utc']}
        for key,value in [('before_one_ns_per_token',bo),('after_one_ns_per_token',ao),('before_whole_ns_per_token',bm),('after_whole_ns_per_token',am)]: pair[key]=format(float(value),'.2f')
        pairs.append(pair); selected.append((whole,one,context))
    whole=[x[0] for x in selected]; one=[x[1] for x in selected]
    summary[kind]={'pairs':len(selected),'whole_median_percent':float(statistics.median(whole)),
                   'whole_low_percent':float(min(whole)),'whole_high_percent':float(max(whole)),
                   'whole_positive':sum(x>0 for x in whole),'one_median_percent':float(statistics.median(one)),
                   'one_low_percent':float(min(one)),'one_high_percent':float(max(one)),
                   'relative_to_one_context_median_percent':float(statistics.median(x[2] for x in selected))}
with (root/'pairs.csv').open('w',newline='') as stream:
    writer=csv.DictWriter(stream,fieldnames=list(pairs[0])); writer.writeheader(); writer.writerows(pairs)
(root/'paired-analysis.json').write_text(json.dumps(summary,indent=2)+'\n')
print(json.dumps(summary,indent=2))
