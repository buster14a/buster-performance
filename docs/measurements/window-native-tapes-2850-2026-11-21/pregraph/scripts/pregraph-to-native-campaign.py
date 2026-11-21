"""Replay a labeled source manifest under explicit warning policies using a frozen compiler."""
import argparse, csv, re, sys, os, json, subprocess
from collections import Counter
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('compiler',type=Path);parser.add_argument('root',type=Path);parser.add_argument('manifest',type=Path);parser.add_argument('out',type=Path)
args=parser.parse_args()
compiler=args.compiler.resolve()
env=dict(os.environ,NODE_PROOF_POINTERS='1',NODE_PROOF_CALLS='1',NODE_SOURCE_ROWS='1',NODE_PROOF_NATIVE='1',NODE_PROOF_NO_FP='1')
policies={'default':[],'wall':['-Wall','-Wextra'],'everything':['-Weverything','-Wno-c++-compat']}
expected=(json.loads(line) for line in args.manifest.open())
columns=['source','policy','reference-status','status','source-selected','written','roots','entries','calls','globals','arguments','variadic','differences','unsafe','missing']
def run(row):
    src,policy,prior=row['source'],row['policy'],row['returncode']
    cmd=[compiler,'measure-node-machine','--shadow','--window-rows','--front-first','--passes','0',*policies[policy],src]
    p=subprocess.run(cmd,cwd=args.root,env=env,capture_output=True,timeout=80)
    n=Counter();c=Counter();w=Counter()
    for l in p.stdout.splitlines():
        if l.startswith(b'probe-native '):n.update({k.decode():int(v) for k,v in re.findall(rb'([\w-]+)=(\d+)',l)})
    for l in p.stderr.splitlines():
        if l.startswith(b'source-rows '):c.update({k.decode():int(v) for k,v in re.findall(rb'([\w-]+)=(\d+)',l)})
        if l.startswith(b'probe-select kind='):w.update({k.decode():int(v) for k,v in re.findall(rb'([\w-]+)=(\d+)',l)})
    values=[src,policy,prior,p.returncode,c['selected'],c['written'],*[n[k] for k in ('roots','entries','calls','globals','arguments','variadic','differences')],w['unsafe'],w['unobserved']]
    return values
with args.out.open('w') as f,ThreadPoolExecutor(2) as pool:
    writer=csv.writer(f,delimiter='\t',lineterminator='\n');writer.writerow(columns)
    for r in pool.map(run,expected):writer.writerow(r)
