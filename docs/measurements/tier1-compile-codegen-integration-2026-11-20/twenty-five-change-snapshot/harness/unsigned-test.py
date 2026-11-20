from pathlib import Path
import subprocess
w=Path(__file__).resolve().parents[1];d=w/'final-candidate';file='src/buster/compiler/tier1_float_test.c';f=d/file;parent=subprocess.check_output(['git','-C',d,'show','HEAD:'+file],text=True);new=(w/'unsigned64'/file).read_text();marker='static void tier1_float_cases(Tier1EmitTest* test)';helper=new[new.index('// The real target can admit either form'):new.index(marker)]
assert parent.count(marker)==1 and 'tier1_float_unsigned_i64_forms' not in parent
s=parent.replace(marker,helper+marker).replace(marker+'\n{',marker+'\n{\n    tier1_float_unsigned_i64_forms(test);');f.write_text(s)
subprocess.run(['git','-C',d,'add',file],check=True);subprocess.run(['git','-C',d,'commit','--no-edit'],check=True)
