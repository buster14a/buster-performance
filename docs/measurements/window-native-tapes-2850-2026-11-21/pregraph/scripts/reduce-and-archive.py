from pathlib import Path
import re,sys,csv,collections,tarfile,hashlib
w=Path(__file__).resolve().parent
root=w/'independent-native-values'; policies=w/'independent-native-policy'
dst=w/'perf-counters/docs/measurements/window-native-tapes-2850-2026-11-21/pregraph'
(dst/'scripts').mkdir(parents=True,exist_ok=True)
def fields(l):
    return {k:int(v) for k,v in re.findall(r'([\w-]+)=(\d+)',l)}
with (dst/'native.tsv').open('w') as out,tarfile.open(dst/'corpora.tar.xz','w:xz',preset=2) as tar:
    writer=csv.writer(out,delimiter='\t',lineterminator='\n')
    columns=['selected','written','source entries','source calls','roots','entries','differences','globals','calls','arguments','variadic','labels','call-roots']
    writer.writerow(['case',*columns])
    for directory in [root,policies]:
        for f in sorted(directory.glob('*.out')):
            n=next(fields(l) for l in f.read_text().splitlines() if l.startswith('probe-native roots='))
            count=collections.Counter()
            for l in f.with_suffix('.err').open():
                if l.startswith('source-rows '):count.update(fields(l))
            data=dict(n,selected=count['selected'],written=count['written'],**{'source entries':count['entries'],'source calls':count['calls']});writer.writerow([f.stem,*[data[k] for k in columns]])
            for g in (f,f.with_suffix('.err'),f.with_suffix('.status')):
                if g.exists():tar.add(g,arcname='runs/'+g.name)
    tar.add(root/'status',arcname='runs/default-status')
    tar.add(root/'build.log',arcname='runs/build.log')
with (dst/'file-policy.tsv').open('w') as out,tarfile.open(dst/'file-policies.tar.xz','w:xz',preset=3) as tar:
    writer=csv.writer(out,delimiter='\t',lineterminator='\n')
    cols=['cases','status differences','source-selected','written','roots','entries','calls','globals','arguments','variadic','differences','unsafe','missing']
    writer.writerow(['set','policy',*cols])
    for fs,total in [('tests',3690),('inline',41637)]:
        f=policies/(fs+'.tsv')
        groups=collections.defaultdict(collections.Counter)
        for row in csv.DictReader(f.open(),delimiter='\t'):
            c=groups[row['policy']]
            c['cases']+=1;c['status differences']+=row['status']!=row['reference-status']
            for k in cols[2:]:c[k]+=int(row[k])
        assert sum(g['cases'] for g in groups.values())==total
        for p,g in groups.items():
            writer.writerow([fs,p,*[g[k] for k in cols]])
        tar.add(f,arcname=fs+'.tsv')
(dst/'build.txt').write_text('Base 84a7d3d76891d6c393497e62e6aff38f2b162fc2\n'+hashlib.sha256((root/'experiment.patch').read_bytes()).hexdigest()+'  experiment.patch\n'+hashlib.sha256((root/'compiler').read_bytes()).hexdigest()+'  local Develop compiler\n')
