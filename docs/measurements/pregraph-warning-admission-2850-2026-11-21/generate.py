from pathlib import Path
d=Path(__file__).resolve().parent
exprs=[
 '0','1','0u','12345678901ULL','-1','M','(I)123','n','v','p','0L','(void *)0','(int *)0','&v','&n','p+1','&p[1]','p[0]','*p',
 'n+1','n-2','n*3','n/0','n%0','n>>-1','n<<38','n>>3','n|7','~n','-n','+n','n==0','n< -1','p!=0','n&&v','v||n',
 '(char)n','(unsigned char)257','(long)p','(int *)n','(int)(long)p','(_Bool)p','(char)(long)&v',
 'n++','++n','v+=n','v=n','v=v++','(n++,n++)','n+n++','(n,1)','clean(n)','take(n)','(void)clean(n)','(void)v','(void)(n/0)',
 'n+(2*3)','(n==1)+22','0 ? n/0 : n','(__typeof__(n))n','(int){5}','({ int x=n; x+1; })','(int)(char)32768',
]
ctx={'r':('int','return {expr};'),'u':('unsigned','return {expr};'),'p':('int *','return {expr};'),'d':('void','{expr};')}
preamble='''extern int clean(int);
extern int take(int) __attribute__((warn_unused_result));
static int v;
typedef int I;
#define M (40 + 2)
'''
for typ,(ret,body) in ctx.items():
 rows=[]
 for i,expr in enumerate(exprs):
  if ret != 'void' and expr.startswith('(void)') and expr != '(void *)0':continue
  if ret != 'void' and expr in ('p[0]','*p') and ret=='int *':continue
  # Avoid hard type errors while retaining convertible integer and pointer expressions.
  if typ in ('r','u') and expr in ('p','&n','&v','p+1','&p[1]','(int *)n','(int *)0','(void *)0'):continue
  if typ=='p' and expr not in ('0','0u','0L','p','&v','&n','p+1','&p[1]','(int *)n','(int *)0','(void *)0'):continue
  rows.append(f'{ret} test_{typ}_{i}(int n, int *p) {{ '+body.format(expr=expr)+' }')
 (d/f'matrix-{typ}.c').write_text(preamble+'\n'.join(rows)+'\n')
