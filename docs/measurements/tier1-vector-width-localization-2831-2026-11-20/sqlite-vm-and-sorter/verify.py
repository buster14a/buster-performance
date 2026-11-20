from pathlib import Path
import csv,hashlib,os,subprocess,sys
p=Path(__file__).resolve().parent;d=p.parent;w=d.parent;cc=Path('/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang');src=w/'compile-evidence/inputs/sqlite3.c';headers=Path('/home/david/dev/buster-corpus/sqlite');run=lambda *args,**kw:subprocess.run(list(map(str,args)),check=True,**kw);out=p/'programs';out.mkdir(exist_ok=True);os.environ.update(SOURCE_DATE_EPOCH='1792454400',LC_ALL='C',SQLITE_TMPDIR='/dev/shm');flags=['-O2','-march=znver5','-DSQLITE_THREADSAFE=0','-DSQLITE_OMIT_LOAD_EXTENSION'];pad_set=[0,16,32,48]
def sha(f):return hashlib.file_digest(f.open('rb'),'sha256').hexdigest()
def tab(f,cols,rows):
 with (p/f).open('w') as a:
  wr=csv.writer(a,delimiter='\t',lineterminator='\n');wr.writerow(cols);wr.writerows(rows)
run(cc,'-O2','-I',headers,'-c',p/'sort.c','-o',out/'driver.o');run(cc,*flags,'-c',src,'-o',out/'clang.o');text=src.read_text();anchor='static int vdbeSorterAddToTree(';point=text.index(anchor);brace=text.index('{',point);text=text[:point]+'extern void buster_sort_observe(int,int);\n'+text[point:brace+1]+'\n  buster_sort_observe(nDepth,iSeq);'+text[brace+1:];(out/'observer.c').write_text(text);run(cc,*flags,'-c',out/'observer.c','-o',out/'observed.o');cases={'clang':out/'clang.o','observer':out/'observed.o','default':d/'runs/zn-default-control.o','all16':d/'runs/zn-16-probe.o','all32':d/'runs/zn-32-probe.o','all64':d/'runs/zn-64-control.o','sorter':d/'ablation/only-1244-0.o','chacha':d/'ablation/only-174-0.o'};meta=[];programs={}
for v,obj in cases.items():
 for pad in (pad_set if v not in ('clang','observer','chacha') else [0]):
  po=out/f'pad{pad}.o';run(cc,'-x','assembler','-c','-','-o',po,input=f'.text\n.balign 256\n.space {pad},0x90\n.section .note.GNU-stack,"",@progbits\n'.encode());exe=out/f'sort-{v}-{pad}';run(cc,'-no-pie',out/'driver.o',po,obj,'-lm','-lpthread','-o',exe);nm={x[3]:x[:2] for l in run('nm','-S','--defined-only',exe,capture_output=True,text=True).stdout.splitlines() if len(x:=l.split())==4};meta.append([v,pad,sha(obj),sha(exe),*[int(x,16) for x in nm['sqlite3VdbeExec']]]);programs[v,pad]=exe
tab('programs.tsv',['variant','layout','object_sha256','program_sha256','VM_address','VM_bytes'],meta)
sizes=[4096,32768,131072];db=p/'input.db';expected={};results=[];observed=[]
if not db.exists():run(programs['clang',0],'build',p/'input.new',str(max(sizes)));(p/'input.new').replace(db)
for n in sizes:
 for mode in ['memory','spill']:
  for (v,pad),exe in programs.items():
   q=run(exe,mode,db,str(n),capture_output=True,text=True,timeout=60);h=q.stdout.strip();assert expected.setdefault((n,mode),h)==h;assert expected.setdefault((n,'either'),h)==h;results.append([n,mode,v,pad,h]);
   if v=='observer':observed.append([n,mode,q.stderr.strip().replace('\n','; ') or 'zero calls'])
  print(n,mode,expected[n,mode],flush=True)
tab('oracles.tsv',['rows','store','variant','padding','expected'],results);tab('observed-depths.tsv',['rows','store','instrumented_source_calls'],observed);print('database SHA256',sha(db))
