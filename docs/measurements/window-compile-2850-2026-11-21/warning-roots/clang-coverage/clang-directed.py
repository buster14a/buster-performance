from pathlib import Path
import subprocess,re
d=Path(__file__).resolve().parent
clang='/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang'
build=d.parent/'assignment-opt-in/build'
for f in ['reach.c','pragma-reach.c','literal-edges.c','rejected.c']:
 for flags in ([],['-Wall','-Wextra'],['-Werror'],['-w']):
  rows=[]
  for exe in (clang,build/'warning-native-base',build/'warning-native-root',build/'warning-native-literals'):
   p=subprocess.run([str(exe),'-fsyntax-only',*flags,str(d/f)],capture_output=True)
   rows.append((p.returncode,[l for l in p.stderr.decode().splitlines() if re.search(r': (warning|error|note): ',l)]))
  assert all(r==rows[1] for r in rows[1:])
  verdict=rows[1]==rows[0]
  print(f,flags,verdict,len(rows[0][1]),len(rows[1][1]))
  if not verdict:
   for side,detail in zip(['clang','all-three-buster-releases'],rows): print(side,*detail[1],sep='\n')
