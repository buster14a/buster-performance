from pathlib import Path
d=Path(__file__).resolve().parent
prefix = '''struct S { int a; unsigned int b:4; };
static int internal;
extern int args(int, int, int, int, int, int, int, int);
volatile int*vp;
#define WRAP(v) ((v) + 0)
'''
for mode in ('clean','warnings','rejected'):
 lines=[prefix]
 for n in range(1,82):
  u=n%7
  seq=['long double z=0x1.2p+4L;', 'struct S s = { a, 4 };', 'volatile int v=0;', 'int *p=&internal;', 'unsigned _BitInt(93) wide=((unsigned _BitInt(93))1<<72)|3;', 'int arr[2+!!a];', 'int zero=0;']
  sel=['a','s.a','s.b','!!z','(int)wide','(p==&internal)','v','sizeof(arr)>1','zero']
  vals=', '.join(sel[(i+u)%len(sel)] for i in range(8))
  chunk=[f'int f{n}(int a){{',*seq,('a=WRAP(a);'*n),'if(a>1){a+=args('+vals+');}',f'return zero + (int)wide + a + {n};','}']
  if mode=='warnings' and n%3==0: chunk[-2]=f'return (1 << {32+n%8}) + a;'
  if mode=='rejected' and n%7==0: chunk[-2]='return s + a;'
  lines.extend(chunk)
 (d/(mode+'.c')).write_text('\n'.join(lines)+'\n')
