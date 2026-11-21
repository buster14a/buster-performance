from pathlib import Path
import sys, hashlib, subprocess, itertools
from collections import Counter
a,b,out=map(Path,sys.argv[1:])
includes=['','typedef long old;','typedef struct { int x; } datum;\n']
uses=['__func__','__FUNCTION__','__PRETTY_FUNCTION__','NAME','JOIN(__PRETTY_,FUNCTION__)','__func__','"literal"']
patterns=['const char *label(void) { return ITEM; }',
          'static const char *inner(int x){return x?ITEM:__func__;} const char *label(void){return inner(3);}',
          'const char *label(void){ const char *names[]={__FUNCTION__,ITEM,__func__};return names[1];}',
          'const char *file=ITEM; const char *label(void){return file;}',
          'const char *label(void){ return ({ const char *x=ITEM; x; });}']
stats=Counter()
with (out/'pairs.tsv').open('w') as result:
 for (ix,use), (k,template), policy in itertools.product(enumerate(uses),enumerate(patterns),['plain','debug','wide','deferred','scalar','poison']):
  path=out/'fn.c'; obj=out/'fn.o'
  flags={'plain':[],'debug':['-g'],'wide':['--lanes','3'],'deferred':['--deferred-bodies'],'scalar':['--scalar'],'poison':['--poison-arenas']}[policy]
  src='#define NAME __PRETTY_FUNCTION__\n#define JOIN_(x,y) x ## y\n#define JOIN(x,y) JOIN_(x,y)\n'+includes[(ix+k)%3]+'\n'+('int pad;\n'*((ix*63+k)%257))+template.replace('ITEM',use)+'\n'
  path.write_text(src)
  def run(cc):
   obj.unlink(missing_ok=True)
   r=subprocess.run([cc,'-c','-std=gnu17','-Wall',*flags,path,'-o',obj],capture_output=True)
   return (r.returncode,r.stdout,r.stderr,hashlib.sha256(obj.read_bytes()).hexdigest() if obj.is_file() else '')
  x=run(a); y=run(b); stats['pairs']+=1;stats['diff']+=x!=y;stats['objects']+=bool(x[3])
  print(ix,k,policy,x[0],y[0],x[3],y[3],x==y,sep='\t',file=result)
  if x!=y:print(repr((src,x[:3],y[:3])),file=sys.stderr)
print(dict(stats))
sys.exit(bool(stats['diff']))
