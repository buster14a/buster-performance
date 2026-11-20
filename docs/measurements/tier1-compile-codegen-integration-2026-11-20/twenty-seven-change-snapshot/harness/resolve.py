from pathlib import Path
import re,subprocess
p=Path(__file__).resolve().parent;w=p.parent;d=w/'tip-candidate';name='src/buster/compiler/tier1_float_test.c';f=d/name
def resolve(m):
 a,b=m.groups();assert {a.strip(),b.strip()}=={'tier1_float_negation_operands(test);','tier1_float_unsigned_i32_storage(test);'};return a+b
out,n=re.subn(r'(?ms)^<<<<<<< HEAD\n(.*?)^=======\n(.*?)^>>>>>>> [^\n]+\n',resolve,f.read_text());assert n==1;f.write_text(out)
subprocess.run(['git','-C',d,'add',name],check=True);subprocess.run(['git','-C',d,'commit','--no-edit'],check=True)
