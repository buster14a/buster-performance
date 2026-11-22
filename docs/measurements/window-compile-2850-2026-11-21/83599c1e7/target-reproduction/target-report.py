"""Summarize per-child wait4 and perf observations kept beside the hashes."""
from pathlib import Path
import csv
import json
import re
import statistics
import sys

out=Path(sys.argv[1])
root=Path(sys.argv[2])
median=statistics.median
def emit(name,header,rows):
    with (out/name).open('w',newline='') as stream:
        writer=csv.writer(stream,delimiter='\t')
        writer.writerow(header)
        writer.writerows(rows)

walls=[]
paired=[]
stages=[]
allstats=[]
pmu=[]
for tag in ('object1a55','object418e','objectrelas','objectstandalone'):
    pairs={'object1a55':[('legacy','fields'),('legacy','text'),('fields','both'),('legacy','both')],
           'object418e':[('legacy','fields'),('fields','stream'),('stream','packed'),('legacy','packed')],
           'objectrelas':[('packed','rela'),('packed','data'),('rela','complete'),('packed','complete')],
           'objectstandalone':[('ordinary','text'),('text','data'),('data','complete'),('ordinary','complete')] }[tag]
    for group in ('sqlite','main'):
        data=root/tag/group
        records={}
        for path in sorted(data.glob('*.time')):
            m=re.fullmatch(r'(\d+)-(\d+)-([a-z]+)\.time',path.name)
            if not m: raise ValueError(path)
            r,position,mode=m.groups()
            row=json.loads(path.read_text())
            assert row['status']==0,(path,row)
            counter=path.with_suffix('.pmu')
            if counter.is_file():
                for line in counter.read_text().splitlines():
                    columns=line.split(';')
                    if len(columns)>2 and columns[2] in ('cycles','cycles:u','instructions:u','minor-faults'):
                        row['pmu-'+columns[2]]=int(columns[0].strip().replace(',',''))
                        pmu.append((tag,group,int(r)+1,mode,columns[2],row['pmu-'+columns[2]]))
            records[int(r),mode]=row
            walls.append((tag,group,int(r)+1,int(position)+1,mode,*(row[key] for key in ('wall_ms','user_ms','system_ms','peak_kib','minor_faults','major_faults','status'))))
        for mode in sorted({arm for _,arm in records}):
            samples=[row for (_,arm),row in records.items() if arm==mode]
            for metric in sorted({k for row in samples for k in row} - {'status'}):
                measured=[row[metric] for row in samples if metric in row]
                allstats.append((tag,group,mode,metric,len(measured),median(measured),min(measured),max(measured)))
        for a,b in pairs:
            rounds=sorted(r for r,which in records if which==a and (r,b) in records)
            for key in ('wall_ms','user_ms','system_ms','peak_kib','minor_faults','pmu-cycles','pmu-cycles:u','pmu-instructions:u','pmu-minor-faults'):
                x=[(records[r,a][key],records[r,b][key]) for r in rounds if key in records[r,a] and key in records[r,b]]
                if not x:continue
                delta=[vb-va for va,vb in x]
                per=[(vb-va)/va*100 for va,vb in x if va!=0]
                paired.append((tag,group,a,b,key,len(delta),round(median([va for va,vb in x]),6),round(median([vb for va,vb in x]),6),round(median(delta),6),round(median(per),4) if per else '',sum(n<0 for n in delta),round(min(delta),6),round(max(delta),6)))
        for path in sorted(data.glob('*.stages')):
            for line in path.read_text().splitlines():
                stages.append((tag,group,path.stem,line))
emit('target-samples.tsv',('build','input','round','position','mode','wall-ms','user-ms','system-ms','max-rss-kib','minor-faults','major-faults','exit'),walls)
emit('target-paired.tsv',('build','input','before','after','metric','paired-rounds','median-before','median-after','median-after-minus-before','median-pair-percent','lower-after','min-pair-delta','max-pair-delta'),paired)
emit('target-modes.tsv',('build','input','mode','metric','samples','median','min','max'),allstats)
emit('target-pmu.tsv',('build','input','round','mode','event','count'),pmu)
emit('target-stages.tsv',('build','input','mode','reported-line'),stages)
