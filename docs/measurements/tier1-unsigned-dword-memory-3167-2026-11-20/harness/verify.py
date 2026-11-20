from pathlib import Path
import hashlib,itertools,subprocess,csv
p=Path(__file__).resolve().parent;w=p.parent;d=p/'checks';d.mkdir(exist_ok=True);cc='/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang'
def run(*a,**kw):return subprocess.run(list(map(str,a)),check=True,**kw)
def sha(f):return hashlib.file_digest(f.open('rb'),'sha256').hexdigest()
run(cc,'-O2','-ffp-model=strict','-march=x86-64','-c',p/'oracle.c','-o',d/'oracle.o');run(cc,'-c',p/'bridge.S','-o',d/'bridge.o');res=[]
for arch,schedule,v in itertools.product(['x86-64','x86-64-v2','x86-64-v3','x86-64-v4','v4-no-f','znver5'],['default','post'],['clang','parent','head']):
 if v=='clang' and schedule=='post':continue
 c=cc if v=='clang' else w/('convert' if v=='parent' else 'u32-memory')/'build/compiler';tag=f'{arch}-{schedule}-{v}';o=d/(tag+'.o');ex=d/tag
 opt=['-ffp-model=strict','-fno-vectorize','-fno-slp-vectorize'] if v=='clang' else ['--tier1','--verify','--lanes','1']+(['--tier1-schedule=post'] if schedule=='post' else [])
 run(c,*opt,*(['-march=x86-64-v4','-mno-avx512f'] if arch=='v4-no-f' else ['-march='+arch]),'-O2','-c',p/'leaves.c','-o',o);run(cc,'-no-pie',d/'oracle.o',d/'bridge.o',o,'-o',ex)
 a=run('objdump','-d','-Mintel','--no-show-raw-insn',o,capture_output=True,text=True).stdout;(d/(tag+'.asm')).write_text(a)
 result=run(ex,capture_output=True,text=True).stdout.strip();res.append([arch,schedule,v,sha(o),sha(ex),result]);print(tag,result,flush=True)
assert len(res)==30 and len({x[-1] for x in res})==1
with (p/'results.tsv').open('w') as h:t=csv.writer(h,delimiter='\t',lineterminator='\n');t.writerow(['target','schedule','compiler','object_sha256','exe_sha256','oracle']);t.writerows(res)
