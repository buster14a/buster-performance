"""Reconstruct paired raw and normalized row timings from the archived shadow reports."""
import argparse
import csv
from pathlib import Path
import re
import statistics
import sys

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('mode', choices=['length','slots'])
parser.add_argument('directory', type=Path)
parser.add_argument('--rounds', type=int, default=7)
args = parser.parse_args()
def field(line, name):
    m = re.search(r'(?:^| )'+re.escape(name)+r'=(\d+)(?:\s|$)', line)
    if m is None:
        raise ValueError(f'missing {name} in {line}')
    return int(m[1])
writer=csv.writer(sys.stdout,delimiter='\t',lineterminator='\n')
writer.writerow(['corpus','execution','interval','unit','baseline','candidate','paired median','paired min','paired max'])
for corpus in ['sqlite','lua','musl']:
    samples={}
    expected={}
    for r in range(1,args.rounds+1):
        base,cand = ('1','2') if args.mode == 'length' else ('ordinary','slots')
        for idx,version in enumerate([base,cand,cand,base] if r%2 else [cand,base,base,cand]):
            tag=f'{r}-{idx}-{version}-{corpus}'
            assert (args.directory/(tag+'.status')).read_text().strip()=='0', tag
            lines=(args.directory/(tag+'.out')).read_text().splitlines()
            def get(prefix):
                values=[l for l in lines if l.startswith(prefix)]
                assert len(values)==1,(prefix,tag)
                return values[0]
            coverage=get('node-shadow: window rows expressions=')
            assert all(field(coverage,key)==0 for key in ['differences','not-kept-by-the-reference','second-runs-that-differ']),tag
            assert 'failures=0' in get('node-census: files='),tag
            assert 'chunks-that-differ=0' in get('node-shadow: reader-time fact words the front with the window:'),tag
            for key in ['expressions','taken','their-records','their-entries']:
                value=field(coverage,key)
                assert value==expected.setdefault(key,value),(key,tag)
            swept=field(coverage,'records-swept')
            assert swept==expected.setdefault('swept-'+version,swept)
            for execution,prefix in [('first','node-shadow: window rows ticks='),('repeat','node-shadow: window rows a second run over the same chunk,')]:
                line=get(prefix)
                intervals={'write':field(line,'the rows'),'values':field(line,'the values'),'all rows':int(re.search(r'ticks=(\d+)',line)[1])}
                intervals['write + values']=intervals['write']+intervals['values']
                for interval,ticks in intervals.items():
                    for unit,divisor in [('ticks/swept record',swept),('ticks/taken record',expected['their-records']),('total ticks',1)]:
                        k=(execution,interval,unit,r,version)
                        samples.setdefault(k,[]).append(ticks/divisor)
    for execution in ('first','repeat'):
        for interval in ('write','values','write + values','all rows'):
            for unit in ('ticks/swept record','ticks/taken record','total ticks'):
                def get_pairs(version):
                    pairs=[samples[execution,interval,unit,r,version] for r in range(1,args.rounds+1)]
                    assert all(len(p)==2 for p in pairs)
                    return [statistics.mean(p) for p in pairs]
                a,b=get_pairs(base),get_pairs(cand)
                diffs=[y-x for x,y in zip(a,b)]
                obs=[statistics.median(a),statistics.median(b),statistics.median(diffs),min(diffs),max(diffs)]
                writer.writerow([corpus,execution,interval,unit,*[f'{k:.5f}' for k in obs]])
