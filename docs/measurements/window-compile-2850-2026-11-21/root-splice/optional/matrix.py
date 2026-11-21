from pathlib import Path
import subprocess,os,hashlib,csv,sys
d=Path(__file__).resolve().parent;cc=Path(sys.argv[1]).resolve();folder=d/'generated';folder.mkdir(exist_ok=True)
types=('signed char','unsigned char','short','unsigned short','int','unsigned','long','unsigned long','_Bool')
ops=('+','-','*','&','|','^','<','==','!=','<=','>','>=')
forms=('global-write','local-write','local-addr','const-return','binary-return','argument-read','global-read','global-addr')
env=dict(os.environ,NODE_PROOF_NO_FP='1',NODE_PROOF_POINTERS='1',NODE_PROOF_CALLS='1',NODE_SPLICE_FRONT='1',NODE_SOURCE_ROWS='1',NODE_PROOF_NATIVE='1',NODE_SPLICE_ENABLE='1',NODE_SPLICE_REPORT='1')
with (d/'generated.tsv').open('w') as o:
 w=csv.writer(o,delimiter='\t',lineterminator='\n');w.writerow('group definitions policy off on takes diag elf'.split())
 for j,ty in enumerate(types):
  src=folder/f'types-{j}.c'; defs=[f'static {ty} gm=5; {ty} gx=7;']; n=0
  for k,op in enumerate(ops):
   for form in forms:
    names={'global-write':f'gx =\n a;\n return gx;', 'local-write':f'{ty} y;\n y =\n a;\n return y;', 'local-addr':f'{ty} *ptr;\n ptr=\n &a;\n return *ptr;', 'const-return':f'return\n (7 {op} 3);', 'binary-return':f'return\n a\n {op}\n b;', 'argument-read':f'return\n a;', 'global-read':'return\n gm;', 'global-addr':'return\n &gx;'}
    ret=ty+'*' if form=='global-addr' else ty
    defs.append(f'{ret} sample_{j}_{n}({ty} a,{ty} b){{\n'+names[form]+'\n}')
    n+=1
  src.write_text('\n'.join(defs)+'\n')
  for pol,flags in [('default',[]),('debug',['-g']),('wall',['-Wall','-Wextra']),('all',['-Weverything'])]:
   vals=[]
   for mode,e in [('off',os.environ),('on',env)]:
    obj=folder/f'{j}-{pol}-{mode}.o';obj.unlink(missing_ok=True)
    p=subprocess.run([cc,*flags,'-c',src,'-o',obj],env=e,capture_output=True,text=True);ls=p.stderr.splitlines()
    ds=[x for x in ls if not x.startswith(('node-proof ','source-rows ','splice-taken:','splice-local-class:','probe-select '))];h=hashlib.sha256(obj.read_bytes()).hexdigest() if obj.exists() else '-';vals.append((p.returncode,ds,h,sum(x.startswith('splice-taken:') for x in ls)))
   a,b=vals;w.writerow((ty,n,pol,a[0],b[0],b[3],int(a[1]==b[1]),int(a[2]==b[2])))
