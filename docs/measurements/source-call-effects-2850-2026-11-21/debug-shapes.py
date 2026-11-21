import csv,re,os,subprocess,sys,hashlib,struct
from pathlib import Path
cc=Path(sys.argv[1]).resolve();d=Path(sys.argv[2]).resolve();d.mkdir(parents=True,exist_ok=True)
def source():
 f=['typedef int result; typedef int word; typedef int *ptr; typedef long tall;']
 for n in range(9):
  args=', '.join('word' for _ in range(n)) or 'void'
  f.append(f'extern result f{n}({args});')
  numbers=',\n '.join(str(20+i) for i in range(n))
  names=',\n '.join('x' if i%2==0 else str(30+i) for i in range(n))
  f.append(f'result value{n}(word x) {{\n return f{n}(\n {numbers}\n );\n}}')
  f.append(f'void stmt{n}(word x) {{\n f{n}(\n {names}\n );\n}}')
 f+=['extern word mixed(word,ptr,tall,word);','result mixed_use(word a, ptr p, tall l) {return mixed(a, p, l, 11);}', 'static int inside(word x) { return x*9; }','result static_use(word val) { return inside(val); }','#define ARG 10','#define APPLY(T) f1(T)','#line 113 "virtual-source.h"','result macro_exp(void) {return APPLY(ARG);}', 'result shadowed(word x) { { typedef word local; local x = 2; return f1(x); } }']
 return '\n'.join(f)+'\n'
def sha(b):return hashlib.sha256(b).hexdigest()
def sections(obj):
 if not obj.exists():return {}
 b=obj.read_bytes();off=struct.unpack_from('<Q',b,40)[0];sz,n,st=struct.unpack_from('<HHH',b,58);rows=[struct.unpack_from('<IIQQQQIIQQ',b,off+i*sz) for i in range(n)];strs=b[rows[st][4]:rows[st][4]+rows[st][5]]
 return {strs[r[0]:strs.find(b'\0',r[0])].decode():sha(b[r[4]:r[4]+r[5]]) for r in rows if r[1]!=8}
s=d/'shapes.c';s.write_text(source())
pols={'g':['-g'],'g3':['-g3'],'modules':['-gmodules'],'dwarf4':['-gdwarf-4'],'dwarf5':['-gdwarf-5'],'line':['-gline-tables-only'],'tier':['-g','--tier1'], 'default':[]}
with (d/'matrix.tsv').open('w') as f:
 w=csv.writer(f,delimiter='\t',lineterminator='\n');w.writerow('policy mode exit calls marks identical_marks identical_stderr identical_elf changed_sections'.split())
 for pol,args in pols.items():
  orig=None
  for mode in ['plain','safe','forced','origin','reference','typedef']:
   e=dict(os.environ,BUSTER_WINDOW_CALL_LOG='1');o=d/(pol+'-'+mode+'.o');m=d/(pol+'-'+mode+'.marks')
   for p in (o,m):p.unlink(missing_ok=True)
   e['BUSTER_CALL_MARKS']=str(m)
   if mode not in ('plain','safe'):e['BUSTER_CALL_FORCE_DEBUG']='1'
   if mode in ('origin','reference','typedef'):e['BUSTER_CALL_EFFECT_FAULT']=mode
   run=subprocess.run([cc,'--lanes','1',*args,*([] if mode=='plain' else ['--node-window-calls']),'-c',s,'-o',o],env=e,capture_output=True)
   (d/(pol+'-'+mode+'.err')).write_bytes(run.stderr)
   marks=m.read_bytes().splitlines() if m.exists() else []; markers=[i.rsplit(b' ',1)[0] for i in marks]
   ds=b''.join(l for l in run.stderr.splitlines(keepends=True) if not l.startswith(b'plain-call:')); obj=o.read_bytes() if o.exists() else b'';sects=sections(o)
   vals=(markers,ds,obj,sects)
   if orig==None:orig=vals
   different=[x for x in sorted(set(sects)|set(orig[3])) if sects.get(x)!=orig[3].get(x)]
   w.writerow([pol,mode,run.returncode,len(re.findall(rb'^plain-call:',run.stderr,re.M)),len(marks),int(orig[0]==markers),int(orig[1]==ds),int(orig[2]==obj),','.join(different)])
