from pathlib import Path
import csv,hashlib,json,os,shlex,subprocess
p=Path(__file__).resolve().parent;d=p/'official';d.mkdir(exist_ok=True);cc='/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang';names=['test_opus_api','test_opus_extensions','test_opus_padding','test_opus_encode','test_opus_decode'];rows=[]
for m in ['portable-nosp','dispatch-nosp']:
 cfg=p/m;allcmds=json.loads((cfg/'compile_commands.json').read_text())
 for t in names:
  commands=[r for r in allcmds if 'CMakeFiles/'+t+'.dir/' in r['command']];assert commands,(m,t);objects=[]
  for r in commands:
   name=d/f'{m}-{t}-{Path(r["file"]).stem}.o';args=shlex.split(r['command'])[1:];args[args.index('-o')+1]=str(name);subprocess.run([cc,'-march=x86-64-v3',*args],check=True,cwd=r['directory']);objects.append(name)
  for v in ['clang','control','candidate']:
   lib=p/'compiled'/(m+'-x86-64-v3')/v/'libopus.a';exe=d/f'{m}-{t}-{v}';subprocess.run([cc,'-no-pie',*objects,lib,'-lm','-o',exe],check=True);log=exe.with_suffix('.log');env=dict(os.environ,SEED='1387',LC_ALL='C');cmd=[exe]+(['1387'] if t in ['test_opus_encode','test_opus_decode'] else [])
   try:
    with log.open('wb') as h:r=subprocess.run(cmd,stdout=h,stderr=h,timeout=210,env=env);status=str(r.returncode)
   except subprocess.TimeoutExpired:status='timeout-210s'
   print(m,t,v,status,flush=True);rows.append([m,t,v,status,hashlib.file_digest(exe.open('rb'),'sha256').hexdigest()]);
   with (p/'official-results.tsv').open('w') as f:
    z=csv.writer(f,delimiter='\t',lineterminator='\n');z.writerow(['build','upstream_test','compiler','exit','exe_sha256']);z.writerows(rows)
