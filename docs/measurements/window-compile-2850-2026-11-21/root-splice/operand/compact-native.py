"""Compare observable output and the actual lowerer's final rows for each source file."""
from pathlib import Path
from argparse import ArgumentParser
import csv
import hashlib
import os
import re
import shlex
import struct
import subprocess
import tempfile

ap = ArgumentParser()
ap.add_argument('compiler', type=Path)
ap.add_argument('result', type=Path)
ap.add_argument('corpus', nargs='+')
ap.add_argument('--policy', choices=['default','debug','wall','all'], default='default')
ap.add_argument('--modes', default='ordinary,required,combined')
ap.add_argument('--mutation')
ns = ap.parse_args()
ns.compiler = ns.compiler.resolve()
here = Path(__file__).resolve().parent
inp = Path(os.environ['BUSTER_CORPUS_ROOT']).resolve()
flags = {'default': [], 'debug': ['-g'], 'wall':['-Wall','-Wextra'], 'all':['-Weverything']}[ns.policy]
base = {k:v for k,v in os.environ.items() if not k.startswith(('NODE_SPLICE','NODE_SOURCE','NODE_PROOF'))}
proof = dict(NODE_SPLICE_FRONT='1', NODE_SOURCE_ROWS='1', NODE_SOURCE_COMPACT='1', NODE_PROOF_NATIVE='1',
             NODE_PROOF_NO_FP='1', NODE_PROOF_CALLS='1', NODE_PROOF_POINTERS='1',
             NODE_SOURCE_COMPACT_REPORT='1', NODE_SPLICE_REPORT='1')
def args(corpus):
    if corpus in ('fixture','runtime','statics','callfixture','callrefuse'):
        return [str(here / (corpus+'.c'))]
    if corpus == 'main':
        tree = Path(os.environ['BUSTER_COMPILER_SOURCE']).resolve()
        return ['-march=native', '-I'+str(tree/'src'), '-fwrapv','-funsigned-char','--predefines',str(here/'proof-predefines.h'),str(tree/'src/buster/compiler/main.c')]
    env = subprocess.check_output(['bash','-c','source '+shlex.quote(str(here/'corpora.sh'))+'; printf %s "$'+corpus+'_arguments"'],cwd=inp,text=True)
    return shlex.split(env)
def digest(data):
    return hashlib.sha256(data).hexdigest()
def native(wit):
    counts = [0]*5
    pos = 0
    while pos < len(wit):
        token,rows,locals_,calls,arguments,sources = struct.unpack_from('<6I',wit,pos)
        for i,n in enumerate((1,rows,locals_,calls,arguments)):
            counts[i] += n
        pos += 24 + rows*(10+sources*4) + locals_*2 + calls*13 + arguments
    assert pos == len(wit)
    return counts
def run(src, opts,mode,tmp):
    env = dict(base)
    if mode != 'ordinary':
        env.update(proof)
        if mode in ('optional','combined','calls','fullcombined'): env['NODE_SPLICE_ENABLE']='1'
        if mode in ('calls','optional'): env.pop('NODE_SOURCE_COMPACT')
        if mode in ('full','fullcombined'): env['NODE_SOURCE_COMPACT_FULL']='1'
        if mode=='calls': env['NODE_SPLICE_CALLS']='1'
        if ns.mutation: env[ns.mutation]='1'
    obj=tmp/'unit.o'; wit=tmp/'native.dat'
    for path in (obj,wit): path.unlink(missing_ok=True)
    env['NODE_SOURCE_NATIVE_ORACLE'] = str(wit)
    p = subprocess.run([ns.compiler,'--lanes','1',*flags,'-c',*opts,src,'-o',obj],env=env,capture_output=True)
    lines=p.stderr.splitlines(keepends=True)
    info = ('node-proof ','source-rows ','splice-taken:','splice-local-class:','probe-select ','compact-taken:','compact-consumed:','compact-admit:','splice-direct:')
    diag = b''.join(x for x in lines if not x.startswith(tuple(k.encode() for k in info)))
    admitted={int(m[1]):int(m[2]) for n in lines if (m:=re.match(rb'compact-taken: token=(\d+).* removed=(\d+)',n))}
    used={int(m[1]) for n in lines if (m:=re.match(rb'compact-consumed: token=(\d+)',n))}
    splice=sum(n.startswith((b'splice-taken:',b'splice-direct:')) for n in lines)
    direct=sum(n.startswith(b'splice-direct:') for n in lines)
    data=wit.read_bytes() if wit.exists() else b''
    return [p.returncode,digest(diag),digest(obj.read_bytes()) if obj.exists() else '-',digest(data),*native(data),len(admitted),sum(admitted.values()),len(used),len(used-admitted.keys()),splice,direct]
with tempfile.TemporaryDirectory() as tmpdir, ns.result.open('w',buffering=1) as f:
    w=csv.writer(f,delimiter='\t',lineterminator='\n')
    w.writerow('corpus unit mode abi_status diagnostic_sha256 object_sha256 native_sha256 bodies rows locals calls arguments admits removed consumed unexpected_consumed total_splices direct_splices same_status same_diagnostics same_object same_native'.split())
    for corpus in ns.corpus:
        argv=args(corpus); sources=[s for s in argv if s.endswith('.c')];opts=[o for o in argv if not o.endswith('.c')]
        for src in sources:
            reference=None
            for mode in ns.modes.split(','):
                row=run(src,opts,mode,Path(tmpdir))
                if reference is None: reference=row
                w.writerow([corpus,Path(src).name,mode,*row,*[int(i==j) for i,j in zip(row[:4],reference[:4])]])
