from pathlib import Path
import random,subprocess,sys
root=Path(__file__).resolve().parent
candidate=Path(sys.argv[1]);ref=Path(sys.argv[2])
d=root/'line-check';d.mkdir(exist_ok=True)
header=d/'odd.h';header.write_text('#define FROM_INCLUDE(x) ((x) + __LINE__)\n')
output=[]
for seed in range(12):
 rng=random.Random(570000+seed)
 lines=['#define PICK(x) ((x)+1)\n#define M 7\n#include "odd.h"\nint sourcecase(int a, int b){\n']
 for j in range(8500):
  line=rng.choice(['a += b;','  a=(a<<1)^b;', ' a = PICK(a);',' a = a ? b : M;','  a += sizeof("##");',
   '  /*nothing #endif */ a = a-1;', '  a = FROM_INCLUDE(a);', '  a += 0xAUL;', '  a += (int)1.25e-2;',
   '  a ^= (a != b) && !b;','  a += b / *(&a);','  a /*', '  a = (int)sizeof("hello\\n");',
   '  a += __LINE__;', '   /* harmless */  ', '  a = a + b % 3;', '  a += 0;', '  a += +b;', '  a -= -b;',
   '   a = (((((a)))));', '  a = (int)sizeof(L"x");','  a += (char)42;','a += 2;', '  a += 1ul;'])
  if line.endswith('/*'):line+='\n#define NOT_A_DIRECTIVE 1\n */ += b;'
  if j%114==0:line='#if 0\n#error dead\n#if 0\n#endif\n#else\n'+line+'\n#endif'
  if j%377==0:line='#undef M\n#define M '+str(rng.randrange(8))+'\n'+line
  if j%103==0:line='a += PICK(\n'+str(j%12)+'\n);\n'+line
  if j%153==0:line='int obj_'+str(j)+' = a; (void)obj_'+str(j)+';\n'+line
  if j%49==0:line=' '*rng.randrange(500,2300)+line
  lines.append(line+'\n')
 body=''.join(lines)+'return a;\n}\n'
 # Physical length must select streaming, including seeds with short randomized bodies.
 body+=('/*'+('x'*250)+'*/\n')*((max(0,(1<<20)-len(body))//255)+4)
 src=d/'active.c';src.write_text(body)
 for policy in (['-P'],[],['-P','-Weverything']):
  results=[]
  for exe in (ref,candidate):
   run=subprocess.run([str(exe),*policy,'-I',str(d),str(src)],capture_output=True)
   results.append((run.returncode,run.stdout,run.stderr))
  if results[0]!=results[1]:
   (d/f'failure-{seed}.c').write_text(body)
   for label,r in zip(('baseline','candidate'),results):
    (d/f'failure-{seed}-{label}.out').write_bytes(r[1]);(d/f'failure-{seed}-{label}.err').write_bytes(r[2])
   print('DIFFERENCE',seed,policy,[tuple((s,len(t),len(e))) for s,t,e in results]);sys.exit(1)
  output.append((seed,' '.join(policy)))
print(len(output),'direct source randomized output and diagnostic comparisons match')
