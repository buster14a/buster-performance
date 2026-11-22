from pathlib import Path
import os,subprocess,hashlib,csv
import argparse
parser=argparse.ArgumentParser(description="Compare ordinary and live diagnostic publication on 28 directed C files.")
parser.add_argument('--compiler', type=Path, required=True)
parser.add_argument('--output', type=Path, required=True)
args=parser.parse_args()
compiler=args.compiler.resolve()
cases={
'clean':'int f(int a){return a+1;} int g(void){return f(3);}',
'shift':'int f(int a,int b){return a+b<<1;}',
'overflow':'int f(void){return 2147483647+1;}',
'typeerror':'struct S {int a;}; int f(struct S s){return s+1;}',
'ptrarg':'int x(int*); int f(void){return x(3);}',
'assert':'_Static_assert(1==2,"assertion diagnostic"); int f(void){return 0;}',
'multi':'int f(int a, int b){return a+b<<1;} int g(void){return 2147483647+1;}',
'deprecated':'int old(void) __attribute__((deprecated)); int f(void){return old();}',
'unused':'int f(void){int x=1;return 3;}',
'compare':'int f(void){return 0.5==0.5;}',
'zerodiv':'int f(void){return 1/0;}',
'address':'int f(void){int i=0;return &i;}',
}
cases.update({
 'ifdead':'int f(void){if(0){return 1/0;}return 1;}',
 'afterreturn':'int f(void){return 1;return 1/0;}',
 'short':'int f(void){return 0 && (1/0);}',
 'uneval':'int f(void){return sizeof(1/0);}',
 'cond':'int f(void){return 1 ? 1 : 1/0;}',
 'uninit':'int f(int b){int x;if(b)x=3;return x;}',
 'bounds':'int f(void){int v[2]={0};return v[5];}',
 'format':'int printf(const char *,...) __attribute__((format(printf,1,2)));int f(void){return printf("%s",15);}',
 'selfassign':'int f(int x){x=x;return x;}',
 'missingreturn':'int f(int x){if(x)return 1;}',
 'unusedparam':'int f(int x){return 1;}',
 'nonnull':'int f(int*) __attribute__((nonnull)); int g(void){return f((void*)0);}',
 'varargs':'#include <stdarg.h>\nint f(int x,...){return x;}',
 'cast':'struct S{int a;}; int f(struct S s){return (int)s;}',
 'pragma':'#pragma clang diagnostic ignored "-Wshift-op-parentheses"\nint f(int x){return x+1<<2;}',
 'shadow':'int i;int f(int i){int x=i;{int i=x;return i;}}',
})
env={'BUSTER_BODY_LIVE_DIAGNOSTICS':'1','BUSTER_CHECK_BODY_SOURCE_ONLY':'1','BUSTER_CHECK_BODY_ADMIT_ALL':'1','BUSTER_CHECK_SOURCE_DECLARATIONS':'1'}
out=args.output.resolve();out.mkdir(exist_ok=True,parents=True)
with (out/'comparison.tsv').open('w') as f:
 w=csv.writer(f,delimiter='\t');w.writerow(('source','policy','local_rc','whole_rc','from_local','same'))
 for n,c in cases.items():
  p=out/(n+'.c');p.write_text(c+'\n')
  for policy,opts in [('default',[]),('wall',['-Wall','-Wextra']),('strict',['-Wall','-Wextra','-Werror']),('quiet',['-w'])]:
   result=[];receipt=out/f'{n}-{policy}.receipt';receipt.unlink(missing_ok=True)
   for label,extra in [('whole',{}),('source',{**env,'BUSTER_BODY_DIAGNOSTIC_RECEIPT':str(receipt)})]:
    cmd=[compiler,'--lanes','1','-c','-nostdinc',*opts,p,'-o',out/'unit.o']
    r=subprocess.run(cmd,env={**os.environ,**extra},capture_output=True,timeout=20)
    (out/f'{n}-{policy}.{label}.stderr').write_bytes(r.stderr)
    result.append((r.returncode,r.stdout,r.stderr))
   w.writerow((n,policy,result[1][0],result[0][0],int(receipt.exists()),int(result[0]==result[1])))

rows=list(csv.DictReader((out/'comparison.tsv').open(),delimiter='\t'))
if len(rows)!=112 or any(row['same']!='1' or row['from_local']!='1' for row in rows):
    raise SystemExit("See comparison.tsv for differences or fallback")
