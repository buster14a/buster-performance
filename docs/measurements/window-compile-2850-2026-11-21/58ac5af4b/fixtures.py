"""Source-local static objects versus the ordinary driver and independent Clang execution."""
from pathlib import Path
from hashlib import sha256
import os,subprocess,csv,sys
p=Path(sys.argv[1]).resolve();out=p/'static-cases';out.mkdir(exist_ok=True)
clang=Path('/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang')
cc=p/'compiler'
cases={
'mutable': 'int run(int x){static int s=4;s+=x;return s;}',
'shadow':'int run(int x){static int k=5; if(x&1){static int k=6;return ++k;} return k+=2;}',
'ro-pointer':'static int a[]={3,2,8,1};int run(int x){static int *q[3]={a+2,&a[1],a};return *q[(unsigned)x%3];}',
'function':'static int add(int x){return x+3;} static int sub(int x){return x-2;} int run(int x){static int (*const fs[])(int)={add,sub};return fs[x&1](x);}',
'str':'int run(int x){static const char t[][5]={"a\\0bc","wxyz",[3]="k"};return t[x&3][(x>>2)&3];}',
'reloc':'static int v[8]={1,2,3,4,5,6,7,8};int run(int x){struct T{int n;int *p;}; static const struct T t[]={{2,&v[1]},{.p=v+4,.n=3}};return t[x&1].n+*t[x&1].p;}',
'designator':'int run(int x){static const int t[7]={[5]=8,[2]=3,[0]=6};return t[(unsigned)x%7];}',
'unsigned':'int run(int x){static unsigned char c=0x1234;return c+x;}',
'fraction':'int run(int x){static int n=1.75;return n+x;}',
'aggregate-warning':'int run(int x){struct T{unsigned char n;};static struct T k={0x1234};return k.n+x;}',
'override':'int run(int x){static int a[4]={[1]=7,[1]=5};return x+a[1];}',
'address-self':'int run(int x){static void *p=&p;return (p==&p)+x;}',
'unused':'int run(int x){static const int dead[]={1,2,3}; return x;}',
'common-name':'static int h(int x){static int k=9;return k+=x;}int run(int x){static int k=2;return h(x)-k++;}',
'cases':'int run(int x){static const int k[]={3,1,9,4,3,6,2,1};switch(x&7){case 0:return k[4]+x;case 1:return k[3]*x;case 2:return k[1]-x;case 3:return k[5]|x;case 4:return x^11;case 5:return x*3;case 6:return x>>2;default:return x+9;}}',
'bitfields':'int run(int x){struct R{unsigned a:3; signed b:5;};static struct R k[2]={{3,-2},{4,8}};return (int)k[x&1].a+k[x&1].b;}',
'tls':'int run(int x){static _Thread_local int q=3;return q+=x;}',
'null':'int run(int x){static void *p=0;static int k[8]={0};return (p!=0)+k[x&7];}',
'dynamic':'extern int f(void);int run(int x){static int k=f();return k+x;}',
'bad':'int run(int x){static int* k=3;return x+*k;}',
}
driver=out/'driver.c';driver.write_text('#include <stdio.h>\nextern int run(int); int main(void){unsigned sum=1;for(int j=0;j<99;j++)sum=sum*71u+(unsigned)run(j);printf("%u\\n",sum);return 0;}\n')
def run(cmd,env=None):return subprocess.run(cmd,capture_output=True,env=env)
hashbytes=lambda b:sha256(b).hexdigest()
with (out/'results.tsv').open('w') as tab:
 w=csv.writer(tab,delimiter='\t',lineterminator='\n');w.writerow(['case','policy','base','local','clang','owned','local_nodes','unit_nodes','same','obj','clang_execution'])
 for name,source in cases.items():
  file=out/(name+'.c');file.write_text(source+'\n')
  for policy,opts in (('default',[]),('wall',['-Wall','-Wextra']),('all',['-Weverything','-Wno-c++-compat']),('errors',['-Wall','-Wextra','-Werror'])):
   rows=[];code=[];marker={};hs=None
   for mode,tool in [('base',cc),('local',cc),('clang',clang)]:
    obj=out/(name+'.'+policy+'.'+mode+'.o');obj.unlink(missing_ok=True)
    env=os.environ|({'BUSTER_CONTROL_SOURCE_NATIVE':'1','BUSTER_CONTROL_SOURCE_AUDIT':'1'} if mode=='local' else {})
    a=run([tool,*(['--lanes','1'] if mode!='clang' else []),'-std=gnu23','-c',*opts,file,'-o',obj],env);lines=a.stderr.splitlines(keepends=True)
    diag=b''.join(v for v in lines if not v.startswith((b'control-source-summary\t',b'control-source-function\t')))
    for v in lines:
     if v.startswith(b'control-source-summary\t'):marker=dict(z.split('=') for z in v.decode().strip().split('\t')[1:])
    (out/(name+'.'+policy+'.'+mode+'.diag')).write_bytes(diag)
    hs=hashbytes(obj.read_bytes()) if obj.exists() else '-'
    rows.append((a.returncode,a.stdout,diag,hs))
    if not a.returncode and policy=='default':
     exe=out/(name+'.'+mode+'.elf');link=run([clang,driver,obj,'-o',exe]);code.append((link.returncode,b'') if link.returncode else (lambda q:(q.returncode,q.stdout))(run([exe])))
   w.writerow([name,policy,*[r[0] for r in rows],marker.get('selected','-'),marker.get('local-graph-nodes','-'),marker.get('unit-graph-nodes','-'),int(rows[0]==rows[1]),rows[0][3],int(len(code)==3 and code[0]==code[1]==code[2] and code[0][0]==0) if code else '-']);tab.flush()
