from common import *
import csv,gzip,hashlib,json,re,shlex,subprocess
out=D/'operand-oracle';out.mkdir(exist_ok=True);(out/'complete').unlink(missing_ok=True);tree=CC.parent.parent;ccdb=json.loads((tree/'build/cmake/native/compile_commands.json').read_text());e=next(r for r in ccdb if r['file'].endswith('main_unit_checker.c') and 'Release' in r['output']);av=shlex.split(e['command'])
dump=subprocess.run([av[0],*[a for a in av if a.startswith(('-D','-I','-march'))],'-fsyntax-only','-Xclang','-fdump-record-layouts',e['file']],cwd=e['directory'],capture_output=True,check=True).stdout.decode().split('*** Dumping AST Record Layout')
def entry(k):return next(v for v in dump if re.search(r'^\s*0 \| struct '+k+r'\s*$',v,re.M))
def off(t,name):return int(re.search(r'^\s*(\d+) \|   [^ \n][^\n]*?\b'+name+r'\s*$',entry(t),re.M)[1])
def names(t):return int(re.search(r'\[sizeof=(\d+)',entry(t))[1])
ms=subprocess.check_output(['nm','-an',CC],text=True)
def addr(n):
 r={int(v,16) for v in re.findall(r'^([0-9a-f]+) [tT] '+n+r'(?:\.buster_split)?$',ms,re.M)};assert len(r)==1;return next(iter(r))
opsrc=(tree/'src/buster/compiler/c_check_actions.c').read_text();opblock=re.search(r'typedef enum CheckOp\s*\{(.*?)\}\s*CheckOp',opsrc,re.S)[1];opblock=re.sub(r'//[^\n]*|/\*.*?\*/','',opblock,flags=re.S);items=[re.match(r'\s*(CHECK_OP_\w+)',i).group(1) for i in opblock.split(',') if i.strip()];assert '=' not in opblock
cfg={t+'.'+k:off(t,k) for t,fields in [('CheckProgram',['input','stream','types']),('CheckInput',['graph']),('CheckGraph',['count','ops','operand0']),('CheckStream',['conversions']),('TypeColumns',['count','kind','size'])] for k in fields};cfg.update({'entry':addr('check_lower_node_counts'),'scalar':addr('check_lower_node_counts_scalar'),'stride':names('CheckNodeConversions'),'conversion_size':names('CheckConversion'),'add':items.index('CHECK_OP_ADD'),'subscript':items.index('CHECK_OP_SUBSCRIPT')});(out/'layout.json').write_text(json.dumps(cfg,indent=2))
sources={'conversion':'typedef int V __attribute__((vector_size(128)));V object; int f(int a){return a+1;}\n','left':'typedef int V __attribute__((vector_size(128)));int f(V v,int i){return v[i];}\n'}
sources['left-isolated']=sources['left']
with (out/'observations.tsv').open('w') as f:
 t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(['input','mode','perturbed','hits','builtins','integer-builtins','atomics','lane-calls','lane-arguments','transport-entries','transport-locals','ELF']);rows={}
 for key,source in sources.items():
  p=out/(key+'.c');p.write_text(source)
  for mode in ('normal','scalar'):
   for perturb in (False,True):
    slug=f'{key}.{mode}.{int(perturb)}';script=out/(slug+'.gdb');obj=out/(slug+'.o');script.write_text(f'set pagination off\nset confirm off\nset debuginfod enabled off\npython cfg={cfg!r};which={key!r};scalar={mode=="scalar"};perturb={perturb}\nsource {D}/mutate-breakpoints.py\nrun\npython print("HITS",hits)\n')
    q=subprocess.run(['gdb','-nx','-q','--batch','-x',script,'--args',CC,'--lanes','1','-c','-std=c23','-nostdinc',p,'-o',obj],env=env,cwd=ROOT,capture_output=True,timeout=120)
    for l,v in [('stdout',q.stdout),('stderr',q.stderr)]:(out/(slug+'.'+l+'.gz')).write_bytes(gzip.compress(v,mtime=0))
    got=re.findall(rb'^CAPACITY ([\d ]+)$',q.stdout,re.M);hit=re.search(rb'^HITS (\d+)$',q.stdout,re.M);assert q.returncode==0 and len(got)==1 and hit and int(hit[1])==1 and obj.exists(),(key,mode,q.stderr[-300:],q.stdout[-450:])
    row=[int(x) for x in got[0].split()];h=hashlib.sha256(obj.read_bytes()).hexdigest();obj.unlink();t.writerow([key,mode,int(perturb),int(hit[1]),*row,h]);rows[key,mode,perturb]=(row,h)
 for k in sources:
  for p in (False,True):assert rows[k,'normal',p]==rows[k,'scalar',p]
  a,h=rows[k,'normal',False];b,j=rows[k,'normal',True];assert h==j and (b[5]>a[5] if k=='conversion' else a==b if k=='left' else a[5]>b[5]),(k,a,b,h,j)

(out/'complete').write_text('all twelve scalar, production and input mutation cases passed\n')
