from pathlib import Path
import subprocess,itertools,hashlib,os,random,csv
p=Path(__file__).resolve().parent/'order';p.mkdir(exist_ok=True);w=p.parents[1];cc='/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang'
src=p/'offers.c';lines=['#include <stdio.h>','typedef unsigned (*fn)(unsigned);','extern unsigned replaceable(unsigned) __attribute__((weak));','__attribute__((weak)) unsigned replaceable(unsigned x){return x^739u;}']
for i in range(290):lines.append('static inline __attribute__((always_inline)) unsigned f%d(unsigned x){return x*%du+%du;}'%(i,2*i+1,3*i+11))
lines+=['__attribute__((noinline)) unsigned no_calls(unsigned x){return (x+17u)^493u;}','__attribute__((noinline)) unsigned indirect(fn p,unsigned x){return p(x);}']
orders=[list(range(290)),list(reversed(range(290))),random.Random(2829).sample(range(290),290),[0,0,1,0,64,65,255,256,16,63,128,0]*24]
for n,order in enumerate(orders):
 lines.append('__attribute__((noinline)) unsigned order%d(unsigned x){'%n)
 for i in order:lines.append('x = f%d(x);'%i)
 lines.append('return x;}')
lines+=['int main(void){unsigned h=1;for(unsigned i=0;i<100;i++)h=(h*33u+order0(i))^(order1(i)+order2(i)+order3(i)+indirect(no_calls,i)+replaceable(i));printf("%u\\n",h);return 0;}']
src.write_text('\n'.join(lines)+'\n')
def run(*a,**opts):return subprocess.run(list(map(str,a)),check=True,**opts)
def sha(f):return hashlib.file_digest(f.open('rb'),'sha256').hexdigest()
run(cc,'-O0',src,'-o',p/'reference');expected=run(p/'reference',capture_output=True,text=True).stdout
rows=[];baseline={}
for mode,lanes,hold,label in itertools.product(['default','scalar'],[1,2,4],['hold','nohold'],['parent','head']):
 tag=f'{mode}-{lanes}-{hold}-{label}';exe=w/('inline-offers' if label=='head' else 'inline-shape-cache')/'build/compiler';obj=p/(tag+'.o');out=p/tag
 args=['--tier1','-O2','-march=znver5','--lanes',str(lanes),'--tier1-report']+(['--scalar'] if mode=='scalar' else [])+(['--tier1-no-hold'] if hold=='nohold' else [])
 res=run(exe,*args,'-c',src,'-o',obj,capture_output=True,text=True);(p/(tag+'.log')).write_text(res.stdout+res.stderr);run(cc,'-no-pie',obj,'-o',out);actual=run(out,capture_output=True,text=True).stdout;assert expected==actual;hash=sha(obj);assert hash==baseline.setdefault(mode,hash);rows.append([mode,lanes,hold,label,hash,sha(out),actual.strip()])
with (p/'checks.tsv').open('w') as h:t=csv.writer(h,delimiter='\t',lineterminator='\n');t.writerow(['path','lanes','summaries','compiler','object','executable','result']);t.writerows(rows)
