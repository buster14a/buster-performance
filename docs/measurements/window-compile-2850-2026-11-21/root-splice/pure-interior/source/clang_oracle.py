from pathlib import Path
import csv,hashlib,subprocess,os,re,sys,shutil
d=Path(__file__).resolve().parent;rev=sys.argv[1]
cc=d/(rev+'-compiler');p=d/rev/'clang';p.mkdir(exist_ok=True);clang=Path(os.environ.get('CLANG',shutil.which('clang') or 'clang'))
paths=[d/'fixture.c',d/'warning.c',d/'mutation.c']+sorted((d/'2549fd7dd/matrix/inputs').glob('*.c'))
policies=[[],['-Wall','-Wextra'],['-Werror','-Wall','-Wextra'],['-std=c23','-pedantic']]
sha=lambda b:hashlib.sha256(b).hexdigest()
with (p/'status.tsv').open('w') as f:
 w=csv.writer(f,delimiter='\t',lineterminator='\n');w.writerow(['case','policy','ordinary_status','option_status','clang_status','ordinary_diag','option_diag','clang_diag','same_option','same_clang'])
 for path in paths:
  for idx,fl in enumerate(policies):
   observations=[]
   for m,exe in [('ordinary',cc),('option',cc),('clang',clang)]:
    env=os.environ.copy()
    if m=='option':env['NODE_PURE_INTERIOR']='1'
    x=subprocess.run([exe,*fl,*(['-fno-color-diagnostics','-fno-caret-diagnostics'] if m=='clang' else []),'-fsyntax-only',path],env=env,capture_output=True)
    diag=b'\n'.join(l for l in x.stderr.splitlines() if re.match(rb'.+:\d+:\d+: (warning|error|note): ',l));observations.append((x.returncode,sha(diag)))
   w.writerow([path.name,idx,*[r[0] for r in observations],*[r[1] for r in observations],observations[0]==observations[1],observations[0]==observations[2]])
  f.flush()
