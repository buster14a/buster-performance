from pathlib import Path
import sys,os,shlex,subprocess,csv,hashlib,tempfile
d=Path(__file__).resolve().parent;cc=Path(sys.argv[1]).resolve();tag=sys.argv[2]; corpora=sys.argv[3:]; inp=Path(os.environ.get('BUSTER_CORPUS_ROOT','.')).resolve();pol=os.getenv('SPLICE_POLICY','default');flags={'default':[],'debug':['-g'],'wall':['-Wall','-Wextra'],'all':['-Weverything']}[pol]
envbase=os.environ.copy();envon=dict(envbase,NODE_PROOF_NO_FP='1',NODE_PROOF_POINTERS='1',NODE_PROOF_CALLS='1',NODE_SPLICE_FRONT='1',NODE_SOURCE_ROWS='1',NODE_PROOF_NATIVE='1',NODE_SPLICE_ENABLE='1',NODE_SPLICE_REPORT='1')
if os.environ.get('SPLICE_MUTATION'):envon[os.environ['SPLICE_MUTATION']]='1'
for corpus in corpora:
 if corpus in ('fixture','runtime'):args=[str(d/f'{corpus}.c')]
 elif corpus=='main':
  tree=Path(os.environ['BUSTER_COMPILER_SOURCE']).resolve(); args=['-march=native','-I'+str(tree/'src'),'-fwrapv','-funsigned-char','--predefines',str(d/'proof-predefines.h'),str(tree/'src/buster/compiler/main.c')]
 else:
  raw=subprocess.check_output(['bash','-c','source '+shlex.quote(str(d/'corpora.sh'))+'; printf %s "$'+corpus+'_arguments"'],cwd=inp,text=True)
  args=shlex.split(raw)
 sources=[x for x in args if x.endswith('.c')];opts=[x for x in args if not x.endswith('.c')]
 with tempfile.TemporaryDirectory() as out,(d/f'elf-{tag}-{corpus}-{pol}.tsv').open('w',buffering=1) as f:
  w=csv.writer(f,delimiter='\t',lineterminator='\n');w.writerow('unit off_rc on_rc taken kept_nodes diagnostics elf off_digest on_digest'.split())
  for src in sources:
   rows=[];obj=Path(out)/'output.o'
   for mode,env in [('off',envbase),('on',envon)]:
    obj.unlink(missing_ok=True);p=subprocess.run([cc,'--lanes','1',*flags,'-c',*opts,src,'-o',obj],env=env,capture_output=True,text=True); lines=p.stderr.splitlines()
    takes=[line for line in lines if line.startswith('splice-taken:')]; ds=[line for line in lines if not line.startswith(('node-proof ','source-rows ','splice-taken:','splice-local-class:','probe-select '))]
    if mode=='on' and corpus in ('fixture','sqlite'): (d/f'elf-{tag}-{corpus}-{pol}-{mode}.diagnostics').write_text('\n'.join(ds))
    h=hashlib.sha256(obj.read_bytes()).hexdigest() if obj.is_file() else '-'
    rows.append((p.returncode,ds,h,len(takes),sum(int(next((x[2:] for x in t.split() if x.startswith('n=')),'1')) for t in takes)))
   a,b=rows;w.writerow((Path(src).name,a[0],b[0],b[3],b[4],int(a[1]==b[1]),int(a[2]==b[2]),a[2],b[2]))
