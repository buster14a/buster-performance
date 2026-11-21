from pathlib import Path
out=Path(__file__).resolve().parent
f=(out/'generated.c').open('w')
print('extern void sink(int); extern void store(int*); int glob; struct S {int x;}; struct S z;',file=f)
n=0
def row(parameters,body,ret='int'):
 global n
 print(f'{ret} f{n}({parameters}) {{ {body} }}',file=f)
 n+=1
for pred in ['0','1','(int)0','!0','glob','(glob && 0)','(glob || 1)','(1 && glob)','(0 || glob)','(glob*0)','(glob-glob)','!!glob','(0?glob:1)','(1?glob:0)','((unsigned int)glob < 0)','(int)(long)&glob','(long)&glob','(unsigned char)(long)&glob','(0,1)','(1,0)']:
 for expr in ['a','a++','a=1','(a=4)+a','a & glob']:
  for op in ['left && right','left || right','left ? right : 7','left ? 7 : right']:
   x=op.replace('left',pred).replace('right','('+expr+')')
   row('int a',f'return {x};')
   row('int a',f'sink({x}); return 0;')
for lhs in ['a','*p','z.x','p[1]']:
 for op in ['++','--',' += 1',' -= 2','=3']:
  for where in ['act; return a;','return act;','sink(act); return a;','return 1; act;','for(; a ;) { act; } return 0;','for(; a ;) { if(a>2) act; } return a;']:
   row('int a, int *p',where.replace('act',lhs+op))
for typ,var in [('int','a'),('int','z.x'),('int','glob'),('int','v[1]')]:
 row('int a',f'int v[3]; return &{var};', 'int *')
print(n)
