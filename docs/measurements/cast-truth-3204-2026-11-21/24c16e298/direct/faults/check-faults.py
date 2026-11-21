"""Check changed diagnostics against Clang and record source-observable mutations."""
import argparse
import collections
import json
import os
from pathlib import Path
import re
import subprocess

p = argparse.ArgumentParser()
p.add_argument('tree', type=Path)
p.add_argument('binary', type=Path)
p.add_argument('out', type=Path)
p.add_argument('--manifest',required=True,type=Path)
p.add_argument('--fixture',default='tests/driver/operand_diagnostics/cast_conditions.c')
a = p.parse_args()
a.out.mkdir(parents=True,exist_ok=True)
binary = a.binary.resolve()
names=json.loads(a.manifest.read_text())
clang=os.environ.get('BUSTER_QA_CLANG','clang')
fixture=a.fixture
lines = (a.tree / fixture).read_text().splitlines()
def invoke(cc, lang, label):
    env = os.environ.copy()
    env.pop('BUSTER_QA_BRANCH_FAULT',None)
    if label != 'control':
        env['BUSTER_QA_BRANCH_FAULT'] = label
    r=subprocess.run([cc,'-fsyntax-only','-fno-caret-diagnostics',f'-std={lang}',fixture],cwd=a.tree,env=env,capture_output=True,timeout=60)
    assert r.returncode==0, (cc,label,r.returncode,r.stderr)
    return r.stderr.decode()
def messages(out):
    results=collections.defaultdict(list)
    for line in out.splitlines():
        parsed=re.match(r'.*?:(\d+):(\d+): (warning|error|note): (.*)',line)
        if parsed: results[int(parsed[1])].append(tuple(parsed.groups()[1:]))
    return results
status={}
for lang in ['gnu17','c23']:
    oracle=invoke(clang,lang,'control')
    (a.out/f'{lang}-clang.log').write_text(oracle)
    for name in ['control']+names:
        result = invoke(binary,lang,name)
        (a.out/f'{lang}-{name}.log').write_text(result)
        ref, here=messages(oracle),messages(result)
        changed=sorted(l for l in set(ref)|set(here) if ref.get(l)!=here.get(l))
        if name=='control':
            assert oracle==result, (lang,changed)
        examples=[]
        for number in changed:
            m=re.search(r'\bint\s+(\w+)\(',lines[number-1])
            examples.append(m[1] if m else f'line-{number}')
        status.setdefault(name,[]).append(f'{lang}={len(changed)}'+(' ('+', '.join(examples)+')' if examples else ''))
for name,s in status.items():
    print(name,*s,sep='\t')
