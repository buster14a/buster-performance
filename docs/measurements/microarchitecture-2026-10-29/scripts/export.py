#!/usr/bin/env python3
"""Export collected perf records; displayed metric values are diagnostic only."""
import argparse
import collections
import csv
import json
from pathlib import Path
import statistics

from metric_qualification import Inventory, archived_capture, qualify

p=argparse.ArgumentParser()
p.add_argument('directory')
p.add_argument('--out', required=True, help='new output directory; never overwrite historical summaries')
a=p.parse_args()
root=Path(a.directory)
out=Path(a.out)
measurement_bytes=(root/'measurements.jsonl').read_bytes() if (root/'measurements.jsonl').exists() else b''
inventory_bytes=(root/'perf-list.json').read_bytes() if (root/'perf-list.json').exists() else b'[]'
records=[json.loads(x) for x in measurement_bytes.splitlines() if x.strip()]
inventory=Inventory(json.loads(inventory_bytes))
historical=archived_capture(measurement_bytes,inventory_bytes)
out.mkdir(parents=True,exist_ok=False)
recovered=[]
if (root/'recovery.jsonl').exists():
    recovered=[json.loads(x) for x in (root/'recovery.jsonl').read_text().splitlines()]

def lines(x):
    result=[]
    for line in x.splitlines():
        f=line.split(';')
        if len(f)>=5 and f[2]:
            try: value=float(f[0]); duty=float(f[4])
            except ValueError: continue
            result.append((f[2],value,duty,f))
    return result

samples=collections.defaultdict(list)
for x in records:
    if x['kind']!='counter' or x['status']:
        continue
    ls=lines(x['perf_stat'])
    if len(ls)!=len(x['variant'])+2:
        continue
    for i,event in enumerate(x['variant']):
        cycle,instr,event_line=ls[0],ls[1],ls[i+2]
        if min(cycle[2],instr[2],event_line[2])>=99 and cycle[1]>0 and instr[1]>0:
            samples[(x['workload'],event)].append((event_line[1],event_line[1]/cycle[1],event_line[1]/instr[1]*1000,min(cycle[2],instr[2],event_line[2]),'group'))
for x in recovered:
    ls=lines(x['perf_stat'])
    if x['status']==0 and len(ls)==3 and min(z[2] for z in ls)>=99 and ls[0][1]>0 and ls[1][1]>0:
        event_line=ls[2]
        samples[(x['workload'],x['event'])].append((event_line[1],event_line[1]/ls[0][1],event_line[1]/ls[1][1]*1000,min(z[2] for z in ls),x.get('collection_method','isolated')))
with (out/'counters-summary.csv').open('w',newline='') as f:
    w=csv.writer(f, lineterminator='\n');w.writerow(['workload','event','valid_samples','median_count','events_per_cycle','events_per_1000_instructions','minimum_duty_percent','method'])
    for (workload,event),ss in sorted(samples.items()):
        w.writerow([workload,event,len(ss),f'{statistics.median(x[0] for x in ss):.2f}',f'{statistics.median(x[1] for x in ss):.6f}',f'{statistics.median(x[2] for x in ss):.6f}',f'{min(x[3] for x in ss):.2f}',','.join(sorted({x[4] for x in ss}))])
with (out/'metrics-summary.csv').open('w',newline='') as f:
    fields=['workload','metric','process_status','eligible','qualification','reason','value','unit','raw_formula_value','reported_value','reported_unit_and_name','minimum_counter_duty_percent','scope','formula_sha256','formula_closure_sha256']
    writer=csv.DictWriter(f,fields,extrasaction='ignore',lineterminator='\n')
    writer.writeheader()
    for x in records:
        if x['kind']!='metric':continue
        result=qualify(x,inventory,historical=historical)
        result.update(workload=x.get('workload'),process_status=x.get('status'))
        writer.writerow(result)
with (out/'stages-summary.csv').open('w',newline='') as f:
    w=csv.writer(f, lineterminator='\n');w.writerow(['workload','stage','samples','median_ms','min_ms','max_ms'])
    stages=collections.defaultdict(list)
    for x in records:
        if x['kind']!='stages' or x['status']:continue
        for line in x['workload_stderr'].splitlines():
            fields=line.split('\t')
            if len(fields)>=4 and fields[0]=='time-stage' and fields[1]!='stage':
                try:stages[(x['workload'],fields[1])].append(float(fields[2]))
                except ValueError:pass
    for (workload,stage),values in sorted(stages.items()):
        w.writerow([workload,stage,len(values),statistics.median(values),min(values),max(values)])
print('exported',len(samples),'workload/event rows to',out)
