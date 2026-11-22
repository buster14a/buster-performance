"""Measure ordinary dense, individual declarations or batched declaration checking on the same executable."""
import argparse
import os
from pathlib import Path
import subprocess
import sys

p=argparse.ArgumentParser(description=__doc__)
p.add_argument('compiler',type=Path)
p.add_argument('output',type=Path)
p.add_argument('name')
p.add_argument('control',choices=['dense','one'])
p.add_argument('limit',type=int)
p.add_argument('flags',nargs=argparse.REMAINDER)
a=p.parse_args()
a.output.mkdir(exist_ok=True,parents=True)
flags=a.flags[1:] if a.flags[:1]==['--'] else a.flags
base={k:v for k,v in os.environ.items() if not k.startswith(('BUSTER_BODY_','BUSTER_CHECK_BODY_','BUSTER_SOURCE_ROOT_BATCH'))}
base.update(BUSTER_CHECK_SOURCE_DECLARATIONS='1',BUSTER_CHECK_BODY_ADMIT_ALL='1',BUSTER_BODY_DISCARD_RESULT='1')
for n in range(1,6):
    order=[a.control,'batch','batch',a.control]
    if n%2==0: order=['batch',a.control,a.control,'batch']
    for pos,mode in enumerate(order):
        env=base.copy()
        if mode=='dense': env['BUSTER_BODY_DENSE_BOUNDARY']='1'
        else: env['BUSTER_CHECK_BODY_SOURCE_ONLY']='1'
        if mode=='batch': env['BUSTER_SOURCE_ROOT_BATCH']=str(a.limit)
        stem=a.output/f'{a.name}-{a.limit}-{n}-{pos}-{mode}'
        with stem.with_suffix('.stderr').open('wb') as err, stem.with_suffix('.stdout').open('wb') as out:
            subprocess.run([sys.executable,Path(__file__).with_name('measure.py'),stem.with_suffix('.time'),a.compiler.resolve(),'--lanes','1','-c',*flags,'-o',a.output/'unused.o'],env=env,stdout=out,stderr=err,check=True)
