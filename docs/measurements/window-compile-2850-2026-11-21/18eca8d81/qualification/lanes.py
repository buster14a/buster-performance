"""Independently compare complete C source while moving syntax across both 4096-token boundaries."""
from pathlib import Path
import csv,hashlib,re,subprocess
s=Path(__file__).resolve().parent;w=s.parent;d=s/'lanes';d.mkdir(exist_ok=True)
clang='/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang'
bins={'baseline':w/'main-fbef-clean/build/compiler','candidate':w/'seed-parser-windows/build/compiler'}
program='''
typedef struct Pair { unsigned a,b; } Pair;
static unsigned f(unsigned v){
 Pair p={.a=13,.b=5}; unsigned xs[4]={1,3,5,7};
'''
operators='''
if ((v&3u) != 0u) {
  p.a ^= (v < 37u ? xs[v&3u] : ((p.b+v)>>2)) + 5u;
  v = (v + (p.a&255u)) ^ (p.b << 1);
} else {
  switch (v&7u) { case 4: v+=p.b; break; default: v|=3u; }
  p.b = (v + (p.a > p.b)) & 1023u;
}
'''
end='return (p.a+p.b+v)&255u;}\nint main(void){return (int)f(71);}\n'
sha=lambda data:hashlib.sha256(data).hexdigest()
with (s/'fixed-boundary-oracle.tsv').open('w',buffering=1) as f:
 t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(['prefix-offset','tokens','cuts','source-sha256','roles-sha256','parents-sha256','object-sha256','runtime-exit','clang-runtime-exit'])
 for offset in range(64):
  source=d/'shifted.c';source.write_text('int tentative;\n'*1050+';'*offset+program+operators*108+end)
  o=d/'shifted.o';rpath=d/'runtime';seen={}
  for label,binary in bins.items():
   g=d/(label+'.gdb');raw=d/(label+'.bin');tmpl=s/'source-depths'/(label+'-sqlite.gdb');g.write_text(tmpl.read_text().replace(str(s/'source-depths'/(label+'-sqlite.bin')),str(raw)))
   o.unlink(missing_ok=True);r=subprocess.run(['gdb','-q','--batch','-x',g,'--args',binary,'--lanes','1','-c',source,'-o',o],capture_output=True,timeout=45)
   log=r.stdout+r.stderr;(d/(label+'.log')).write_bytes(log);assert o.is_file(),(label,offset,log[-1500:])
   n=int(re.findall(rb'^source-depths (\d+) [01]$',log,re.M)[-1])
   if label=='candidate':
    ct=int(re.findall(rb'^parent-tiles (\d+) \d+$',log,re.M)[-1]);assert ct==(n-1)//4096 and ct>=2
   seen[label]=(n,*[sha(Path(str(raw)+suffix).read_bytes()) for suffix in ['.roles','.parents']],sha(o.read_bytes()))
  assert seen['candidate']==seen['baseline'],(offset,seen)
  subprocess.run([clang,'-no-pie',o,'-o',rpath],check=True,capture_output=True);actual=subprocess.run([rpath],capture_output=True,timeout=5)
  subprocess.run([clang,'-O0',source,'-o',rpath],check=True,capture_output=True);expected=subprocess.run([rpath],capture_output=True,timeout=5)
  assert (actual.returncode,actual.stdout,actual.stderr)==(expected.returncode,expected.stdout,expected.stderr)
  t.writerow([offset,n,ct,sha(source.read_bytes()),*seen['candidate'][1:],actual.returncode,expected.returncode])
