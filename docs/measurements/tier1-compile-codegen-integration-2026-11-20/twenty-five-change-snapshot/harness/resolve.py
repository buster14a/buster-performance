from pathlib import Path
import re,subprocess
p=Path(__file__).resolve().parent;w=p.parent;d=w/'final-candidate';file='src/buster/compiler/tier1_float_test.c';f=d/file;s=f.read_text()
pat=r'(?ms)^<<<<<<< HEAD\n(.*?)^=======\n(.*?)^>>>>>>> [^\n]+\n'
def resolve(m):
 a,b=m.groups()
 if 'convert from the selected base, index' in a and 'the signed memory conversion has measured' in b:
  return '                            tier1_emit_test_expect(test, !from_integer || x86_zen5_missing(records.records, records.count, BUSTER_X86_COST_ALL_COLUMNS) == 0, "the signed memory conversion has measured Zen 5 costs");\n'+a
 if a.strip()=='tier1_float_fma_factor_addresses(test);' and b.strip()=='tier1_float_fma_addend_addresses(test);':return a+b
 raise ValueError((a[:330],b[:330]))
z,n=re.subn(pat,resolve,s);assert n;f.write_text(z)
subprocess.run(['git','-C',d,'add',file],check=True);subprocess.run(['git','-C',d,'commit','--no-edit'],check=True)
