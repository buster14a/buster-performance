from pathlib import Path
import ast,csv,hashlib,os,subprocess
p=Path(__file__).resolve().parent;w=p.parents[1];source=(w/'x87-rom/src/buster/compiler/c_check_x87_driver_test.c').read_text();cc='/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang'
for n in ['source','harness']:
 text=source.split('static const char check_test_x87_'+n+'[] =',1)[1].split('\n\n',1)[0]
 parts=[ast.literal_eval(l.strip().rstrip(';')) for l in text.splitlines() if l.strip().startswith('"')]
 (p/(n+'.c')).write_text(''.join(parts))
def run(*a,**kw):return subprocess.run(list(map(str,a)),check=True,**kw)
def sha(f):return hashlib.file_digest(f.open('rb'),'sha256').hexdigest()
run(cc,'-std=gnu17','-O0','-ffp-contract=off','-fno-strict-aliasing','-c',p/'harness.c','-o',p/'harness.o')
rows=[]
for v,exe in [('parent',w/'x87-double/build/compiler'),('candidate',w/'x87-rom/build/compiler')]:
 for arch in ['x86-64','znver5']:
  for tier,flags in [('zero',[]),('one',['--tier1']),('post',['--tier1','--tier1-schedule=post'])]:
   f=p/f'{v}-{arch}-{tier}';o=f.with_suffix('.o');run(exe,'--verify','--lanes','1','-std=gnu17','-O2','-w','-march='+arch,*flags,'-c',p/'source.c','-o',o);run(cc,'-no-pie',p/'harness.o',o,'-o',f);a=run(f,capture_output=True,text=True,timeout=20);assert a.stdout.strip()=='0',(v,arch,tier,a.stdout);rows.append([v,arch,tier,sha(o),sha(f),a.stdout.strip()]);print(v,arch,tier,'pass',flush=True)
with (p/'comparisons.tsv').open('w') as out:
 t=csv.writer(out,delimiter='\t',lineterminator='\n');t.writerow(['compiler','architecture','tier','object_sha256','executable_sha256','reported_errors']);t.writerows(rows)
