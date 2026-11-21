"""Generates a full-expression scalar call matrix and checks actual lowered byte columns."""
import argparse, csv, os, pathlib, subprocess, tempfile, hashlib
p=argparse.ArgumentParser();p.add_argument('compiler');p.add_argument('out',type=pathlib.Path);ns=p.parse_args()
d=pathlib.Path(__file__).resolve().parent; ns.out.mkdir(exist_ok=True)
types=[('i','int','int'),('u','unsigned int','unsigned int'),('z','unsigned long','unsigned long'),('l','long','long'),('s','short','short'),('b','_Bool','_Bool'),('p','int *','int *'),('v','void','int')]
forms=['return','discard','cast','assign','twice','indirect','index','nested']
files=[];total=0
for t,ret,arg in types:
 text=[];samples=0
 for n in (0,1,2,3,4,5,6,7,8):
  name=f'call_{t}_{n}';pars=', '.join([arg]*n) or 'void';formals=', '.join(f'{arg} a{i}' for i in range(n)) or 'void';args=',\n'.join(f'a{i}' for i in range(n))
  text += [f'extern {ret} {name}({pars});',f'extern {ret} (*stored_{t}_{n})({pars});']
  for form in forms:
   if form in ('assign','index','nested') and t=='v':continue
   if form=='index' and t!='p':continue
   if form=='nested' and n!=1:continue
   expr=f'{name}(\n{args}\n)';stmt={'return':f'return {expr};','discard':f'{expr}; return;', 'cast':f'(void)({expr}); return;', 'assign':f'{ret} v; v={expr}; return v;','twice':f'{expr};\n{expr}; return;',
            'indirect':f'return stored_{t}_{n}({args});','index':f'return *({expr});','nested':f'return {name}({expr});'}[form]
   result='void' if form in ('discard','cast','twice') else 'int' if form=='index' else ret
   text.append(f'{result} gen_{form}_{t}_{n}({formals}) {{\n{stmt}\n}}\n');samples+=1
 src=ns.out/(t+'.c');src.write_text('\n'.join(text));files.append((src,samples));total+=samples
def dh(f):return hashlib.sha256(f.read_bytes()).hexdigest() if f.exists() else '-'
base={k:v for k,v in os.environ.items() if not k.startswith(('NODE_SOURCE','NODE_SPLICE','NODE_PROOF'))}
settings=dict(NODE_SPLICE_FRONT='1',NODE_SOURCE_ROWS='1',NODE_SOURCE_ONLY='1',NODE_SOURCE_STRINGS='1',NODE_SOURCE_REFRESH_POINTERS='1',NODE_PROOF_NATIVE='1',NODE_PROOF_NO_FP='1',NODE_PROOF_CALLS='1',NODE_PROOF_POINTERS='1',NODE_SPLICE_ENABLE='1',NODE_SPLICE_CALLS='1',NODE_SPLICE_REPORT='1')
if os.getenv('CALL_VIEW_TESTS'): settings['NODE_CROSS_TYPE_VIEW']='1'
with (ns.out/'results.tsv').open('w') as f,tempfile.TemporaryDirectory() as t:
 w=csv.writer(f,delimiter='\t',lineterminator='\n');w.writerow('group functions policy off on direct diag elf native'.split());tmp=pathlib.Path(t)
 for src,samples in files:
  for policy,flags in [('default',[]),('debug',['-g']),('wall',['-Wall','-Wextra']),('all',['-Weverything'])]:
   rows=[]
   for env in (base,dict(base,**settings)):
    obj=tmp/'out.o';nat=tmp/'native';obj.unlink(missing_ok=True);nat.unlink(missing_ok=True)
    command=[ns.compiler,'--lanes','1',*flags,'-c',str(src),'-o',str(obj)]
    proc=subprocess.run(command,env=dict(env,NODE_SOURCE_NATIVE_ORACLE=str(nat)),capture_output=True)
    lines=proc.stderr.splitlines(keepends=True);direct=sum(x.startswith(b'splice-direct:') for x in lines)
    diag=b''.join(x for x in lines if not x.startswith((b'node-proof ',b'source-rows ',b'splice-',b'probe-select ',b'cross-view ',b'cross-canonical ',b'cross-call-private ')))
    rows.append((proc.returncode,diag,dh(obj),dh(nat),direct))
   a,b=rows;w.writerow([src.stem,samples,policy,a[0],b[0],b[4],int(a[1]==b[1]),int(a[2]==b[2]),int(a[3]==b[3])])
print(total,'functions')
