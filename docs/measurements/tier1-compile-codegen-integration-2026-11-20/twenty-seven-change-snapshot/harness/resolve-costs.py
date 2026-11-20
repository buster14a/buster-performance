from pathlib import Path
import re,subprocess
p=Path(__file__).resolve().parent;d=p.parent/'tip-candidate';name='src/buster/compiler/x86_zen5_rows.c';f=d/name
def rows(m):
 a,b=m.groups();assert len(a.splitlines())==1 and len(b.splitlines())==2 and 'X(CVTSI2SS_X_RM64, MEMORY_INDEX' in a and 'X(VCVTUSI2SS_X_X_RM64, REGISTER' in b and 'X(VCVTUSI2SD_X_X_RM64, REGISTER' in b;return a+b
s,n=re.subn(r'(?ms)^<<<<<<< HEAD\n(.*?)^=======\n(.*?)^>>>>>>> [^\n]+\n',rows,f.read_text());assert n==1;f.write_text(s);subprocess.run(['git','-C',d,'add',name],check=True);subprocess.run(['git','-C',d,'commit','--no-edit'],check=True)
