from common import *
import csv,hashlib,json,shutil,subprocess,tarfile
tree=CC.parent.parent
def git(*a):return subprocess.check_output(['git','-C',tree,*a])
base=git('rev-parse','HEAD^').decode().strip();rev=git('rev-parse','HEAD').decode().strip();o=W/'perf/docs/measurements/window-compile-2850-2026-11-21'/rev[:9];o.mkdir(exist_ok=True)
(o/'implementation.patch').write_bytes(git('diff','--binary',base,rev))
for f in ('common.py','qualify.py','package.py','build.log'):shutil.copy(D/f,o/f)
q=D/'oracle';dest=o/'oracle';dest.mkdir(exist_ok=True)
for f in q.iterdir():
 if f.suffix in ['.tsv','.json']:shutil.copy(f,dest/f.name)
with tarfile.open(dest/'raw.tar.gz','w:gz') as t:
 for f in sorted(q.rglob('*')):
  if f.is_file():t.add(f,arcname=f.relative_to(q))
with (o/'builds.tsv').open('w') as f:t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(['mode','revision','sha256']);t.writerows([[k,r,hashlib.sha256(p.read_bytes()).hexdigest()] for k,r,p in [('prior',base,PRIOR),('corrected',rev,CC)]])
bad=json.loads((q/'failures.json').read_text());old=json.loads((q/'prior-differences.json').read_text());hist=json.loads((q/'historical.json').read_text());tests=list(csv.DictReader((q/'comparisons.tsv').open(),delimiter='\t'));src={r['input'] for r in tests};dumps={tuple(x) for x in old if x[1] in ['typed','static','both','strict']}
(o/'README.md').write_text(f'''# Keep complete typed and static output for source-native compilation

The source-local compiler `{base}` retired selected function graphs during diagnostic dumps. Their expression rows could disappear from the typed dump even when the final ELF was identical. Revision `{rev}` consults the driver’s existing ownership decision before retiring any function. The driver retains ordinary graph ownership when a complete dump or attested verification is requested. [Change](implementation.patch) and [compiler identities](builds.tsv).

The comparison exercised SQLite, Buster and {len(src)-2} directed sources across plain objects, typed dumps, static dumps, both dumps together, strict warning dumps, syntax checking and attested verification. {len(dumps)} source/mode pairs had dump differences on the parent. The corrected compiler recorded {len(bad)} differences from the ordinary reference, including admission audits. {sum(r[-1] for r in hist)}/{len(hist)} historical object identities matched. [Complete output comparisons](oracle/comparisons.tsv), [selection audits](oracle/admission.tsv), [historical objects](oracle/historical.json), [prior differences](oracle/prior-differences.json), [corrected differences](oracle/failures.json) and [all source files, stdout and stderr](oracle/raw.tar.gz).
''')
print(o,len(tests),'observations',len(old),'prior differences',len(bad),'current differences',hist)

subprocess.run(['python3',W/'source-counted-parent-study/finish-studies.py'],check=True)
