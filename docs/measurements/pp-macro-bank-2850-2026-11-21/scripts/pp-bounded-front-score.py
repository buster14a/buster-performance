"""Paired statistics for source-native PP experiments and their independent consume benchmarks."""
import re,sys
from pathlib import Path
from statistics import median
from collections import defaultdict
root=Path(sys.argv[1])
def counters(file):
    result={}
    for l in file.read_text().splitlines():
        p=l.split(';')
        if len(p)>2 and p[0].isdigit():result[p[2]]=int(p[0])
    result['cycles:u+k']=result['cycles:u']+result['cycles:k']
    return result
def emit(*args):print(*args,sep='\t')
emit('study','source','reference','candidate','metric','rounds','reference median','candidate median','median paired %','minimum %','maximum %')
def compare(study,source,reference,candidate,name,pairs):
    if not pairs:return
    delta=[100*(b/a-1) for a,b in pairs if a]
    if not delta:return
    emit(study,source,reference,candidate,name,len(pairs),*(f'{x:.3f}' for x in [median(a for a,b in pairs),median(b for a,b in pairs),median(delta),min(delta),max(delta)]))
for study,arms in [('macrobank-time',[('parent','off'),('off','on'),('parent','on')]),('grammarfinal-time',[('parent','off'),('off','write'),('write','take'),('off','take'),('parent','take')])]:
    d=root/study
    if not (d/'status').is_file():continue
    stats=defaultdict(lambda:defaultdict(dict))
    elfs=defaultdict(set)
    for line in (d/'status').read_text().splitlines():
        r,c,pos,label=line.split();file=d/f'{r}-{c}-{pos}-{label}'
        row={}
        v=file.with_suffix('.front').read_text().strip().split()
        if v[0]=='front':
            n=int(v[1]);row['raw PP ns/token']=int(v[5])/n
        else:
            _,n,grammar,chosen,setup,pp,parse,release=v;n=int(n)
            row['raw PP ns/token']=int(pp)/n;row['raw parse ns/token']=int(parse)/n
            row['raw PP + parse ns/token']=(int(pp)+int(parse))/n
        for e,x in counters(file.with_suffix('.rawperf')).items():row['raw source process '+e+'/token']=x/n
        for e,x in counters(file.with_suffix('.perf')).items():row['staged compile '+e]=x
        timings=defaultdict(list)
        for l in file.with_suffix('.wall').read_text().splitlines():
            m=re.match(r'run \d+ list 1: ([\d.]+) ms wall.*?, (\d+) KiB wait4 peak, (\d+) minor faults, \d+ major, (\d+) user cycles, (\d+) instructions, status 0',l)
            if m:
                for k,x in zip(('external wall ms','external peak KiB','external minor faults','external user cycles','external instructions'),m.groups()):
                    timings[k].append(float(x))
        assert len(timings['external wall ms'])==2,file
        row.update({k:median(x) for k,x in timings.items()})
        for l in file.with_suffix('.stages').read_text().splitlines():
            v=l.split('\t')
            if v[:1]==['time-stage'] and v[1] in ('preprocess','parse','check-input','check-program','total'):row['staged '+v[1]+' ms']=float(v[2])
        row['staged PP + parse ms']=row['staged preprocess ms']+row['staged parse ms']
        elfs[c].add(file.with_suffix('.sha256').read_text().strip())
        for k,x in row.items():stats[c,k][r][label]=x
    assert all(len(v)==1 for v in elfs.values()),elfs
    for a,b in arms:
        for (c,k),series in stats.items():
            compare(study,c,a,b,k,[(x[a],x[b]) for x in series.values() if a in x and b in x])
d=root/'macrobank-kernel-fixed'
for f in d.glob('*.log'):
    if f.stem not in ('main','sqlite','lua','musl'):continue
    vals=defaultdict(dict)
    for l in f.read_text().splitlines():
        if l.startswith('lookup '):
            _,i,arm,blocks,ticks,hash=l.split()
            if int(i)>0:vals[i][arm]=int(ticks)/int(blocks)
    compare('macrobank kernel',f.stem,'scalar','low bank','TSC/visited block',[(x['0'],x['1']) for x in vals.values()])
d=root/'grammarfinal-time';k=defaultdict(lambda:defaultdict(lambda:defaultdict(list)))
for f in d.glob('*-sqlite-*-take.consume'):
    for l in f.read_text().splitlines():
        if l.startswith('consume '):
            _,rep,arm,n,tsc,read,hash=l.split()
            if int(rep)>0:
                k['padding/adoption or conversion TSC/t'][f.name][arm].append(int(tsc)/int(n))
                k['subsequent checksum TSC/t'][f.name][arm].append(int(read)/int(n))
for name,series in k.items():compare('grammar consume','sqlite','original conversion','adoption',name,[(median(x['0']),median(x['1'])) for x in series.values()])
