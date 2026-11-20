from pathlib import Path
import csv,hashlib,itertools,subprocess,statistics
p=Path(__file__).resolve().parent;w=p.parents[1];src=Path('/home/david/dev/buster-corpus/sqlite');cc='/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang';metrics=['cycles:u','instructions:u','branches:u','branch-misses:u','task-clock']
def run(*a,**kw):return subprocess.run(list(map(str,a)),check=True,**kw)
def sha(f):return hashlib.file_digest(f.open('rb'),'sha256').hexdigest()
def write(file,header,rows):
 with (p/file).open('w') as h:t=csv.writer(h,delimiter='\t',lineterminator='\n');t.writerow(header);t.writerows(rows)
f=src/'sqlite3.c';s=f.read_text();marker='          r = (double)*(sqlite3_uint64*)&iRes;';assert s.count(marker)==1;spot=s[:s.index(marker)].count('\n')+1;(p/'counted.c').write_text(s.replace(marker,'          extern unsigned long long conversion_calls; ++conversion_calls;\n'+marker));flags=['-O2','-march=znver5','-DSQLITE_THREADSAFE=0','-DSQLITE_OMIT_LOAD_EXTENSION','-I',src]
run(cc,'-O2','-march=x86-64-v3','-fno-builtin','-I',src,'-c',p/'query.c','-o',p/'driver.o')
for v,source in [('clang',f),('counted',p/'counted.c')]:
 run(cc,*flags,'-fno-vectorize','-fno-slp-vectorize','-c',source,'-o',p/(v+'.o'))
pads=[0,16,32,48];variants=['clang','counted','base','head'];checks=[];gold={};programs=[];ex=lambda v,n:p/f'{v}-{n}'
for pad in pads:
 padobj=p/f'pad{pad}.o';run(cc,'-c','-x','assembler','-','-o',padobj,input=f'.text\n.balign 256\n.space {pad},0x90\n.section .note.GNU-stack,"",@progbits\n'.encode())
 for v in variants:
  o=p.parent/'sqlite'/(v+'-engine.o') if v in ('base','head') else p/(v+'.o');e=ex(v,pad);run(cc,'-no-pie',p/'driver.o',padobj,o,'-lm','-ldl','-pthread','-o',e)
  syms=run('nm','-S',e,capture_output=True,text=True).stdout;loc=next((z.split()[:2] for z in syms.splitlines() if z.endswith(' jsonReturnFromBlob')),['-','-']);programs.append([v,pad,sha(f),sha(o),sha(e),spot,*loc])
  for b,small in itertools.product(range(2),range(2)):
   res=run(e,b,small,4,capture_output=True,text=True).stdout.strip().split();assert res[:2]==gold.setdefault((b,small,4),res[:2]);assert int(res[2])==(8192 if v=='counted' and not small else 0);checks.append([v,pad,b,small,*res])
write('programs.tsv',['compiler','padding','source_hash','engine_hash','exe_hash','conversion_source_line','function_addr_hex','function_bytes_hex'],programs);write('checks.tsv',['compiler','pad','jsonb','small_integer_control','rows','digest','instrumented_hits'],checks)
cells=list(itertools.product(pads,range(2),range(2)));obs=[];vals={}
for r in range(8):
 for j in range(len(cells)):
  pad,b,small=cells[(j+5*r)%len(cells)]
  for v in (['head','base'] if (j+r)%2 else ['base','head']):
   f=p/'last.stat';res=run('perf','stat','--no-big-num','-x',';','-e',','.join(metrics),'-o',f,'--',ex(v,pad),b,small,12,capture_output=True,text=True).stdout.strip().split();assert res[:2]==gold.setdefault((b,small,12),res[:2]) and res[2]=='0';z={k[2]:float(k[0]) for l in f.read_text().splitlines() if len(k:=l.split(';'))>=3 and k[2] in metrics};obs.append([r,pad,b,small,v,*res[:2],*[z[m] for m in metrics]]);vals[r,pad,b,small,v]=z
 print('round',r,flush=True)
write('counters.tsv',['round','pad','jsonb','small_integer_control','compiler','rows','hash',*metrics],obs);rows=[]
for pad,b,s in cells:
 for m in metrics:
  a=[vals[r,pad,b,s,'base'][m] for r in range(1,8)];c=[vals[r,pad,b,s,'head'][m] for r in range(1,8)];ds=[100*(y/x-1) for x,y in zip(a,c) if x];rows.append([pad,b,s,m,len(ds),statistics.median(a),statistics.median(c),statistics.median(ds),min(ds),max(ds)])
write('paired.tsv',['padding','jsonb','small_integer_control','metric','pairs','parent','head','paired_percent','min_percent','max_percent'],rows)
