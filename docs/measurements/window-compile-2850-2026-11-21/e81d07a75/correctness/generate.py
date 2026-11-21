from pathlib import Path
import itertools
here=Path(__file__).resolve().parent
T=['int','unsigned int','char','unsigned char','short','unsigned short','long','unsigned long','long long','_Bool','int *','const char *','int **','__int128','long double','_BitInt(13)']
out=[];m=0
for index,t in enumerate(T):
 for n in (0,1,2,3,6,7,8,9):
  name=f'visit_{index}_{n}'
  pars=','.join(f'{t} a{x}' for x in range(n)) or 'void';args=','.join(f'a{x}' for x in range(n))
  ty=f'Sig_{index}_{n}';out.append(f'typedef {t} {ty}({pars}); extern {ty} {name}; {ty} *hold_{name};')
  if n==0:
   out.append(f'{t} ret_{name}(void) {{ return {name}(); }}')
   out.append(f'void drop_{name}(void) {{ {name}(); }}')
  else:
   out.append(f'{t} ret_{name}({pars}) {{ return {name}(\n{args}); }}')
   out.append(f'void drop_{name}({pars}) {{ {name}(\n{args}); }}')
  m+=2
for n in (1,2,3,4,5,6,7,8):
 for mode in range(4):
  name=f'var_{n}_{mode}';pars=','.join(f'int a{x}' for x in range(n))
  args=','.join(str(1+x) if (x+mode)%3==0 else f'a{(x+mode)%n}' for x in range(n))
  out.append(f'typedef int F_{name}({pars}); extern F_{name} {name}; F_{name} *hold_{name};')
  out.append(f'int ret_{name}({pars}) {{ return {name}({args}); }}')
  out.append(f'void drop_{name}({pars}) {{ {name}({args}); }}')
  m+=2
(here/'generated.c').write_text('\n'.join(out)+'\n')
print(m)
